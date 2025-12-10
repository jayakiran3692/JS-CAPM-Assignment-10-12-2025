const cds = require('@sap/cds')

module.exports = cds.service.impl(async (srv) => {

  const { Projects, Milestones, Tasks, TimeEntries, Issues } = cds.entities('pm')
  const { SELECT, INSERT, UPDATE } = cds

  const txFor = (req) => cds.transaction(req)

  // --- Allowed values --------------------------------------------------------
  const PROJECT_STATUSES   = ['PLANNED', 'IN_PROGRESS', 'ON_HOLD', 'COMPLETED', 'CANCELLED']
  const MILESTONE_STATUSES = ['PLANNED', 'IN_PROGRESS', 'DONE', 'CANCELLED']
  const TASK_PRIORITIES    = ['LOW', 'MEDIUM', 'HIGH', 'CRITICAL']
  const TASK_STATUSES      = ['OPEN', 'IN_PROGRESS', 'BLOCKED', 'DONE', 'CANCELLED']
  const ISSUE_SEVERITIES   = ['LOW', 'MEDIUM', 'HIGH', 'CRITICAL']
  const CURRENCIES         = ['USD', 'EUR', 'INR', 'GBP', 'JPY']   // extend as needed

  // ---------------------------------------------------------------------------
  // Helper: create Issue entry
  // ---------------------------------------------------------------------------
  async function writeIssue (req, { projectId, taskId, type, severity, title, description }) {
    const tx = txFor(req)
    await tx.run(
      INSERT.into(Issues).entries({
        project_ID : projectId || null,
        task_ID    : taskId || null,
        type,
        severity,
        title,
        description,
        reportedBy : req.user?.id || 'system',
        owner      : req.user?.id || 'system'
      })
    )
  }

  // ---------------------------------------------------------------------------
  // PROJECTS – CREATE / UPDATE / DELETE
  // ---------------------------------------------------------------------------

  srv.before('CREATE', 'Projects', async (req) => {
    const data = req.data

    if (!data.name || !data.name.trim()) {
      req.error(400, 'Project name is mandatory')
    }

    if (!data.customerName || !data.customerName.trim()) {
      req.error(400, 'Customer name is mandatory')
    }

    // Auto-generate code if missing
    if (!data.code) {
      data.code = 'PRJ-' + Date.now().toString().slice(-6)
    }

    // Default status
    if (!data.status) {
      data.status = 'PLANNED'
    }

    // Status must be from list
    if (!PROJECT_STATUSES.includes(data.status)) {
      req.error(400, `Invalid project status. Allowed: ${PROJECT_STATUSES.join(', ')}`)
    }

    // Budget / currency
    if (data.budget != null && data.budget < 0) {
      req.error(400, 'Budget cannot be negative')
    }

    if (data.currency) {
      data.currency = data.currency.toUpperCase()
      if (data.currency.length !== 3 || !CURRENCIES.includes(data.currency)) {
        req.error(400, `Invalid currency. Allowed: ${CURRENCIES.join(', ')}`)
      }
    }

    // Dates
    if (data.startDate && data.endDate && data.endDate < data.startDate) {
      req.error(400, 'endDate cannot be before startDate')
    }
  })

  srv.before('UPDATE', 'Projects', async (req) => {
    const data = req.data

    if ('status' in data && !PROJECT_STATUSES.includes(data.status)) {
      req.error(400, `Invalid project status. Allowed: ${PROJECT_STATUSES.join(', ')}`)
    }

    if ('budget' in data && data.budget < 0) {
      req.error(400, 'Budget cannot be negative')
    }

    if (data.currency) {
      data.currency = data.currency.toUpperCase()
      if (data.currency.length !== 3 || !CURRENCIES.includes(data.currency)) {
        req.error(400, `Invalid currency. Allowed: ${CURRENCIES.join(', ')}`)
      }
    }

    // For updates we may only get one of the dates, so fetch the other
    if ('startDate' in data || 'endDate' in data) {
      const id = req.data.ID || req.params?.[0]?.ID
      const existing = await SELECT.one.from(Projects).where({ ID: id })

      const start = 'startDate' in data ? data.startDate : existing?.startDate
      const end   = 'endDate'   in data ? data.endDate   : existing?.endDate

      if (start && end && end < start) {
        req.error(400, 'endDate cannot be before startDate')
      }
    }
  })

  // Safety check before deleting a project
  srv.before('DELETE', 'Projects', async (req) => {
    const projectId = req.data?.ID || req.params?.[0]?.ID
    if (!projectId) return

    const tx = txFor(req)
    const { cnt } = await tx.run(
      SELECT.one`count(*) as cnt`.from(Milestones).where({ project_ID: projectId })
    )

    if (cnt > 0 && req.data?.force !== true) {
      req.reject(
        409,
        `Project has ${cnt} milestone(s). Set {"force": true} in body to force delete.`
      )
    }
  })

  // Log an issue after delete
  srv.after('DELETE', 'Projects', async (_, req) => {
    const projectId = req.data?.ID || req.params?.[0]?.ID
    if (!projectId) return

    await writeIssue(req, {
      projectId,
      type       : 'CHANGE',
      severity   : 'HIGH',
      title      : 'Project deleted',
      description: 'Project was deleted including its milestones and tasks.'
    })
  })

  // Enrich read result with milestone count (for convenience in UI)
  srv.after('READ', 'Projects', (each) => {
    if (!each || !each.Milestones) return
    each.milestoneCount = each.Milestones.length
  })

  // ---------------------------------------------------------------------------
  // MILESTONES – CREATE / UPDATE
  // ---------------------------------------------------------------------------

  srv.before(['CREATE', 'UPDATE'], 'Milestones', async (req) => {
    const data = req.data

    if (!data.title || !data.title.trim()) {
      req.error(400, 'Milestone title is mandatory')
    }

    if (!data.plannedDate) {
      req.error(400, 'Milestone plannedDate is mandatory')
    }

    // Status default + validation
    if (!data.status) {
      data.status = 'PLANNED'
    }
    if (!MILESTONE_STATUSES.includes(data.status)) {
      req.error(400, `Invalid milestone status. Allowed: ${MILESTONE_STATUSES.join(', ')}`)
    }

    // Ensure it has a project and plannedDate is within project dates
    const projectId = data.project_ID || req._old?.project_ID || null
    if (!projectId) {
      req.error(400, 'Milestone must be assigned to a project')
      return
    }

    const project = await SELECT.one.from(Projects).where({ ID: projectId })
    if (!project) {
      req.error(404, 'Parent project not found')
      return
    }

    if (project.startDate && data.plannedDate < project.startDate) {
      req.error(400, 'Milestone plannedDate cannot be before project startDate')
    }
    if (project.endDate && data.plannedDate > project.endDate) {
      req.error(400, 'Milestone plannedDate cannot be after project endDate')
    }
  })

  // ---------------------------------------------------------------------------
  // TASKS – CREATE / UPDATE
  // ---------------------------------------------------------------------------

  // General restrictions (both create and update)
  srv.before(['CREATE', 'UPDATE'], 'Tasks', (req) => {
    // spentHrs is calculated from TimeEntries
    if ('spentHrs' in req.data) {
      req.reject(400, 'spentHrs is read-only and calculated from TimeEntries')
    }
  })

  // CREATE-specific validations
  srv.before('CREATE', 'Tasks', async (req) => {
    const data = req.data

    if (!data.title || !data.title.trim()) {
      req.error(400, 'Task title is mandatory')
    }

    if (!data.milestone_ID) {
      req.error(400, 'Task must be assigned to a milestone')
    } else {
      const milestone = await SELECT.one.from(Milestones).where({ ID: data.milestone_ID })
      if (!milestone) {
        req.error(404, 'Parent milestone not found')
      }
    }

    if (!data.priority) data.priority = 'MEDIUM'
    if (!TASK_PRIORITIES.includes(data.priority)) {
      req.error(400, `Invalid task priority. Allowed: ${TASK_PRIORITIES.join(', ')}`)
    }

    if (!data.status) data.status = 'OPEN'
    if (!TASK_STATUSES.includes(data.status)) {
      req.error(400, `Invalid task status. Allowed: ${TASK_STATUSES.join(', ')}`)
    }

    if (data.estimateHrs != null && data.estimateHrs < 0) {
      req.error(400, 'estimateHrs cannot be negative')
    }
  })

  // UPDATE-specific validations
  srv.before('UPDATE', 'Tasks', (req) => {
    const data = req.data

    if ('priority' in data && !TASK_PRIORITIES.includes(data.priority)) {
      req.error(400, `Invalid task priority. Allowed: ${TASK_PRIORITIES.join(', ')}`)
    }

    if ('status' in data && !TASK_STATUSES.includes(data.status)) {
      req.error(400, `Invalid task status. Allowed: ${TASK_STATUSES.join(', ')}`)
    }

    if ('estimateHrs' in data && data.estimateHrs < 0) {
      req.error(400, 'estimateHrs cannot be negative')
    }
  })

  // After UPDATE: if task becomes BLOCKED, automatically create an Issue
  srv.after('UPDATE', 'Tasks', async (result, req) => {
    if (req.data?.status === 'BLOCKED') {
      // Find related project via milestone
      const tx = txFor(req)
      const milestone = await tx.run(
        SELECT.one.from(Milestones).columns('project_ID').where({ ID: result.milestone_ID })
      )

      const projectId = milestone?.project_ID || null

      await writeIssue(req, {
        projectId,
        taskId     : result.ID,
        type       : 'ISSUE',
        severity   : 'MEDIUM',
        title      : 'Task blocked',
        description: `Task "${result.title}" was set to BLOCKED`
      })
    }
  })

  // ---------------------------------------------------------------------------
  // TIME ENTRIES – CREATE
  // ---------------------------------------------------------------------------

  srv.before('CREATE', 'TimeEntries', async (req) => {
    const data = req.data

    if (!data.task_ID) {
      req.error(400, 'Time entry must be linked to a task')
    } else {
      const task = await SELECT.one.from(Tasks).where({ ID: data.task_ID })
      if (!task) req.error(404, 'Task not found for time entry')
    }

    if (data.hours == null || data.hours <= 0) {
      req.error(400, 'hours must be > 0')
    }
    if (data.hours > 24) {
      req.error(400, 'hours cannot exceed 24 for a single day')
    }

    if (!data.workDate) {
      req.error(400, 'workDate is mandatory')
    } else if (data.workDate > new Date().toISOString().slice(0, 10)) {
      // simple check: no future dates (YYYY-MM-DD strings compare lexicographically)
      req.error(400, 'workDate cannot be in the future')
    }

    if (!data.recordedBy || !data.recordedBy.trim()) {
      req.error(400, 'recordedBy is mandatory')
    }
  })

  // After CREATE: recalculate spentHrs on task
  srv.after('CREATE', 'TimeEntries', async (entry, req) => {
    const taskId = entry.task_ID
    if (!taskId) return

    const tx = txFor(req)

    const { total } = await tx.run(
      SELECT.one`sum(hours) as total`.from(TimeEntries).where({ task_ID: taskId })
    )

    await tx.run(
      UPDATE(Tasks).set({ spentHrs: total || 0 }).where({ ID: taskId })
    )
  })

  // ---------------------------------------------------------------------------
  // ISSUES – CREATE
  // ---------------------------------------------------------------------------

  srv.before('CREATE', 'Issues', (req) => {
    const data = req.data

    if (!data.title || !data.title.trim()) {
      req.error(400, 'Issue title is mandatory')
    }

    // At least a project or task reference should be present
    if (!data.project_ID && !data.task_ID) {
      req.error(400, 'Issue must be related to a project or a task')
    }

    if (!data.type) {
      data.type = 'ISSUE'
    }

    if (!data.severity) {
      data.severity = 'LOW'
    }
    if (!ISSUE_SEVERITIES.includes(data.severity)) {
      req.error(400, `Invalid issue severity. Allowed: ${ISSUE_SEVERITIES.join(', ')}`)
    }
  })

})
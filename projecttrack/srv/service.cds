using pm from '../db/schema';

service ProjectService  {
  @(odata.draft.enabled:true)
  entity Projects    as projection on pm.Projects;
  entity Milestones  as projection on pm.Milestones;
  entity Tasks       as projection on pm.Tasks;
  entity TimeEntries as projection on pm.TimeEntries;
  entity Issues      as projection on pm.Issues;
}
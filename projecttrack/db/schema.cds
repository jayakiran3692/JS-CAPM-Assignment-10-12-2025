using { cuid, managed } from '@sap/cds/common';

namespace pm;

entity Projects : cuid, managed {
  name        : String(100);
  code        : String(20);
  customerName: String(100);
  startDate   : Date;
  endDate     : Date;
  status      : String(20);
  budget      : Decimal(15,2);
  currency    : String(3);

  Milestones  : Composition of many Milestones on Milestones.project = $self;
}

entity Milestones : cuid, managed {
  title       : String(100);
  plannedDate : Date;
  status      : String(20);

  project     : Association to Projects;

  Tasks       : Composition of many Tasks on Tasks.milestone = $self;
}

entity Tasks : cuid, managed {
  title       : String(100);
  description : String(255);
  priority    : String(10);
  status      : String(20);
  estimateHrs : Decimal(10,2);
  spentHrs    : Decimal(10,2);

  milestone   : Association to Milestones;

  TimeEntries : Composition of many TimeEntries on TimeEntries.task = $self;
}

entity TimeEntries : cuid, managed {
  workDate    : Date;
  hours       : Decimal(5,2);
  notes       : String(255);
  recordedBy  : String(80);

  task        : Association to Tasks;
}

entity Issues : cuid, managed {
  type        : String(20);
  severity    : String(20);
  title       : String(100);
  description : String(255);
  reportedBy  : String(80);
  owner       : String(80);

  project     : Association to Projects;
  task        : Association to Tasks;
}
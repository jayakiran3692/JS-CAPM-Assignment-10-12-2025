using { so.ust as db } from '../db/schema';

@path: 'master'
service MasterDataService {

  @readonly
  entity BusinessPartners as projection on db.BusinessPartners;

  @readonly
  entity Materials as projection on db.Materials;
}

@path: 'sales'
service SalesService {
  entity EnquiryHeaders as projection on db.SalesEnquiryHeaders;
  entity EnquiryItems as projection on db.SalesEnquiryItems;
  entity SalesOrderHeaders as projection on db.SalesOrderHeaders;
  entity SalesOrderItems as projection on db.SalesOrderItems;
}

@path: 'purchase'
service PurchaseService {
  entity PurchaseOrderHeaders as projection on db.PurchaseOrderHeaders;
  entity PurchaseOrderItems as projection on db.PurchaseOrderItems;
  }

@path: 'monitor'
service MonitoringService {
  entity AuditLogs as projection on db.SalesAuditLogs;
}
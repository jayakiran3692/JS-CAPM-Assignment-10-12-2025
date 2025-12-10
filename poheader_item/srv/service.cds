using { my.po as db } from '../db/schema';

service PurchaseOrderService {
  @(odata.draft.enabled:true)
  entity POHeaders as projection on db.POHeaders;
  entity POItems   as projection on db.POItems;
}
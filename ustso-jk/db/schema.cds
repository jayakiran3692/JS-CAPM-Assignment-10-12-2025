using { cuid, managed } from '@sap/cds/common';

namespace so.ust;

type Currency      : String(3);
type UoM           : String(3);
type DocumentStatus: String(20);
type DeliveryStatus: String(20);
type ErrorSeverity : String(10);

@Common.Label: 'Address'
aspect Address {
  bpAddress_street  : String(100);
  bpAddress_city    : String(50);
  bpAddress_region  : String(50);
  bpAddress_country : String(3);
  bpAddress_postal  : String(10);
}

@Common.Label: 'Application Audit Info'
aspect AuditInfo {
  auditInfo_createdByApp : String(60);
  auditInfo_createdAtApp : Timestamp;
  auditInfo_approvedBy   : String(60);
  auditInfo_approvedAt   : Timestamp;
  auditInfo_changedByApp : String(60);
  auditInfo_changedAtApp : Timestamp;
}

@Common.Label: 'Posting Info'
aspect PostingInfo {
  postingInfo_postedBy    : String(60);
  postingInfo_postedAt    : Timestamp;
  postingInfo_reversedBy  : String(60);
  postingInfo_reversedAt  : Timestamp;
}

@Common.Label: 'Business Partner'
entity BusinessPartners : cuid, managed, Address {
  @Common.Label: 'BP Code'
  bpCode     : String(20);

  @Common.Label: 'Business Partner Name'
  bpName     : String(111);

  @Common.Label: 'BP Type (Customer / Vendor)'
  bpType     : String(10);        

  @Common.Label: 'E-Mail'
  email      : String(150);

  phone      : String(30);

  @Common.Label: 'GST Number'
  gstNumber  : String(20);

  @Common.Label: 'Payment Terms Code'
  paymentTerms_code : String(10);

  @Common.Label: 'Payment Terms Text'
  paymentTerms_text : String(60);

  @Common.Label: 'Is Active'
  isActive   : Boolean default true;

  @Common.Label: 'Sales Enquiries'
  enquiries  : Composition of many SalesEnquiryHeaders
                on enquiries.bp = $self;

  @Common.Label: 'Sales Orders'
  salesOrders: Composition of many SalesOrderHeaders
                on salesOrders.bp = $self;

  @Common.Label: 'Purchase Orders'
  purchaseOrders: Composition of many PurchaseOrderHeaders
                on purchaseOrders.bp = $self;
}

@Common.Label: 'Material'
entity Materials : cuid, managed {
  @Common.Label: 'Material Code'
  materialCode : String(30);

  @Common.Label: 'Material Description'
  materialDesc : String(200);

  @Common.Label: 'Material Group'
  materialGroup: String(20);

  @Common.Label: 'Base Unit of Measure'
  baseUoM      : UoM;

  @Common.Label: 'Sales Unit of Measure'
  salesUoM     : UoM;

  @Common.Label: 'Standard Price'
  standardPrice: Decimal(15,3);

  @Common.Label: 'Sales Price'
  salesPrice   : Decimal(15,3);

  currency     : Currency;

  @Common.Label: 'Is Active'
  isActive     : Boolean default true;


  enquiryItems : Association to many SalesEnquiryItems
                  on enquiryItems.material = $self;

  salesItems   : Association to many SalesOrderItems
                  on salesItems.material = $self;

  poItems      : Association to many PurchaseOrderItems
                  on poItems.material = $self;
}

@Common.Label: 'Sales Enquiry Header'
entity SalesEnquiryHeaders : cuid, managed, AuditInfo {
  @Common.Label: 'Enquiry Number'
  enquiryNumber : String(30);

  @Common.Label: 'Business Partner'
  bp            : Association to BusinessPartners;

  @Common.Label: 'Customer Code'
  customerCode  : String(20);

  @Common.Label: 'Enquiry Date'
  enquiryDate   : Date;

  @Common.Label: 'Valid To'
  validTo       : Date;

  currency      : Currency;

  @Common.Label: 'Total Value'
  @Core.Computed: true
  totalValue    : Decimal(15,3);

  @Common.Label: 'Status'
  status        : DocumentStatus;    

  remarks       : String(255);


  @Common.Label: 'Items'
  items         : Composition of many SalesEnquiryItems
                    on items.header = $self;
}

@Common.Label: 'Sales Enquiry Item'
entity SalesEnquiryItems : cuid, managed {
  @Common.Label: 'Header'
  header       : Association to SalesEnquiryHeaders;

  @Common.Label: 'Item Number'
  itemNo       : Integer;

  @Common.Label: 'Material'
  material     : Association to Materials;

  materialCode : String(30);
  materialDesc : String(200);

  quantity     : Decimal(15,3);
  uom          : UoM;

  netPrice         : Decimal(15,3);
  discountPercent  : Decimal(5,2);
  @Core.Computed: true
  lineNetAmount    : Decimal(15,3);

  status       : DocumentStatus;
}


@Common.Label: 'Sales Order Header'
entity SalesOrderHeaders : cuid, managed, AuditInfo, PostingInfo {
  @Common.Label: 'Sales Order Number'
  soNumber     : String(30);

  @Common.Label: 'Business Partner (Customer)'
  bp           : Association to BusinessPartners;

  customerCode : String(20);

  @Common.Label: 'Reference Enquiry'
  refEnquiry   : Association to SalesEnquiryHeaders;

  docDate               : Date;
  requestedDeliveryDate : Date;

  currency      : Currency;
  paymentTerms_code : String(10);
  paymentTerms_text : String(60);

  @Core.Computed: true
  totalNetAmount   : Decimal(15,3);

  @Core.Computed: true
  totalTaxAmount   : Decimal(15,3);

  @Core.Computed: true
  totalGrossAmount : Decimal(15,3);

  status   : DocumentStatus;
  remarks  : String(255);


  @Common.Label: 'Items'
  items    : Composition of many SalesOrderItems
              on items.header = $self;

  auditLogs: Association to many SalesAuditLogs
              on auditLogs.salesOrder = $self;
}

@Common.Label: 'Sales Order Item'
entity SalesOrderItems : cuid, managed {
  @Common.Label: 'Header'
  header       : Association to SalesOrderHeaders;

  @Common.Label: 'Item Number'
  itemNo       : Integer;

  @Common.Label: 'Material'
  material     : Association to Materials;

  materialCode : String(30);
  materialDesc : String(200);

  quantity     : Decimal(15,3);
  uom          : UoM;

  netPrice        : Decimal(15,3);
  discountPercent : Decimal(5,2);
  taxPercent      : Decimal(5,2);

  @Core.Computed: true
  lineNetAmount   : Decimal(15,3);

  @Core.Computed: true
  lineTaxAmount   : Decimal(15,3);

  @Core.Computed: true
  lineGrossAmount : Decimal(15,3);

  deliveryStatus  : DeliveryStatus;
}

@Common.Label: 'Purchase Order Header'
entity PurchaseOrderHeaders : cuid, managed, AuditInfo, PostingInfo {
  @Common.Label: 'Purchase Order Number'
  poNumber     : String(30);

  @Common.Label: 'Business Partner (Vendor)'
  bp           : Association to BusinessPartners;

  vendorCode   : String(20);

  @Common.Label: 'Reference Sales Order'
  refSalesOrder: Association to SalesOrderHeaders;

  docDate               : Date;
  requestedDeliveryDate : Date;

  currency      : Currency;
  paymentTerms_code : String(10);
  paymentTerms_text : String(60);

  @Core.Computed: true
  totalNetAmount   : Decimal(15,3);
  @Core.Computed: true
  totalTaxAmount   : Decimal(15,3);
  @Core.Computed: true
  totalGrossAmount : Decimal(15,3);

  status   : DocumentStatus;
  remarks  : String(255);

  @Common.Label: 'Items'
  items    : Composition of many PurchaseOrderItems
              on items.header = $self;

  auditLogs: Association to many SalesAuditLogs
              on auditLogs.purchaseOrder = $self;
}

@Common.Label: 'Purchase Order Item'
entity PurchaseOrderItems : cuid, managed {
  @Common.Label: 'Header'
  header       : Association to PurchaseOrderHeaders;

  @Common.Label: 'Item Number'
  itemNo       : Integer;

  @Common.Label: 'Material'
  material     : Association to Materials;

  materialCode : String(30);
  materialDesc : String(200);

  quantity     : Decimal(15,3);
  uom          : UoM;

  netPrice        : Decimal(15,3);
  discountPercent : Decimal(5,2);
  taxPercent      : Decimal(5,2);

  @Core.Computed: true
  lineNetAmount   : Decimal(15,3);
  @Core.Computed: true
  lineTaxAmount   : Decimal(15,3);
  @Core.Computed: true
  lineGrossAmount : Decimal(15,3);

  deliveryStatus  : DeliveryStatus;
}

@Common.Label: 'Sales / Purchase Audit Log'
entity SalesAuditLogs : cuid, managed {
  @Common.Label: 'Sales Order'
  salesOrder    : Association to SalesOrderHeaders;

  @Common.Label: 'Purchase Order'
  purchaseOrder : Association to PurchaseOrderHeaders;

  @Common.Label: 'Business Partner'
  bp            : Association to BusinessPartners;

  errorCode     : String(20);
  errorMessage  : String(500);

  @Common.Label: 'Context Object Name'
  contextObject : String(50);   

  @Common.Label: 'Context Key'
  contextKey    : String(50);   

  technicalDetails : String(1000);

  severity      : ErrorSeverity;    
  status        : DocumentStatus;  

  auditTrail_createdByApp : String(60);
  auditTrail_createdAtApp : Timestamp;
  auditTrail_approvedBy   : String(60);
  auditTrail_approvedAt   : Timestamp;
  auditTrail_changedByApp : String(60);
  auditTrail_changedAtApp : Timestamp;
}
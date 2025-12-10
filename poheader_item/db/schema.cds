namespace my.po;

using { managed, cuid } from '@sap/cds/common';

entity POHeaders : cuid, managed {

  poNumber           : String(10) @mandatory
                       @assert.format: '^[0-9]{10}$';       
  companyCode        : String(4)  @mandatory
                       @assert.format: '^[0-9A-Z]{4}$';
  purchasingOrg      : String(4)  @mandatory
                       @assert.format: '^[0-9A-Z]{4}$';
  purchasingGroup    : String(3)
                       @assert.format: '^[0-9A-Z]{3}$';
  vendorId           : String(10) @mandatory
                       @assert.format: '^V[0-9]{9}$';      
  vendorName         : String(80);
  docType            : String(4);
  docDate            : Date;
  postingDate        : Date;
  currency           : String(3)  @mandatory
                       @assert.format: '^[A-Z]{3}$';        
  exchangeRate       : Decimal(9,5);
  paymentTerms       : String(4);
  incoterms          : String(3);
  reference          : String(16);
  status             : String(1)
                       @assert.format: '^[ONRC]$';         
  totalAmount        : Decimal(15,2);
  quantityTotal      : Decimal(15,3);
  plant              : String(4)
                       @assert.format: '^[0-9A-Z]{4}$';
  createdByApp       : String(20);
  headerNote         : String(255);

  items : Composition of many POItems
    on items.header = $self;
}

entity POItems : cuid, managed {
  header             : Association to POHeaders;

  itemNumber         : Integer     @mandatory
                       @assert.range: [1,9999];
  material           : String(40)  @mandatory
                       @assert.format: '^[A-Z0-9_\\-]{3,40}$';
  materialDescription: String(80);
  plant              : String(4)
                       @assert.format: '^[0-9A-Z]{4}$';
  storageLocation    : String(4)
                       @assert.format: '^[0-9A-Z]{4}$';
  quantity           : Decimal(13,3) @mandatory
                       @assert.range: [0.001,_];
  orderUnit          : String(3)
                       @assert.format: '^[A-Z]{2,3}$';
  netPrice           : Decimal(11,2)
                       @assert.range: [0,_];
  priceUnit          : Integer
                       @assert.range: [1,999];
  taxCode            : String(2)
                       @assert.format: '^[A-Z0-9]{1,2}$';
  deliveryDate       : Date;
  accountAssignCat   : String(1)
                       @assert.format: '^[A-Z0-9]$';
  glAccount          : String(10)
                       @assert.format: '^[0-9]{4,10}$';
  costCenter         : String(10)
                       @assert.format: '^[A-Z0-9]{4,10}$';
  wbselement         : String(24)
                       @assert.format: '^[A-Z0-9\\-]{4,24}$';
  grBasedInvoice     : Boolean;
  overDeliveryTol    : Decimal(5,2);
  underDeliveryTol   : Decimal(5,2);
  itemCategory       : String(1)
                       @assert.format: '^[A-Z0-9]$';
  rejectionReason    : String(2);
  itemNote           : String(255);
}
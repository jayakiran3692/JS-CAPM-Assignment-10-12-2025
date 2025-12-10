using { cuid, managed } from '@sap/cds/common';

namespace mm;

// -----------------------------------------------------
// 1) ManufacturedMaterials 1 : n RawMaterials
//    - Loosely coupled (ASSOCIATION)
// -----------------------------------------------------
entity ManufacturedMaterials : cuid, managed {
  materialCode : String(30);
  description  : String(200);

  // 1 : many association (not composition → loose coupling)
  // if manufactured materials are deleted then raw materials and vendor input should delete too
  rawMaterials : Composition of  many RawMaterials
                   on rawMaterials.manufacturedMaterial = $self;
}

// child side
entity RawMaterials : cuid, managed {
  rawCode        : String(30);
  rawDescription : String(200);

  // n : 1 association back to header (loose)
  manufacturedMaterial : Association to ManufacturedMaterials;

  // 1 : 1 tightly coupled to VendorInput (composition)
  vendorInput : Composition of one VendorInputs
                  on vendorInput.rawMaterial = $self;
}

// -----------------------------------------------------
// 2) RawMaterial 1 : 1 VendorInput (tight coupling)
//    - Composition of one
// -----------------------------------------------------
entity VendorInputs : cuid, managed {
  rawMaterial : Association to one RawMaterials;

  vendorName   : String(100);
  vendorRating : Integer;
  vendorPrice  : Decimal(9,2);
}
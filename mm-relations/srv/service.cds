using { mm as db } from '../db/schema';

service MaterialService {

  entity ManufacturedMaterials as projection on db.ManufacturedMaterials;
  entity RawMaterials          as projection on db.RawMaterials;
  entity VendorInputs          as projection on db.VendorInputs;

}
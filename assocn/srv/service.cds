using { demo as db } from '../db/schema';

// Service exposed as /odata/v4/catalog
@path : 'catalog'
service CatalogService {

  entity Authors   as projection on db.Authors;
  entity Books     as projection on db.Books;

  entity Customers as projection on db.Customers;
  entity Orders    as projection on db.Orders;

  entity Addresses as projection on db.Addresses;
}
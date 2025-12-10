using { cuid, managed } from '@sap/cds/common';

namespace demo;

// ------------------------------------------------
// 1) AUTHORS ↔ BOOKS
//    Author 1 : n Books (composition)
//    Book n : 1 Author  (association)
// ------------------------------------------------

entity Authors : cuid, managed {
  name  : String(111);

  // 1 : many (composition)
  books : Composition of many Books
            on books.author = $self;
}

entity Books : cuid, managed {
  title  : String(200);

  // n : 1 (association)
  author : Association to Authors;
}

// ------------------------------------------------
// 2) CUSTOMERS ↔ ORDERS
//    Customer 1 : n Orders (association)
//    Order n : 1 Customer (association)
// ------------------------------------------------

entity Customers : cuid, managed {
  name   : String(100);
  email  : String(100);

  // 1 : many (association)
  orders : Association to many Orders
             on orders.customer = $self;

  // 3) CUSTOMER ↔ ADDRESS (1 : 1 composition)
  address : Composition of one Addresses
              on address.customer = $self;
}

entity Orders : cuid, managed {
  orderNo  : String(30);
  amount   : Decimal(9,2);

  // n : 1 (association)
  customer : Association to Customers;
}

// ------------------------------------------------
// 3) CUSTOMER ↔ ADDRESS (continued)
//    Customer 1 : 1 Address (composition)
//    Address 1 : 1 Customer (association back)
// ------------------------------------------------

entity Addresses : cuid, managed {
  customer : Association to one Customers; // back-reference
  street   : String(100);
  city     : String(50);
  zip      : String(10);
}
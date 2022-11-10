-- ----------------------------------------------------------
-- File          : INFO605_WI21_Group4_Project_Report2.sql
-- Desc          : for INFO605_001 Group4 Project Report2
-- Author        : Yule Zhu, Hannah Wurzel, Makua Okolo, Kunal Chhabria
-- Create Date   : Mar, 2022
-- Modifications :  N/A
-- ----------------------------------------------------------

-- Drop the table if is already existed
DROP TABLE CustomerPayment;
DROP TABLE CustomerAddress;
DROP TABLE Delivery;
DROP TABLE ReturnDetail;
DROP TABLE OrderProduct;
DROP TABLE OrderDetail;
DROP TABLE WarehouseProduct;
DROP TABLE Return;
DROP TABLE Warehouse;
DROP TABLE Product;
DROP TABLE Supplier;
DROP TABLE Customer;

-- Create tables for 6) Database Implementation
CREATE TABLE Customer (
  customerid CHAR(10) CONSTRAINT customer_pk PRIMARY KEY,
  customerfirstname VARCHAR(25) CONSTRAINT customer_nn_fname NOT NULL,
  customerlastname VARCHAR(25) CONSTRAINT customer_nn_lname NOT NULL,
  customerphone CHAR(10)
);

CREATE TABLE CustomerPayment (
  nameoncard VARCHAR(54) CONSTRAINT payment_nn_name NOT NULL,
  cardnumber CHAR(20) CONSTRAINT payment_nn_number NOT NULL,
  expiredate CHAR(5) CONSTRAINT payment_nn_expire NOT NULL,
  customerid CHAR(10) CONSTRAINT payment_fk_cutomer REFERENCES Customer(customerid) ON DELETE CASCADE,
  CONSTRAINT customerpayment_pk PRIMARY KEY(nameoncard, cardnumber, expiredate, customerid)
);

CREATE TABLE CustomerAddress (
  fullName VARCHAR(54) CONSTRAINT address_nn_name NOT NULL,
  street VARCHAR(128) CONSTRAINT address_nn_street NOT NULL,
  city VARCHAR(25) CONSTRAINT address_nn_city NOT NULL,
  state VARCHAR(25) CONSTRAINT address_nn_state NOT NULL,
  zip CHAR(5) CONSTRAINT address_nn_zip NOT NULL,
  customerid CHAR(10) CONSTRAINT address_fk_cutomer REFERENCES Customer(customerid) ON DELETE CASCADE,
  CONSTRAINT customeraddress_pk PRIMARY KEY(fullname, street, city, state, zip, customerid)
);

CREATE TABLE OrderDetail (
  ordernumber CHAR(15) CONSTRAINT order_pk PRIMARY KEY,
  shippingaddress VARCHAR(128) CONSTRAINT order_nn_shippingaddress NOT NULL,
  billingaddress VARCHAR(128) CONSTRAINT order_nn_billingaddress NOT NULL,
  paymentmethod CHAR(15) CONSTRAINT order_nn_paymentmethod NOT NULL,
  orderdate DATE CONSTRAINT order_nn_orderdate NOT NULL,
  customerid CHAR(10) CONSTRAINT order_fk_customerid REFERENCES Customer(customerid) ON DELETE SET NULL
);

CREATE TABLE Supplier (
  supplierid CHAR(10) CONSTRAINT supplier_pk PRIMARY KEY,
  suppliername VARCHAR(25) CONSTRAINT supplier_nn_name NOT NULL,
  supplieraddress VARCHAR(125)
);

CREATE TABLE Product (
  productsku CHAR(8) CONSTRAINT product_pk PRIMARY KEY,
  productname VARCHAR(25) CONSTRAINT product_nn_name NOT NULL,
  productprice NUMBER CONSTRAINT product_nn_price NOT NULL,
  productdescription VARCHAR(125),
  supplierid CHAR(10) CONSTRAINT product_fk_supplier REFERENCES Supplier(supplierid) ON DELETE SET NULL
);

CREATE TABLE Warehouse (
  warehouseid CHAR(12) CONSTRAINT warehouse_pk PRIMARY KEY,
  warehouseaddress VARCHAR(125) CONSTRAINT warehouse_nn_address NOT NULL
);

CREATE TABLE OrderProduct (
  ordernumber CHAR(15) CONSTRAINT orderproduct_fk_number REFERENCES Orderdetail(ordernumber) ON DELETE CASCADE,
  productsku CHAR(8) CONSTRAINT orderproduct_fk_product REFERENCES Product(productsku) ON DELETE CASCADE,
  amount NUMBER CONSTRAINT orderproduct_nn_amount NOT NULL
      CHECK (amount>0),
  CONSTRAINT orderproduct_pk PRIMARY KEY(ordernumber, productsku)
);

CREATE TABLE WarehouseProduct (
  warehouseid CHAR(12) CONSTRAINT warehouseproduct_fk_id REFERENCES Warehouse(warehouseid) ON DELETE CASCADE,
  productsku CHAR(8) CONSTRAINT warehouseproduct_fk_product REFERENCES Product(productsku) ON DELETE CASCADE,
  quantity NUMBER CONSTRAINT warehouseproduct_nn_amount NOT NULL
      CHECK (quantity>0),
  CONSTRAINT warehouseproduct_pk PRIMARY KEY(warehouseid, productsku)
);

CREATE TABLE Delivery (
  trackingnumber CHAR(10) CONSTRAINT delivery_pk PRIMARY KEY,
  trackingstatus VARCHAR(15) CONSTRAINT delivery_nn_status NOT NULL,
  deliverydate DATE,
  orderNumber CHAR(15) CONSTRAINT delivery_nn_ordernumber REFERENCES Orderdetail(ordernumber) ON DELETE SET NULL
);

CREATE TABLE ReturnDetail (
  returnnumber CHAR(9) CONSTRAINT returndetail_pk PRIMARY KEY,
  returnstatus VARCHAR(15) CONSTRAINT returndetail_nn_status NOT NULL,
  returndate DATE,
  orderNumber CHAR(15) CONSTRAINT returndetail_nn_ordernumber REFERENCES Orderdetail(ordernumber) ON DELETE SET NULL
);

CREATE TABLE Return (
  returnnumber CHAR(9) CONSTRAINT return_fk_number REFERENCES Returndetail(returnnumber) ON DELETE CASCADE,
  productsku CHAR(8) CONSTRAINT return_fk_product REFERENCES Product(productsku) ON DELETE CASCADE,
  qty NUMBER CONSTRAINT return_nn_quantity NOT NULL
      CHECK (qty>0),
  reason VARCHAR(48),
  CONSTRAINT return_pk PRIMARY KEY (returnnumber, productsku)
  );

-- Populate data for 7) Data
INSERT INTO Customer (customerid, customerfirstname, customerlastname, customerphone) VALUES ('1234567891', 'Brown', 'Emily', '0123456789');
INSERT INTO Customer (customerid, customerfirstname, customerlastname, customerphone) VALUES ('1234567892', 'Grey', 'Thomas', '9876543210');
INSERT INTO Customer (customerid, customerfirstname, customerlastname, customerphone) VALUES ('1234567893', 'Makua', 'Okolo', '7845637889');
INSERT INTO Customer (customerid, customerfirstname, customerlastname, customerphone) VALUES ('1234567894', 'Yule', 'Zhu', '3472894289');
INSERT INTO Customer (customerid, customerfirstname, customerlastname, customerphone) VALUES ('1234567895', 'Chabria', 'Kunal', '2222276843');

INSERT INTO CustomerPayment (nameoncard, cardnumber, expiredate, customerid) VALUES ('Brown Emily', '1234 5678 9123 4567', '08/26', '1234567891');
INSERT INTO CustomerPayment (nameoncard, cardnumber, expiredate, customerid) VALUES ('Grey Thomas', '9876 5432 1987 6543', '09/27', '1234567892');
INSERT INTO CustomerPayment (nameoncard, cardnumber, expiredate, customerid) VALUES ('Makua Okolo', '1111 2222 3333 4444', '10/26', '1234567893');
INSERT INTO CustomerPayment (nameoncard, cardnumber, expiredate, customerid) VALUES ('Yule Zhu', '0101 0909 0505 0303', '12/28', '1234567894');
INSERT INTO CustomerPayment (nameoncard, cardnumber, expiredate, customerid) VALUES ('Chabria Kunal', '6543 2198 7654 3210', '09/28', '1234567895');

INSERT INTO CustomerAddress (fullname, street, city, state, zip, customerid) VALUES ('Brown Emily', '510 Sapphire Dr', 'Malvern', 'Pennsylvania', '19355', '1234567891');
INSERT INTO CustomerAddress (fullname, street, city, state, zip, customerid) VALUES ('Grey Thomas', '103 Carnegie Center', 'Princeton', 'New Jersey', '08540', '1234567892');
INSERT INTO CustomerAddress (fullname, street, city, state, zip, customerid) VALUES ('Makua Okolo', '415 Chestnut Street', 'Philadelphia', 'Pennsylvania', '19355', '1234567893');
INSERT INTO CustomerAddress (fullname, street, city, state, zip, customerid) VALUES ('Yule Zhu', '618 Ravens Crest Dr', 'Franklin Park', 'New Jersey', '08536', '1234567894');
INSERT INTO CustomerAddress (fullname, street, city, state, zip, customerid) VALUES ('Chabria Kunal', '375 Market Street', 'Wayne', 'Pennsylvania', '19367', '1234567895');

INSERT INTO OrderDetail (ordernumber, shippingaddress, billingaddress, paymentmethod, orderdate, customerid) VALUES ('D89891212343434', '510 Sapphire Dr, Malvern, PA 19355', 'Same As Shipping Address', 'VISA', '24-Feb-2022', '1234567891');
INSERT INTO OrderDetail (ordernumber, shippingaddress, billingaddress, paymentmethod, orderdate, customerid) VALUES ('D98765432109876', '103 Carnegie Center, Princeton, NJ 08540', 'Same As Shipping Address', 'AMEX', '27-Feb-2022', '1234567892');
INSERT INTO OrderDetail (ordernumber, shippingaddress, billingaddress, paymentmethod, orderdate, customerid) VALUES ('D10293847561029', '415 Chestnut Street, Philly, PA 19355', 'Same As Shipping Address', 'VISA', '03-Mar-2022', '1234567893');
INSERT INTO OrderDetail (ordernumber, shippingaddress, billingaddress, paymentmethod, orderdate, customerid) VALUES ('D56565656565656', '618 Ravens Crest Dr, Franklin Park, NJ 08536', '518 Spring Dr, Malvern, PA 19355', 'AMEX', '02-Feb-2022', '1234567894');
INSERT INTO OrderDetail (ordernumber, shippingaddress, billingaddress, paymentmethod, orderdate, customerid) VALUES ('D12345678901234', '375 Market Street, Wayne, PA 19367', 'Same As Shipping Address', 'VISA', '03-Jan-2022', '1234567895');
INSERT INTO OrderDetail (ordernumber, shippingaddress, billingaddress, paymentmethod, orderdate, customerid) VALUES ('D12345678901238', '375 Market Street, Wayne, PA 19367', 'Same As Shipping Address', 'VISA', '07-Jan-2022', '1234567895');
INSERT INTO OrderDetail (ordernumber, shippingaddress, billingaddress, paymentmethod, orderdate, customerid) VALUES ('D12345678901237', '415 Chestnut Street, Philly, PA 19355', 'Same As Shipping Address', 'VISA', '01-Mar-2022', '1234567893');

INSERT INTO Supplier (supplierid, suppliername, supplieraddress) VALUES ('1000000001', 'Amazon', 'Philadelphia, PA');
INSERT INTO Supplier (supplierid, suppliername, supplieraddress) VALUES ('1000000002', 'Apple', 'Philadelphia, PA');
INSERT INTO Supplier (supplierid, suppliername, supplieraddress) VALUES ('1000000003', 'CoolKids', 'Washington, DC');
INSERT INTO Supplier (supplierid, suppliername, supplieraddress) VALUES ('1000000004', 'PaperLeaf', 'Manhattan, NY');
INSERT INTO Supplier (supplierid, suppliername, supplieraddress) VALUES ('1000000005', 'Thermo', 'Philadelphia, PA');
INSERT INTO Supplier (supplierid, suppliername, supplieraddress) VALUES ('1000000006', 'Dell', 'Columbia, MD');

INSERT INTO Product (productsku, productname, productprice, productdescription, supplierid) VALUES ('PR000001', 'Pencil', 5, 'Stationary', '1000000003');
INSERT INTO Product (productsku, productname, productprice, productdescription, supplierid) VALUES ('PR000002', 'Laptop', 350, 'Gadget', '1000000002');
INSERT INTO Product (productsku, productname, productprice, productdescription, supplierid) VALUES ('PR000004', 'Sunscreen', 30, 'Skin care', '1000000001');
INSERT INTO Product (productsku, productname, productprice, productdescription, supplierid) VALUES ('PR000005', 'Notebook', 3, 'Stationary', '1000000004');
INSERT INTO Product (productsku, productname, productprice, productdescription, supplierid) VALUES ('PR000006', 'Water bottle', 20,  'Accessory', '1000000005');
INSERT INTO Product (productsku, productname, productprice, productdescription, supplierid) VALUES ('PR000007', 'Monitor', 240,  'Computer', '1000000006');

INSERT INTO Warehouse (warehouseid, warehouseaddress) VALUES ('A99', 'North Carolina');
INSERT INTO Warehouse (warehouseid, warehouseaddress) VALUES ('B88', 'Florida');
INSERT INTO Warehouse (warehouseid, warehouseaddress) VALUES ('C77', 'Pittsburg');
INSERT INTO Warehouse (warehouseid, warehouseaddress) VALUES ('D66', 'Puerto Rico');
INSERT INTO Warehouse (warehouseid, warehouseaddress) VALUES ('E55', 'Philadelphia');

INSERT INTO OrderProduct (ordernumber, productsku, amount) VALUES ('D89891212343434', 'PR000004', 1);
INSERT INTO OrderProduct (ordernumber, productsku, amount) VALUES ('D98765432109876', 'PR000001', 2);
INSERT INTO OrderProduct (ordernumber, productsku, amount) VALUES ('D10293847561029', 'PR000004', 1);
INSERT INTO OrderProduct (ordernumber, productsku, amount) VALUES ('D56565656565656', 'PR000002', 3);
INSERT INTO OrderProduct (ordernumber, productsku, amount) VALUES ('D12345678901234', 'PR000005', 1);
INSERT INTO OrderProduct (ordernumber, productsku, amount) VALUES ('D12345678901237', 'PR000006', 2);
INSERT INTO OrderProduct (ordernumber, productsku, amount) VALUES ('D12345678901238', 'PR000001', 4);

INSERT INTO WarehouseProduct (warehouseid, productsku, quantity) VALUES ('A99', 'PR000001', 100);
INSERT INTO WarehouseProduct (warehouseid, productsku, quantity) VALUES ('B88', 'PR000002', 200);
INSERT INTO WarehouseProduct (warehouseid, productsku, quantity) VALUES ('C77', 'PR000004', 80);
INSERT INTO WarehouseProduct (warehouseid, productsku, quantity) VALUES ('D66', 'PR000005', 400);
INSERT INTO WarehouseProduct (warehouseid, productsku, quantity) VALUES ('E55', 'PR000006', 140);

INSERT INTO Delivery (trackingnumber, trackingstatus, ordernumber, deliverydate) VALUES ('0003456789', 'Delivered', 'D56565656565656', '06-Feb-2022');
INSERT INTO Delivery (trackingnumber, trackingstatus, ordernumber, deliverydate) VALUES ('0001234567', 'Processing', 'D98765432109876', NULL);
INSERT INTO Delivery (trackingnumber, trackingstatus, ordernumber, deliverydate) VALUES ('0009876542', 'Delivered', 'D89891212343434', '01-Mar-2022');
INSERT INTO Delivery (trackingnumber, trackingstatus, ordernumber, deliverydate) VALUES ('0004321987', 'Delivered', 'D12345678901234', '06-Jan-2022');
INSERT INTO Delivery (trackingnumber, trackingstatus, ordernumber, deliverydate) VALUES ('0007654891', 'En Route', 'D10293847561029', NULL);
INSERT INTO Delivery (trackingnumber, trackingstatus, ordernumber, deliverydate) VALUES ('0004321988', 'Delivered', 'D12345678901238', '06-Jan-2022');
INSERT INTO Delivery (trackingnumber, trackingstatus, ordernumber, deliverydate) VALUES ('0004321976', 'Delivered', 'D12345678901237', '09-Mar-2022');

INSERT INTO ReturnDetail (returnnumber, returnstatus, returndate, ordernumber) VALUES ('912345678', 'Returned', '05-Mar-2022', 'D56565656565656');
INSERT INTO ReturnDetail (returnnumber, returnstatus, returndate, ordernumber) VALUES ('956781245', 'Returned', '22-Feb-2022', 'D12345678901238');
INSERT INTO ReturnDetail (returnnumber, returnstatus, returndate, ordernumber) VALUES ('956781256', 'Returned', '15-Mar-2022', 'D12345678901237');
INSERT INTO ReturnDetail (returnnumber, returnstatus, returndate, ordernumber) VALUES ('934567812', 'En Route', NULL, 'D89891212343434');
INSERT INTO ReturnDetail (returnnumber, returnstatus, returndate, ordernumber) VALUES ('945678123', 'En Route', NULL, 'D12345678901234');

INSERT INTO Return (returnnumber, productsku, qty, reason) VALUES ('912345678', 'PR000002', 1, NULL);
INSERT INTO Return (returnnumber, productsku, qty, reason) VALUES ('956781245', 'PR000001', 4, NULL);
INSERT INTO Return (returnnumber, productsku, qty, reason) VALUES ('956781256', 'PR000006', 2, 'NotNeeded');
INSERT INTO Return (returnnumber, productsku, qty, reason) VALUES ('934567812', 'PR000004', 1, NULL);
INSERT INTO Return (returnnumber, productsku, qty, reason) VALUES ('945678123', 'PR000005', 1, 'Damaged');

COMMIT;

-- Display setting
SET pagesize 100;
SET linesize 160;
SET FEEDBACK ON;

COL customerfirstname FORMAT A20;
COL customerlastname FORMAT A20;
COL customerphone FORMAT A13;
COL nameoncard FORMAT A20;
COL expiredate FORMAT A10;
COL fullname FORMAT A20;
COL street FORMAT A25;
COL city FORMAT A15;
COL state FORMAT A15;
COL shippingaddress FORMAT A45;
COL billingaddress FORMAT A35;
COL suppliername FORMAT A15;
COL supplieraddress FORMAT A20;
COL productsku FORMAT A10;
COL productname FORMAT A15;
COL productdescription FORMAT A20;
COL trackingnumber FORMAT A14;
COL deliverydate FORMAT A12;
COL returnnumber FORMAT A12;
COL returndate FORMAT A10;
COL warehouseaddress FORMAT A20;
COL reason FORMAT A20;

COMMIT;

 -- Change the date format to dd-mm-yyyy
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-RRRR';

-- View the tables with display setting above
SELECT * FROM Customer;
SELECT * FROM CustomerPayment;
SELECT * FROM CustomerAddress;
SELECT * FROM OrderDetail;
SELECT * FROM Supplier;
SELECT * FROM Product;
SELECT * FROM Warehouse;
SELECT * FROM OrderProduct;
SELECT * FROM WarehouseProduct;
SELECT * FROM Delivery;
SELECT * FROM ReturnDetail;
SELECT * FROM Return;

-- Queries for 8) Data Queries

-- HANNAH QUERY 1: return all the rows of the Delivery table where the tracking status is “Processing”.
SELECT *
FROM Delivery
WHERE trackingstatus = 'Processing';
-- HANNAH QUERY 2: return product name for all products that cost more than $15.
SELECT productname
FROM Product
WHERE productcost > 15;
-- HANNAH QUERY 3: return the product name for all products that are supplied by Amazon.
SELECT p.productname
FROM Product p
  JOIN Supplier s ON p.supplierid = s.supplierid
WHERE s.suppliername = Amazon;


-- Yule Zhu Query 1 -- show order number placed after 01-Feb-2022
SELECT ordernumber, orderdate
FROM  Orderdetail
WHERE orderdate > '01-Feb-2022';

-- Yule Zhu Query 2 -- show the number of customers registered in the Drex
SELECT COUNT (*) AS NumberOfCustomers
FROM Customer;

-- Yule Zhu Query 3 -- for each customer, show the customer’s id and the number of all that customer’s order that has been delivered
SELECT e.customerid, COUNT (d.ordernumber) AS CountOrder
FROM Customer e
            JOIN Orderdetail d ON e.customerid = d.customerid
            JOIN Delivery g ON g.ordernumber = d.ordernumber
            WHERE g.trackingstatus = 'Delivered'
GROUP BY e.customerid;



-- QUERIES FOR 9) DATA MANIPULATION

-- HANNAH DATA MANIPULATION 1: delete any products that cost below $10.
DELETE FROM Product
WHERE productprice < 10;
-- HANNAH DATA MANIPULATION 2: update the phone number to 4848838658 for the customer with the id 1234567895.
UPDATE Customer
SET customerphone = 4848838658
WHERE customerid = '1234567895'; 


--Display the before update values of 9) Data Manipulation
-- Yule Zhu --
SELECT *
FROM Supplier
WHERE suppliername = 'PaperLeaf';

SELECT * FROM Supplier;

--  --
-- --
-- --

-- Update values for 9) Data Manipulation
-- Yule Zhu Update 1 -- change the address of supplier 'PaperLeaf' to 'Princeton, NJ'.
UPDATE Supplier
SET supplieraddress = 'Princeton, NJ'
WHERE suppliername = 'PaperLeaf';

-- Yule Zhu Delete 1 -- Delete the record for supplier 1000000006
DELETE FROM Supplier
WHERE supplierid = '1000000006';

COMMIT;

-- Display the after update values of 9) Data Manipulation
-- Yule Zhu --
SELECT *
FROM Supplier
WHERE suppliername = 'PaperLeaf';

SELECT * FROM Supplier;




--The End! Thank you!

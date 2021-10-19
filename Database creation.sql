/* Lab 4 Database Implementation */

-- Using master database

use master;

-- Dropping database WonderfulWheels if already exists and then Creating Database WonderfulWheels 

if db_id('WonderfulWheels') IS NOT NULL
	drop database WonderfulWheels;
GO
	create database WonderfulWheels;
GO

-- Use database WonderfulWheels

use WonderfulWheels;

--- Creation of tables for database WonderfulWheels

/* Creating Location table */

create table [Location]
(
LocationID int IDENTITY(1,1) not null,
StreetAddress nvarchar(100) not null,
City nvarchar(100) not null, 
Province char(2) not null,
PostalCode char(7) not null,
Primary key (LocationID)
);


/* Creating dealership table */

create table Dealership
(
DealershipID int IDENTITY(1,1) not null,
LocationID int not null,
[Name] varchar(100) not null,
Phone varchar(20) not null,
Primary key (DealershipID),
CONSTRAINT FK_LocationID FOREIGN KEY (LocationID)
REFERENCES [Location] (LocationID)
);


/* Creating person table

Person title is restricted to: Mr and Ms
Optional fields of person table : Telephone, Email, DateOfBirth and Title
Person id startes at 1000 and it is autoincremented by 1

*/

create table Person
(
PersonID int IDENTITY(1000,1) not null,
FirstName varchar(50) not null,
LastName varchar(50) not null,
Telephone varchar(20) null,
Email nvarchar(320) null,
PerLocID int not null,
DataofBirth date null,
Title char(2) check (Title in ('Mr','Ms')) null,
Primary key (PersonID),
CONSTRAINT FK_PerLocID FOREIGN KEY(PerLocID)
REFERENCES [Location] (LocationID)
);



--Adding nonclustered index on column FirstName and LastName for table person

create nonclustered index idx_person_name on Person (FirstName,LastName);

/* Creating customer table */

create table Customer
(
CustomerID int not null,
RegistrationDate date not null,
Primary key (CustomerID),
CONSTRAINT FK_CustomerID FOREIGN KEY (CustomerID)
REFERENCES Person (PersonID)
);

/* Creating Employee table */


create table Employee
(
EmployeeID int not null,
EmpDealID int not null,
HireDate date not null, 
EmpRole varchar(50) not null,
ManagerID int,
Primary key (EmployeeID),
CONSTRAINT FK_EmployeeID FOREIGN KEY (EmployeeID)
REFERENCES Person (PersonID),
CONSTRAINT FK_EmpDealID FOREIGN KEY (EmpDealID)
REFERENCES Dealership (DealershipID),
CONSTRAINT FK_ManagerID FOREIGN KEY (ManagerID)
REFERENCES Employee (EmployeeID)
);


/* Creating Salary Employee table 
Employee salary can not be less than 1000 , therefore default value of salary is 1000.00
*/

create table SalaryEmployee
(
EmployeeID int not null,
salary money not null default 1000.00 check (salary>=1000),
Primary key (EmployeeID),
CONSTRAINT FK_SEmployeeID FOREIGN KEY (EmployeeID)
REFERENCES Employee (EmployeeID)
);

/* Creating Commission Employee table
Employee commission can not be less than 10, therefore default value of commission is 10.00
*/

create table CommissionEmployee
(
EmployeeID int not null,
Commission money not null default 10.00 check (Commission>=10),
Primary key (EmployeeID),
CONSTRAINT FK_CEmployeeID FOREIGN KEY (EmployeeID)
REFERENCES Employee (EmployeeID)
);

-- Creating Order details table


create table [Order]
(
OrderID int IDENTITY(1,1) not null,
OrderCustID int not null,
OrdEmpID int not null,
OrderDate date not null,
OrDealID int not null,
Primary key (OrderID),
CONSTRAINT FK_OrderCustID FOREIGN KEY (OrderCustID)
REFERENCES Customer (CustomerID),
CONSTRAINT FK_OrdEmpID FOREIGN KEY (OrdEmpID)
REFERENCES Employee (EmployeeID),
CONSTRAINT FK_OrDealID FOREIGN KEY (OrDealID)
REFERENCES Dealership (DealershipID)
);


/* Creating Vehicle table
Prices cannot be less than 1, therefore default value of price is 1.00
*/

create table Vehicle
(
VehicleID int IDENTITY(1,1) not null,
Make varchar(50) not null,
Model varchar(50) not null,
[year] int not null,
Colour varchar(20) not null,
Km int not null,
Price money default 1.00 not null check (Price>=1)
Primary key (VehicleID)
);


/* Creating Order item table
Prices cannot be less than 1, therefore default value of FinalSalePrice is 1.00
*/

create table Order_item
(
OrderID int not null,
VehicleID int not null ,
FinalSalePrice money default 1.00 not null check (FinalSalePrice>=1),
Primary key (OrderID,VehicleID),
CONSTRAINT FK_OrderID FOREIGN KEY(OrderID)
REFERENCES [Order](OrderID),
CONSTRAINT FK_VehicleID FOREIGN KEY(VehicleID)
REFERENCES Vehicle(VehicleID)
);


/* Creating Account table 
Money related field AccountBalance,LastPaymentAmount : can not allow nulls and have default value 0.00. 
They should not be less than 0.
*/

create table Account
(
AccountID int IDENTITY(1,1) not null,
CustomerID int not null,
AccountBalance money default 0.00 not null check (AccountBalance>=0),
LastPaymentAmount money default 0.00 not null check (LastPaymentAmount>=0),
LastPaymentDate date null,
Primary key (AccountID),
CONSTRAINT FK_AccountCustomerID FOREIGN KEY (CustomerID)
REFERENCES Customer (CustomerID)
);
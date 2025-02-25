Create DataBase Adventure_Works;
USE Adventure_Works;

-- Table Creation and importing.

START TRANSACTION ;
SET AUTOCOMMIT = 0;

Create table Factinternetsales
(
ProductKey int,
OrderDateKey int,
DueDateKey int,
ShipDateKey int,
CustomerKey int,
PromotionKey int,
CurrencyKey int,
SalesTerritoryKey int,
SalesOrderNumber Varchar(100),
SalesOrderLineNumber Varchar(100),
RevisionNumber int,
OrderQuantity int,
UnitPrice float,
ExtendedAmount float,
UnitPriceDiscountPct float,
DiscountAmount float,
ProductStandardCost	float,
TotalProductCost float,
SalesAmount float,
TaxAmt float,
Freight float,
carrierTrackingNumber  Varchar(100),
CustomerPONumber  Varchar(100),
OrderDate date ,
DueDate date,
ShipDate date
);

SAVEPOINT FACTSALES;

DROP table Factinternetsales;
Describe Factinternetsales;
SELECT * FROM Factinternetsales;

SAVEPOINT FACTSALES1;

Create table DimCustomer
(
CustomerKey INT,
GeographyKey INT,
CustomerAlternateKey varchar(100),
FirstName varchar(100),
LastName varchar(100),
BirthDate date,
MaritalStatus varchar(1),
Gender varchar(1),
EmailAddress varchar(200),
YearlyIncome INT,
TotalChildren	INT,
NumberChildrenAtHome	INT,
EnglishEducation varchar(50),
EnglishOccupation	varchar(50),
HouseOwnerFlag	BOOLEAN,
NumberCarsOwned	INT,
AddressLine1 varchar(50),
AddressLine2 varchar(50),
Phone	varchar(100),
DateFirstPurchase	DATE
);

SAVEPOINT DimCustomer;

DROP table DimCustomer;
Describe DimCustomer;
SELECT * FROM DimCustomer;

SAVEPOINT DimCustomer1;

Create table DimDate
(
DateKey	int,
FullDate_Key date,
Day_Number	smallint,
Day_Name varchar(10),
Date_Number smallint,
Year_Dayno smallint,
Week_Number	smallint,
Month_Name varchar(10),
Month_Number smallint,
CalendarQuarter	smallint,
CalendarYear	smallint,
CalendarSemester smallint,	
FiscalQuarter	smallint,
FiscalYear	smallint,
FiscalSemester smallint
);

savepoint DimDate;

DROP table DimDate;
Describe DimDate;
SELECT * FROM DimDate;

savepoint DimDate1;

-- DimProduct table
Create Table DimProduct
(
ProductKey int,
Unit_price VARCHAR(20) DEFAULT NULL,
ProductAlternateKey	varchar(50),
SubcategoryKey varchar(200),
WeightUnit varchar(5),
SizeUnit varchar(5),
EnglishProductName	varchar(100),
SpanishProductName	varchar(100),
FrenchProductName	varchar(100),
StandardCost varchar(100),
FinishedGoodsFlag varchar(100),
Color varchar(100),
SafetyStockLevel int,
ReorderPoint	int,
ListPrice	varchar(100),
Size varchar(10),
SizeRange	varchar(10),
Weight	varchar(10),
Manufacturing_Days int,
ProductLine	varchar(5),
DealerPrice	varchar(100),
Class	varchar(10),
Style	varchar(10),
ModelName	varchar(100),
EnglishDescription	varchar(500),
FrenchDescription	varchar(500),
ChineseDescription varchar(500),
ArabicDescription varchar(500),
HebrewDescription	varchar(500),
ThaiDescription	varchar(500),
GermanDescription	varchar(500),
JapaneseDescription	varchar(500),
TurkishDescription	varchar(500),
StartDate	date,
EndDate VARCHAR(20) DEFAULT NULL ,
Status_ varchar(20)
);

SAVEPOINT Dimproduct;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/DimProducts.csv'
INTO TABLE DimProduct
Fields terminated by ','
ENCLOSED BY '"'
ignore 1 rows;

SAVEPOINT Dimproduct1;

DROP table Dimproduct;
Describe Dimproduct;
SELECT * FROM Dimproduct;

SAVEPOINT Dimproduct2;

-- DimProductcategory
Create Table DimProductcategory
(
ProductCategoryKey	smallint,
AlternateKey	smallint,
English_ProductCategoryName	varchar(50),
Spanish_ProductCategoryName	varchar(50),
French_ProductCategoryName varchar(50)
);

SAVEPOINT DimProductCategory;

DROP table DimproductCategory;
Describe DimproductCategory;
SELECT * FROM DimproductCategory;

SAVEPOINT DimProductCategory1;

-- DimProductSubCategory

Create table DimProductSubCategory
(
ProductSubcategoryKey smallint,
AlternateKey	smallint,
English_ProductSubcategoryName varchar(50),
Spanish_ProductSubcategoryName	varchar(50),
French_ProductSubcategoryName	varchar(50),
ProductCategoryKey smallint
);

SAVEPOINT DimProductSubCategory;

DROP table DimproductSubCategory;
Describe  DimproductSubCategory;
SELECT * FROM  DimproductSubCategory;

SAVEPOINT DimProductSubCategory1;

-- DimSalesterritory

Create table DimSalesterritory
(
SalesTerritoryKey smallint,
AlternateKey	smallint,
SalesTerritoryRegion varchar(50),
SalesTerritoryCountry varchar(50),	
SalesTerritoryGroup varchar(50)
);

SAVEPOINT DimSalesterritory;

DROP table DimSalesterritory;
Describe  DimSalesterritory;
SELECT * FROM  DimSalesterritory;

-- FactInternetsalesNew

Create table FactinternetsalesNew
(
ProductKey int,
OrderDateKey int,
DueDateKey int,
ShipDateKey int,
CustomerKey int,
PromotionKey int,
CurrencyKey int,
SalesTerritoryKey int,
SalesOrderNumber Varchar(100),
SalesOrderLineNumber Varchar(100),
RevisionNumber int,
OrderQuantity int,
UnitPrice float,
ExtendedAmount float,
UnitPriceDiscountPct float,
DiscountAmount float,
ProductStandardCost	float,
TotalProductCost float,
SalesAmount float,
TaxAmt float,
Freight float,
carrierTrackingNumber  Varchar(100),
CustomerPONumber  Varchar(100),
OrderDate Date ,
DueDate Date,
ShipDate Date 
);

SAVEPOINT FactinternetsalesNew;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/FactInternetSalesNew.csv'
INTO TABLE FactinternetsalesNew
fields terminated by ','
ENCLOSED BY '"'
ignore 1 rows;

DROP table FactinternetsalesNew;
Describe  FactinternetsalesNew;
SELECT * FROM  FactinternetsalesNew;

select count(*) from FactinternetsalesNew;

SAVEPOINT FactinternetsalesNew1;



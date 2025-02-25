USE adventure_works;

-- Data Cleaning - factinternetsalesnew.
START transaction  ;
SET AUTOCOMMIT = 0;

-- alocating row_number to find duplicate
SELECT *, 
ROW_NUMBER () OVER(partition by ProductKey,OrderDateKey,DueDateKey,
ShipDateKey,CustomerKey,PromotionKey,
SalesTerritoryKey,SalesOrderNumber,
SalesOrderLineNumber,OrderDate,DueDate,ShipDate) AS Row_no
FROM factsales;

-- Checking for duplicate (factinternetsalesnew)
With Duplicate_records AS 
(
SELECT *, 
ROW_NUMBER () OVER(partition by ProductKey,OrderDateKey,DueDateKey,
ShipDateKey,CustomerKey,PromotionKey,
SalesTerritoryKey,SalesOrderNumber,
SalesOrderLineNumber,OrderDate,DueDate,ShipDate) AS Row_no
FROM factsales
) 
SELECT * FROM Duplicate_records
WHERE Row_no > 1;

-- checking Empty column (factinternetsalesnew)
SELECT UnitPriceDiscountPct, DiscountAmount
from factsales
where UnitPriceDiscountPct >0 OR DiscountAmount >0;

Select carrierTrackingNumber,CustomerPONumber
FROM factsales
WHERE  carrierTrackingNumber IS NOT NULL AND CustomerPONumber IS NOT NULL;

-- Deleting Columns (factinternetsalesnew)
ALTER TABLE factinternetsalesnew
Drop COLUMN UnitPriceDiscountPct,
Drop COLUMN DiscountAmount,
Drop COLUMN carrierTrackingNumber,
Drop COLUMN CustomerPONumber;

-- Data Cleaning - factinternetsales
DESCRIBE factinternetsales;

-- Checking Duplicates
With Duplicate_records AS 
(
SELECT *, 
ROW_NUMBER () OVER(partition by ProductKey,OrderDateKey,DueDateKey,
ShipDateKey,CustomerKey,PromotionKey,
SalesTerritoryKey,SalesOrderNumber,
SalesOrderLineNumber,OrderDate,DueDate,ShipDate) AS Row_no
FROM factinternetsales
) 
SELECT * FROM Duplicate_records
WHERE Row_no > 1;
-- no duplicate records.

-- checking Empty column (factinternetsalesnew)
SELECT UnitPriceDiscountPct, DiscountAmount
from factinternetsales
where UnitPriceDiscountPct >0 OR DiscountAmount >0;

Select carrierTrackingNumber,CustomerPONumber
FROM factinternetsales
WHERE  carrierTrackingNumber IS NOT NULL AND CustomerPONumber IS NOT NULL;

-- Deleting Columns (factinternetsalesnew)
ALTER TABLE factinternetsales
Drop COLUMN UnitPriceDiscountPct,
Drop COLUMN DiscountAmount,
Drop COLUMN carrierTrackingNumber,
Drop COLUMN CustomerPONumber;

-- Data cleaning - dimsalesterritory
-- checking for data consistency
SELECT  DISTINCT SalesTerritoryGroup
FROM dimsalesterritory;

SELECT  DISTINCT SalesTerritoryCountry
FROM dimsalesterritory;

SELECT SalesTerritoryRegion
FROM dimsalesterritory;
-- Data is Consistent.

-- Data Cleaning - dimproductsubcategory
describe dimproductsubcategory;
-- checking for data consistency, Duplicates
SELECT English_ProductSubcategoryName, COUNT(*)
FROM dimproductsubcategory
GROUP BY English_ProductSubcategoryName
HAVING COUNT(*) > 1;

-- Data Cleaning - dimproductcategory
describe dimproductcategory;
-- checking for data consistency, Duplicates
SELECT English_ProductCategoryName, COUNT(*)
FROM dimproductcategory
GROUP BY English_ProductCategoryName
HAVING COUNT(*) > 1;

-- Data Cleaning - dimproduct
describe dimproduct;
-- checking for data consistency, Duplicates
SELECT EnglishProductName,SubcategoryKey,ProductKey, COUNT(*)
FROM dimproduct
GROUP BY EnglishProductName,SubcategoryKey,ProductKey
HAVING COUNT(*) > 1;

-- checking for empty column
Select SubcategoryKey,EndDate
FROM dimproduct
WHERE SubcategoryKey IS NOT NULL and EndDate IS NOT NULL;

-- Data Cleaning - dimdate
describe dimdate;
-- checking for data consistency, Duplicates
SELECT  DateKey,FullDate_Key, COUNT(*)
FROM dimdate
GROUP BY DateKey,FullDate_Key
HAVING COUNT(*) > 1;

-- Data Cleaning - dimcustomer
describe dimcustomer;
-- checking for data consistency, Duplicates
SELECT CustomerKey,GeographyKey,CustomerAlternateKey, COUNT(*)
FROM dimcustomer
GROUP BY CustomerKey,GeographyKey,CustomerAlternateKey
HAVING COUNT(*) > 1;

commit;

SELECT SubcategoryKey FROM DimProduct WHERE SubcategoryKey = '';

UPDATE DimProduct 
SET SubcategoryKey = NULL 
WHERE SubcategoryKey = '';

DESC factsales;
SELECT * FROM FACTSALES;

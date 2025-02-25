USE Adventure_Works;

SET AUTOCOMMIT = 0;
START TRANSACTION;


-- Creating Fact Sale by apphending factinternetsale and factinternetsalesnew
CREATE TABLE FactSales AS
SELECT * FROM factinternetsales
UNION
SELECT * FROM factinternetsalesnew;

SELECT * FROM factsales;

SAVEPOINT FACTSALES;

DROP TABLE factinternetsalesnew;
DROP TABLE factinternetsales;

SAVEPOINT factintersales;


-- adding Primary key
ALTER TABLE dimproductcategory
ADD CONSTRAINT PK_productcategory PRIMARY KEY (ProductCategoryKey);

ALTER TABLE dimproductsubcategory
ADD CONSTRAINT PK_productsubcategory PRIMARY KEY (ProductSubcategoryKey);

ALTER TABLE dimproduct
ADD CONSTRAINT PK_product PRIMARY KEY (ProductKey);

-- ADDING foreign key
ALTER TABLE DimProductSubCategory 
ADD CONSTRAINT FK_ProductCategory 
FOREIGN KEY (ProductCategoryKey) 
REFERENCES DimProductCategory(ProductCategoryKey);

DESC dimproductsubcategory;
ALTER TABLE dimproductsubcategory MODIFY COLUMN ProductSubcategoryKey INT NOT NULL;
ALTER TABLE DimProduct MODIFY COLUMN SubcategoryKey int null;

ALTER TABLE DimProduct 
ADD CONSTRAINT FK_ProductSubcategory 
FOREIGN KEY (SubcategoryKey) 
REFERENCES DimProductSubCategory(ProductSubcategoryKey)
ON DELETE CASCADE ON UPDATE CASCADE;


savepoint Dimproduct_beforeSchema;

-- creating schema
-- Creating Primary Key.
ALTER TABLE factsales
ADD PRIMARY KEY (SalesOrderNumber,SalesOrderLineNumber);

savepoint before_dimcustomer;

ALTER TABLE dimcustomer
ADD PRIMARY KEY (CustomerKey);

savepoint before_dimdate;

ALTER TABLE dimdate
ADD PRIMARY KEY (DateKey);
ALTER TABLE DimDate 
ADD UNIQUE (DateKey);


savepoint before_dimsalesterritory;

ALTER TABLE dimsalesterritory
ADD PRIMARY KEY (SalesTerritoryKey);

ALTER TABLE factsales
ADD PRIMARY KEY (OrderDateKey);
savepoint before_foreign_key;

-- Creating Relationship foreign key
ALTER TABLE factsales
ADD CONSTRAINT FK_SalesTerritoryKey FOREIGN KEY (SalesTerritoryKey)
REFERENCES dimsalesterritory(SalesTerritoryKey)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE dimsalesterritory MODIFY COLUMN SalesTerritoryKey INT NOT NULL;

savepoint before_dimcustomer1;

ALTER TABLE factsales
ADD CONSTRAINT FK_CustomerKey FOREIGN KEY (CustomerKey)
REFERENCES dimcustomer(CustomerKey)
ON DELETE CASCADE ON UPDATE CASCADE;

savepoint before_dimdate1;

ALTER TABLE factsales
ADD CONSTRAINT FK_OrderDateKey FOREIGN KEY (OrderDateKey)
REFERENCES dimdate(DateKey)
ON DELETE CASCADE ON UPDATE CASCADE;

savepoint before_dimproduct;

ALTER TABLE factsales
ADD CONSTRAINT FK_ProductKey FOREIGN KEY (ProductKey)
REFERENCES dimproduct(ProductKey)
ON DELETE CASCADE ON UPDATE CASCADE;

commit;

savepoint final;
set autocommit=1;
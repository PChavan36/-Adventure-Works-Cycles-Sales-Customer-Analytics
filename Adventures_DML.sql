
SET AUTOCOMMIT = 0;

SELECT @@autocommit;

START transaction;
-- Modifying orderdatekey in factsales and datekey in dimdate to Date.
start transaction;

SAVEPOINT Before_DML;


show create table factsales;

ALTER TABLE FACTSALES DROP FOREIGN KEY FK_OrderDateKey;
ALTER TABLE dimdate MODIFY COLUMN DateKey date;
ALTER TABLE factsales MODIFY COLUMN OrderDateKey date;

commit;

DESC factsales;
SELECT * FROM FACTSALES;
SELECT * FROM DIMDATE;
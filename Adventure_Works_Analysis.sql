USE adventure_works;


-- Analysis - Business
# 1. KPI Cards- Sales, COGS, Profit, Gross Profit %.

SELECT 
concat("$ ",round((sum(TotalProductCost)/1000000),2)," M") as COGS,
concat("$ ",Round((sum(SalesAmount)/1000000),2)," M") as Total_Revenue, 
concat("$ ",Round((sum(SalesAmount-TotalProductCost)/1000000),2)," M") as Profit,
concat(Round((sum(SalesAmount-TotalProductCost)/sum(SalesAmount))*100,2)," %") 
as `Gross Profit Margin %`
FROM factsales; 


# 2. KPI Card - Total transactions, Total Customer, Total OrderQuantity, Total Products,	
# 	 Total Sold, Total UnSold, Profit Margin %

SELECT concat(ROUND((COUNT(f.SalesOrderNumber)/1000),2)," K") Total_Transactions, 
concat(ROUND((COUNT(DISTINCT f.CustomerKey)/1000),2)," K") Total_Customers,
concat(ROUND((COUNT(f.OrderQuantity)/1000),2)," K") Total_Quantity, 
COUNT(DISTINCT p.ProductKey) Total_Products, 
COUNT(DISTINCT f.ProductKey) Total_Products_Sold, 
(COUNT(DISTINCT p.ProductKey) - COUNT(DISTINCT f.ProductKey)) Total_Products_Unsold,
concat(Round((sum(SalesAmount-TotalProductCost)/sum(SalesAmount))*100,2)," %") 
as `Gross Profit Margin %`
FROM FACTSALES f
RIGHT JOIN dimproduct p on p.ProductKey = f.ProductKey;


# 3. Product Category wise Sales, COGS, Profit, Profit %

SELECT 
p.English_ProductCategoryName as Product_Category,
concat("$ ",round((sum(TotalProductCost)/1000000),2)," M") as COGS,
concat("$ ",Round((sum(SalesAmount)/1000000),2)," M") as Total_Revenue, 
concat("$ ",Round((sum(SalesAmount-TotalProductCost)/1000000),2)," M") as Profit,
concat(Round((sum(SalesAmount-TotalProductCost)/sum(SalesAmount))*100,2)," %") 
as `Gross Profit Margin %`
FROM factsales f
JOIN dimproduct dp ON dp.ProductKey = f.ProductKey
JOIN dimproductsubcategory dc ON dc.ProductSubcategoryKey = dp.SubcategoryKey
JOIN dimproductcategory p ON p.ProductCategoryKey = dc.ProductCategoryKey
Group by p.English_ProductCategoryName
Order by `Gross Profit Margin %` desc ;

# 4. Product Category and Sub - Category wise Sales, COGS, Profit, Profit %
SELECT 
p.English_ProductCategoryName as Product_Category,
dc.English_ProductSubcategoryName as Product_SubCategory,
concat("$ ",round((sum(TotalProductCost)/1000),0)," K") as COGS,
concat("$ ",Round((sum(SalesAmount)/1000),0)," K") as Total_Revenue, 
concat("$ ",Round((sum(SalesAmount-TotalProductCost)/1000),0)," K") as Profit,
concat(Round((sum(f.SalesAmount-f.TotalProductCost)/sum(f.SalesAmount))*100,2)," %") 
as `Gross Profit  %`
FROM factsales f
JOIN dimproduct dp ON dp.ProductKey = f.ProductKey
JOIN dimproductsubcategory dc ON dc.ProductSubcategoryKey = dp.SubcategoryKey
JOIN dimproductcategory p ON p.ProductCategoryKey = dc.ProductCategoryKey
Group by p.English_ProductCategoryName, dc.English_ProductSubcategoryName
order by  p.English_ProductCategoryName, dc.English_ProductSubcategoryName,Profit ;


# 5. Top 5 Performing Products

select EnglishProductName as Product_Name, 
concat("$ ",Round((sum(f.SalesAmount)/1000),0)," K") as Total_Revenue
from factsales f join dimproduct as dp using(ProductKey)
group by Product_Name
order by Total_Revenue desc
limit 5;

# 6. Financial Year and Financial Quarter wise Sales,Profit.

SELECT FiscalYear, FiscalQuarter ,
concat("$ ",Round((sum(SalesAmount)/1000000),2)," M") as Total_Revenue ,
concat("$ ",Round((sum(SalesAmount-TotalProductCost)/1000000),2)," M") as Profit
FROM factsales f
JOIN dimdate d ON d.DateKey = f.OrderDateKey
GROUP BY FiscalYear, FiscalQuarter
order by FiscalYear, Total_Revenue desc;

# 7. Quarterly Order placed

SELECT
FISCALQuarter,
Concat(Round(count(SalesOrderNumber)/1000,2)," K") as Total_Orders
FROM factsales f
JOIN dimdate d ON d.DateKey = f.OrderDateKey
GROUP BY  FiscalQuarter
order by  FiscalQuarter, Total_Orders desc;


# 8. Weekly Revenue VS COGS

SELECT
Week_Number, 
concat("$ ",round((sum(TotalProductCost)/1000),0)," K") as COGS,
concat("$ ",Round((sum(SalesAmount)/1000),0)," K") as Total_Revenue,
concat(Round((sum(SalesAmount-TotalProductCost)/sum(SalesAmount))*100,2)," %") 
as `Gross Profit Margin %`
FROM factsales f
JOIN dimdate d ON f.OrderDateKey = d.DateKey
GROUP BY Week_Number
ORDER BY Week_Number,Total_Revenue desc;


# 9. Weekdays vs Weekend Revenue, Profit, Growth %

SELECT 
CASE
	WHEN weekday(OrderDate) IN (1,7) THEN "weekend"
    else
    'Weekday'
end as Daytype,
concat("$ ",Round((sum(SalesAmount)/1000000),2)," M") as Total_Revenue,
concat("$ ",Round((sum(SalesAmount-TotalProductCost)/1000000),2)," M") as Profit,
concat(Round((sum(SalesAmount)/(SELECT sum(SalesAmount) FROM factsales)*100),2)," %") 
AS Revenue_Share
FROM factsales
GROUP BY Daytype;


# 10. YOY Revenue and Profit Change %

WITH RevenueData AS (
    SELECT 
        YEAR(OrderDate) AS Year,
        SUM(SalesAmount) AS Total_Revenue
    FROM factsales
    GROUP BY YEAR(OrderDate)
)
SELECT 
    Year,
    CONCAT("$ ", ROUND(Total_Revenue / 1000000, 2), " M") AS CurrentYear_Revenue,
    CONCAT("$ ", ROUND(LAG(Total_Revenue) OVER (ORDER BY Year) / 1000000, 2), " M") AS PreviousYear_Revenue,
    ROUND(
        ((Total_Revenue - LAG(Total_Revenue) OVER (ORDER BY Year)) / 
        NULLIF(LAG(Total_Revenue) OVER (ORDER BY Year), 0)) * 100, 2
    ) AS `Revenue Change %`
FROM RevenueData
ORDER BY Year;

# 11. Territory Wise Revenue
SELECT 
SalesTerritoryCountry Country, SalesTerritoryRegion Region,
concat("$ ",Round((sum(SalesAmount)/1000),0)," K") as Total_Revenue,
concat("$ ",Round((sum(SalesAmount-TotalProductCost)/1000),0)," K") as Profit,
concat(Round((sum(SalesAmount-TotalProductCost)/sum(SalesAmount))*100,2)," %") 
as `Gross Profit %`
FROM factsales f
JOIN dimsalesterritory t 
ON f.SalesTerritoryKey = t.SalesTerritoryKey
GROUP BY Country, Region 
ORDER BY Country, Region,Total_Revenue,`Gross Profit %` DESC;


# 12. Which Gender is contributing more to Business?
SELECT 
C.Gender, 
concat("$ ",Round((sum(SalesAmount-TotalProductCost)/1000000),0)," M") as Profit,
concat(Round(
			(sum(f.SalesAmount-f.TotalProductCost)/
			(SELECT sum(SalesAmount-TotalProductCost) FROM factsales))*100,2)," %") AS `Profit Share %`
FROM factsales f
JOIN dimcustomer C
ON f.CustomerKey = C.CustomerKey
GROUP BY GENDER;


# 13. Which Age Group Contribute greater to Business.

SELECT
case														
		WHEN TIMESTAMPDIFF(YEAR, c.BirthDate, f.OrderDate) BETWEEN 18 AND 28 THEN '18-28'
        WHEN TIMESTAMPDIFF(YEAR, c.BirthDate, f.OrderDate) BETWEEN 29 AND 39 THEN '29-39'
        WHEN TIMESTAMPDIFF(YEAR, c.BirthDate, f.OrderDate) BETWEEN 40 AND 50 THEN '40-50'
        WHEN TIMESTAMPDIFF(YEAR, c.BirthDate, f.OrderDate) BETWEEN 60 AND 70 THEN '60-70'
        WHEN TIMESTAMPDIFF(YEAR, c.BirthDate, f.OrderDate) BETWEEN 71 AND 80 THEN '71-80'
    ELSE "Above 80 Yrs"
END as Age_Group ,
concat("$ ",Round((sum(SalesAmount-TotalProductCost)/1000),0)," k") as Profit,
concat(Round(
			(sum(f.SalesAmount-f.TotalProductCost)/
			(SELECT sum(SalesAmount-TotalProductCost) FROM factsales))*100,2)," %") AS `Profit Share %`
FROM dimcustomer C
JOIN factsales f
ON f.CustomerKey = C.CustomerKey
GROUP BY Age_Group
Order by Age_Group;


# 14. Which Working class contributing greater to business?
SELECT
C.EnglishOccupation Working_Class,
concat("$ ",Round((sum(SalesAmount-TotalProductCost)/1000000),0)," M") as Profit,
concat(Round(
			(sum(f.SalesAmount-f.TotalProductCost)/
			(SELECT sum(SalesAmount-TotalProductCost) FROM factsales))*100,2)," %") AS `Profit Share %`
FROM factsales f
JOIN dimcustomer C
ON f.CustomerKey = C.CustomerKey
group by Working_Class
Order by `Profit Share %`;





use AdventureWorks2017;
-- table persistante
select 
	ProductID, Name, ListPrice 
into
	t
from 
	Production.Product 
where 
	ListPrice > 2000

-- table temporaire persistante
select 
	ProductID, Name, ListPrice 
into
	#t
from 
	Production.Product 
where 
	ListPrice > 2000

-- table temporaire partagée et persistante
select 
	ProductID, Name, ListPrice 
into
	##t
from 
	Production.Product 
where 
	ListPrice > 2000

-- table temporaire volatile (mémoire)
-- https://learn.microsoft.com/fr-fr/sql/t-sql/queries/with-common-table-expression-transact-sql?view=sql-server-ver16

WITH Sales_CTE(SalesPersonID, NumberOfOrders)
as
(
	 SELECT SalesPersonID, COUNT(*)
     FROM Sales.SalesOrderHeader
     WHERE SalesPersonID IS NOT NULL
     GROUP BY SalesPersonID
)
SELECT AVG(NumberOfOrders) AS "Average Sales Per Person"
FROM Sales_CTE;
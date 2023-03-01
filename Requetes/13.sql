-- CTE : Common table expression
use AdventureWorks2017;

-- Create an Employee table.
CREATE TABLE dbo.MyEmployees
(
EmployeeID SMALLINT NOT NULL,
FirstName NVARCHAR(30) NOT NULL,
LastName NVARCHAR(40) NOT NULL,
Title NVARCHAR(50) NOT NULL,
DeptID SMALLINT NOT NULL,
ManagerID SMALLINT NULL,
CONSTRAINT PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC),
CONSTRAINT FK_MyEmployees_ManagerID_EmployeeID FOREIGN KEY (ManagerID) REFERENCES dbo.MyEmployees (EmployeeID)
);
-- Populate the table with values.
INSERT INTO dbo.MyEmployees VALUES
(1, N'Ken', N'Sánchez', N'Chief Executive Officer',16, NULL)
,(273, N'Brian', N'Welcker', N'Vice President of Sales', 3, 1)
,(274, N'Stephen', N'Jiang', N'North American Sales Manager', 3, 273)
,(275, N'Michael', N'Blythe', N'Sales Representative', 3, 274)
,(276, N'Linda', N'Mitchell', N'Sales Representative', 3, 274)
,(285, N'Syed', N'Abbas', N'Pacific Sales Manager', 3, 273)
,(286, N'Lynn', N'Tsoflias', N'Sales Representative', 3, 285)
,(16, N'David', N'Bradley', N'Marketing Manager', 4, 273)
,(23, N'Mary', N'Gibson', N'Marketing Specialist', 4, 16);

select * from MyEmployees

WITH DirectReports(ManagerID, EmployeeID, Title, EmployeeLevel) AS
(
	select ManagerID, EmployeeID, Title, 1 from MyEmployees where ManagerID is NULL
	UNION ALL
	SELECT e.ManagerID, e.EmployeeID, e.Title, EmployeeLevel + 1
    FROM dbo.MyEmployees AS e
        INNER JOIN DirectReports AS d
        ON e.ManagerID = d.EmployeeID
)
select * from DirectReports


-- EXERCICE 
-- Réécrire avec CTE
select 
	h.SalesPersonID, COUNT(d.ProductID) n  
from 
	Sales.SalesOrderDetail d
	inner join Sales.SalesOrderHeader h on h.SalesOrderID = d.SalesOrderID
Where 
	h.SalesPersonID in 
	(
	select TOP 3
		p.BusinessEntityID
	from 
		Sales.SalesOrderHeader h
		inner join Sales.SalesOrderDetail d on d.SalesOrderID = h.SalesOrderID
		inner join Sales.SalesPerson sp on sp.BusinessEntityID = h.SalesPersonID
		inner join HumanResources.Employee e on e.BusinessEntityID = sp.BusinessEntityID
		inner join Person.Person p on p.BusinessEntityID = e.BusinessEntityID
	where 
		OnlineOrderFlag=0 
	GROUP BY
		Year(orderDate), p.BusinessEntityID
	ORDER BY 
		SUM(OrderQty * UnitPrice) desc
	)
GROUP BY
	h.SalesPersonID
go
WITH MeilleursVendeur(id) as
(
	select TOP 3
		p.BusinessEntityID
	from 
		Sales.SalesOrderHeader h
		inner join Sales.SalesOrderDetail d on d.SalesOrderID = h.SalesOrderID
		inner join Sales.SalesPerson sp on sp.BusinessEntityID = h.SalesPersonID
		inner join HumanResources.Employee e on e.BusinessEntityID = sp.BusinessEntityID
		inner join Person.Person p on p.BusinessEntityID = e.BusinessEntityID
	where 
		OnlineOrderFlag=0 
	GROUP BY
		Year(orderDate), p.BusinessEntityID
)
select 
	h.SalesPersonID, COUNT(d.ProductID) n  
from 
	Sales.SalesOrderDetail d
	inner join Sales.SalesOrderHeader h on h.SalesOrderID = d.SalesOrderID
Where 
	h.SalesPersonID in (select id from MeilleursVendeur)
GROUP BY
	h.SalesPersonID

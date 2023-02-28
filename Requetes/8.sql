use AdventureWorks2017
go
-- Liste des personnes : id, nom, prenom (Linq)
select BusinessEntityID id, FirstName prenom, LastName nom  from Person.Person

-- Liste des produits : id, nom, prix, référence, id sousCat
select ProductID, [Name], ListPrice, ProductNumber, ProductSubcategoryID  from Production.Product

--Liste des sous cat : id, nom, id cat
select ProductSubcategoryID, Name, ProductCategoryID from Production.ProductSubcategory

--Liste des cat : id, nom
select ProductcategoryID, Name from Production.ProductCategory

-- Liste des produits : id, Nom produit, Nom sous cat
select 
	p.ProductID, p.Name NomProduit, s.Name NomSousCat
from 
	Production.Product p
	inner join Production.ProductSubcategory s on p.ProductSubcategoryID = s.ProductSubcategoryID

-- Liste des sous cat : nom, nombre de produits
select 
	s.Name nom, COUNT(p.ProductID) n
from 
	Production.ProductSubcategory s
	inner join Production.Product p on p.ProductSubcategoryID = s.ProductSubcategoryID
Group by
	s.Name

-- Liste des cat :  nom cat, nombre de produits
select 
	c.Name Categorie, Count(p.ProductID) n
from 
	Production.ProductCategory c
	inner join Production.ProductSubcategory s on s.ProductSubcategoryID = c.ProductCategoryID
	inner join Production.Product p on p.ProductSubcategoryID = s.ProductSubcategoryID
Group by
	c.Name

-- Liste des commandes : date, Reference, montant : trié par date asc
--select OrderDate, SalesOrderNumber from Sales.SalesOrderHeader
--select SalesOrderID, OrderQty, UnitPrice from Sales.SalesOrderDetail
select 
	h.OrderDate DateCommande, h.SalesOrderNumber ReferenceCommande, d.SalesOrderID, SUM(OrderQty * UnitPrice) montant
from 
	Sales.SalesOrderDetail d 
	inner join Sales.SalesOrderHeader h on d.SalesOrderID = h.SalesOrderID
Group by
	d.SalesOrderID, h.OrderDate, h.SalesOrderNumber
Order by 
	DateCommande

-- CA par année
select 
	YEAR(h.OrderDate) Annee, SUM(OrderQty * UnitPrice) montant
from 
	Sales.SalesOrderDetail d 
	inner join Sales.SalesOrderHeader h on d.SalesOrderID = h.SalesOrderID
Group by
	YEAR(h.OrderDate)

-- CA par cat et sous cat : Nom cat, nom souscat, montant : trié par cat/sous cat
select 
	c.Name Cat, s.Name SousCat, SUM(OrderQty * UnitPrice) montant 
from 
	Sales.SalesOrderDetail d
	inner join Production.Product p on d.ProductID = p.ProductID
	inner join Production.ProductSubcategory s on p.ProductSubcategoryID = s.ProductSubcategoryID
	inner join Production.ProductCategory c on c.ProductCategoryID = s.ProductCategoryID
Group by
	c.Name, s.Name
Order by
	c.Name, s.Name

-- Liste des employés : id, Nom, prenom, dateEmbauche, TypePersonne
--select * from HumanResources.Employee
--select * from Person.Person where PersonType='EM'
select 
	p.BusinessEntityID, p.LastName, p.FirstName, e.HireDate, p.PersonType 
from 
	HumanResources.Employee e 
	inner join Person.Person p on e.BusinessEntityID = p.BusinessEntityID

-- Liste des types de personnes
--SC = Store Contact, 
--IN = Individual (retail) customer, 
--SP = Sales person, 
--EM = Employee (non-sales), 
--VC = Vendor contact, 
--GC = General contact
select distinct PersonType from Person.Person 

-- meilleur vendeur en 2013 : nom
--select SalesOrderID, SalesPersonID from Sales.SalesOrderHeader -- 31 465 commandes
--select SalesOrderID, SalesPersonID from Sales.SalesOrderHeader where OnlineOrderFlag=0 -- 3 806 commandes

select TOP 1
	p.LastName
from 
	Sales.SalesOrderHeader h
	inner join Sales.SalesOrderDetail d on d.SalesOrderID = h.SalesOrderID
	inner join Sales.SalesPerson sp on sp.BusinessEntityID = h.SalesPersonID
	inner join HumanResources.Employee e on e.BusinessEntityID = sp.BusinessEntityID
	inner join Person.Person p on p.BusinessEntityID = e.BusinessEntityID
where 
	OnlineOrderFlag=0 
GROUP BY
	Year(orderDate), p.LastName
HAVING
	Year(orderDate)=2013
ORDER BY 
	SUM(OrderQty * UnitPrice) desc
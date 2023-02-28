use AdventureWorks2017
go
-- Liste des personnes : id, nom, prenom (Linq)
select BusinessEntityID id, FirstName prenom, LastName nom  from Person.Person

-- Liste des produits : id, nom, prix, r�f�rence, id sousCat
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

-- Liste des commandes : date, Reference, montant : tri� par date asc
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

-- CA par ann�e
select 
	h.OrderDate DateCommande, h.SalesOrderNumber ReferenceCommande, d.SalesOrderID, SUM(OrderQty * UnitPrice) montant
from 
	Sales.SalesOrderDetail d 
	inner join Sales.SalesOrderHeader h on d.SalesOrderID = h.SalesOrderID
Group by
	d.SalesOrderID, h.OrderDate, h.SalesOrderNumber
Order by 
	DateCommande
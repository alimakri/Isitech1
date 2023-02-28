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

-- CA par magasin et internet par année : nom magasin (ou internet), Ville, Année, CA
--select SalesPersonID, Year(OrderDate) from Sales.SalesOrderHeader
--select SalesPersonID, Name from Sales.Store
--select SalesOrderID, UnitPrice, OrderQty from Sales.SalesOrderDetail
--vStoreWithAddresses
select 
	ISNULL(st.Name, '(Internet)') Magasin, 
	SUM(UnitPrice * OrderQty) montant, 
	YEAR(h.OrderDate) Annee 
from 
	Sales.SalesOrderDetail d
	left outer join Sales.SalesOrderHeader h on d.SalesOrderID = h.SalesOrderID
	left outer join Sales.Store st on h.SalesPersonID = st.SalesPersonID
GROUP BY
	st.Name, YEAR(h.OrderDate)
ORDER BY YEAR(h.OrderDate), st.Name 

-- Remplir la table Vente.dbo.Produit avec les vêtements de la table Production.Product
delete Vente.dbo.Produit
insert Vente.Dbo.Produit (Id, Libelle, Prix)
	select NEWID(), p.Name, ListPrice from Production.Product p
	inner join Production.ProductSubcategory s on p.ProductSubcategoryID = s.ProductSubcategoryID
	inner join Production.ProductCategory c on s.ProductCategoryID = c.ProductCategoryID
	where c.Name = 'Clothing'

select * from Vente.Dbo.Produit

-- Remplir la table Vente.dbo.Commande à partir de la table Sales.SalesOrderHeader
delete Vente.dbo.Commande
insert into Vente.dbo.Commande (Id, Numero, DateCommande)
	select NEWID(), h.SalesOrderNumber, OrderDate
	from Sales.SalesOrderHeader h
select * from Vente.dbo.Commande

-- Remplir la table Vente.dbo.CommandeDetails à partir de la table Sales.SalesOrderDetails
insert into Vente.dbo.CommandeDetails (Id, Commande, Produit, Qte, Prix) 
	select 
		NEWID(), vc.Id, vp.Id, d.OrderQty, d.UnitPrice
	from 
		Sales.SalesOrderDetail d
		inner join Sales.SalesOrderHeader h on d.SalesOrderID = h.SalesOrderID
		inner join Production.Product p on d.ProductID = p.ProductID
		inner join Production.ProductSubcategory s on p.ProductSubcategoryID = s.ProductSubcategoryID
		inner join Production.ProductCategory c on s.ProductCategoryID = c.ProductCategoryID
		inner join Vente.dbo.Commande vc on  h.SalesOrderNumber COLLATE DATABASE_DEFAULT = vc.Numero 
		inner join Vente.dbo.Produit vp on vp.Libelle = p.Name COLLATE DATABASE_DEFAULT
	Where
		c.name='Clothing'

-- Vérification : CA total dans la BD Vente (Clothing dans Adv 2 141 507,0245)
-- 2 141 353.77000
select SUM(Qte* Prix) from Vente.dbo.CommandeDetails

-- CA (ordre desc) par cat avec numérotation
select 
	ROW_NUMBER() OVER(ORDER BY SUM(OrderQty * UnitPrice) desc) ordre,
	c.Name Cat, SUM(OrderQty * UnitPrice) montant 
from 
	Sales.SalesOrderDetail d
	inner join Production.Product p on d.ProductID = p.ProductID
	inner join Production.ProductSubcategory s on p.ProductSubcategoryID = s.ProductSubcategoryID
	inner join Production.ProductCategory c on c.ProductCategoryID = s.ProductCategoryID
Group by
	c.Name
Order by 
	montant desc

-- Qté de produits vendus par les 3 meilleurs vendeurs
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


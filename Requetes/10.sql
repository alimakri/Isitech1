use AdventureWorks2017
GO
ALTER PROC ListeProduits(@couleur nvarchar(50)=null, @seuil int=null)
AS
select 
	ProductID, ProductNumber, Color, ListPrice 
from 
	Production.Product
where 
	Color=@couleur 
	and 
	ListPrice > @seuil
GO

Exec ListeProduits 'Red', 1000
Exec ListeProduits 'Red'
Exec ListeProduits

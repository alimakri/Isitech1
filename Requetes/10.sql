use AdventureWorks2017
GO
ALTER PROC ListeProduits(@couleur nvarchar(50)=null, @seuil int=null, @type char(2)=null)
AS
select 
	ProductID, ProductNumber, Color, ListPrice 
from 
	Production.Product
where 
	(@couleur is null or Color=@couleur) 
	and 
	(@seuil is null or ListPrice > @seuil)
	and
	(@type is null or ProductNumber like @type + '%')
GO

Exec ListeProduits 'Red', 1000, 'BK'
Exec ListeProduits 'Red'
Exec ListeProduits
Exec ListeProduits @couleur='Red', @type='BK'
Exec ListeProduits @seuil=2000, @type='BK'

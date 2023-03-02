DECLARE @requete nvarchar(MAX)
SET @requete = 'select * from Produit'
SET @requete = @requete + ' where prix > 300'
Exec (@requete)
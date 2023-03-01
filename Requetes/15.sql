use vente
GO
ALTER PROC EditionProduit(@data xml)
AS
	-- Récupération XML
	SELECT
		N.value('@op[1]', 'nvarchar(MAX)') AS op,
		N.value('@id[1]', 'uniqueidentifier') AS id,
		N.value('libelle[1]', 'nvarchar(MAX)') AS libelle,
		N.value('prix[1]', 'decimal(18,2)') AS prix
	into #t
	FROM
		@data.nodes('/produits/produit') AS T(N)

	-- Delete
	delete Produit where id in (select id from #t where op='delete')
GO
Exec EditionProduit '
					<produits>
						<produit op="delete" id="CB9A7ECA-A7EA-4050-B243-01AE1EFA74CA"/>
						<produit op="ajout">
							<libelle>TShirt vert</libelle>
							<prix>66.20</prix>
						</produit>
					</produits>
					'

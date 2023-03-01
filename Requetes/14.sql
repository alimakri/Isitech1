-- ****************************************************
-- Exercice : Procédures stockées pour la BD Vente
-- Ajouter Produit : Jogging 35.50, 
-- Ajouter Produit : Polo d'action 58,80
-- Ajouter Commande : 2 jogging et 3 polos
-- ****************************************************
use Vente;
Exec AjoutProduit 'Jogging', 35.50
Exec AjoutProduit 'Polo d''action', 58.80
Exec AjoutCommande '
					<commandes>
						<commande id="80850DA3-1C2D-4362-845D-9D02097BBB08">
							<qte>2</qte>
						</commande>
						<commande id="D62F13A5-E396-4BC8-BF2C-B00CE5250CA4">
							<qte>3</qte>
						</commande>
					</commandes>'
GO
CREATE PROC AjoutProduit(@libelle nvarchar(MAX), @prix money)
AS
	Insert produit (Libelle, Prix) values(@libelle, @prix)
GO
CREATE PROC AjoutCommande(@data xml)
AS
	SELECT
		N.value('@id[1]', 'uniqueidentifier') AS id,
		N.value('qte[1]', 'INT') AS Qte
	FROM
		@data.nodes('/commandes/commande') AS T(N)

	
GO

select * from Produit order by Libelle
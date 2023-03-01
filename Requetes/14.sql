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
						<commande id="4F8B4BCF-2507-4F7B-8405-CA41FDC74911">
							<qte>2</qte>
						</commande>
						<commande id="F189CEE0-4901-4F76-B8E0-C4EFEF6E2BC9">
							<qte>3</qte>
						</commande>
					</commandes>'
GO
CREATE PROC AjoutProduit(@libelle nvarchar(MAX), @prix money)
AS
	Insert produit (Libelle, Prix) values(@libelle, @prix)
GO
ALTER PROC AjoutCommande(@data xml)
AS
	SELECT
		N.value('@id[1]', 'uniqueidentifier') AS id,
		N.value('qte[1]', 'INT') AS Qte
	into #t
	FROM
		@data.nodes('/commandes/commande') AS T(N)

	DECLARE @id uniqueidentifier = newid()
	
	INSERT Commande (Id, Numero, DateCommande)
	values(@id, convert(varchar(8),getdate(),112), getdate())

	 Insert CommandeDetails (Id, Commande, Produit, Qte, Prix) 
	 select Newid(), @id, #t.id, #t.Qte,p.Prix  from #t 
	 inner join Produit p on #t.id = p.Id

GO

select * from Produit order by Libelle
select * from Commande c inner join CommandeDetails d on d.Commande = c.Id
where d.Produit in ('4F8B4BCF-2507-4F7B-8405-CA41FDC74911', 'F189CEE0-4901-4F76-B8E0-C4EFEF6E2BC9')

select * from commande  where id='2F9B7FC3-6B3A-40B6-A5C2-145F127CCA19'
select * from CommandeDetails where Commande='2F9B7FC3-6B3A-40B6-A5C2-145F127CCA19'

-- 21 394
delete commande where Numero like '2023%'
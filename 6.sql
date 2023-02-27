use Vente
go
select * from Produit
BEGIN TRAN
insert Produit (Libelle, Prix) values('Cahier', 5.50)
insert Produit (Libelle, Prix) values('Gomme', 1.50)
insert Produit (Libelle, Prix) values('Souris', 53.20)
COMMIT
select * from Produit

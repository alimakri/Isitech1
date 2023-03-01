-- ****************************************************
-- Exercice : Procédures stockées pour la BD Vente
-- Ajouter Produit : Jogging 35.50, 
-- Ajouter Produit : Polo d'action 58,80
-- Ajouter Commande : 2 jogging et 3 polos
-- ****************************************************
use Vente;
Exec AjoutProduit 'Jogging' 35.50
Exec AjoutProduit 'Polo d''action' 58.80
Exec AjoutCommande '
					<commandes>
						<commande id="1">
							<qte>2</qte>
						</commande>
						<commande id="2">
							<qte>3</qte>
						</commande>
					</commandes>'


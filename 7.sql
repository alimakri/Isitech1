select 1 as A, 'ABC' B, getdate() C, NEWID() D, 3+5 E, 'GHI' + 'JK' F
UNION ALL
select 2 , 'DE', DATEADD(day, -1, getdate()), NEWID(), NULL, NULL

select * from 
(
select 'A' col1
UNION ALL
select 'B' 
UNION ALL
select 'C'
) t1
,
(
select 1 col1
UNION ALL
select 2 
UNION ALL
select 3
) t2

DROP TABLE personne
DROP TABLE Ville

select 
* 
into personne 
from
(
select 'Pierre' Prenom, 1 Ville
Union ALL
select 'Paul', 1
Union ALL
select 'Jacques', 2
Union ALL
select 'Henri', NULL
) t

select 
* 
into ville 
from
(
select 1 Id, 'Lyon' Libelle
Union ALL
select 2, 'Paris'
Union ALL
select 3, 'Marseille'
) t

select * from ville
select * from personne

--select * from personne, ville
--where personne.Ville = ville.Id

select * from personne full outer join ville on personne.Ville = ville.Id

--select * from ville inner join personne on personne.Ville = ville.Id

--select * from ville cross join personne 

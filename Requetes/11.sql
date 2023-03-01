-- *****************************************************************************
-- Exercice XML avec Proc Stoc
-- *****************************************************************************

DECLARE @xml XML = '
<root>
	<person name="Pierre">
		<age>30</age>
	</person>
	<person name="Sophie">
		<age>25</age>
	</person>
</root>'

SELECT
    Person.value('@name[1]', 'VARCHAR(50)') AS Name,
    Person.value('age[1]', 'INT') AS Age
FROM
    @xml.nodes('/root/person') AS People(Person)

-- *****************************************************************************
CREATE PROC ListeProduitsXML(@data xml)
AS
IF @couleur = 'Rouge'
  BEGIN
  SET @couleur='red'
  END
ELSE IF @couleur = 'Noir'
	SET @couleur='black' 

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
Exec ListeProduitsXML '.....'
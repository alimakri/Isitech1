use master;
go
ALTER AUTHORIZATION ON database::AdventureWorks2017 TO [Pione\alima];

use AdventureWorks2017
go
SELECT Person.Person.BusinessEntityID, Person.Person.FirstName, Person.Person.LastName, Person.Address.City
FROM     Person.Address INNER JOIN
                  Person.BusinessEntityAddress ON Person.Address.AddressID = Person.BusinessEntityAddress.AddressID INNER JOIN
                  Person.BusinessEntity ON Person.BusinessEntityAddress.BusinessEntityID = Person.BusinessEntity.BusinessEntityID INNER JOIN
                  Person.Person ON Person.BusinessEntity.BusinessEntityID = Person.Person.BusinessEntityID
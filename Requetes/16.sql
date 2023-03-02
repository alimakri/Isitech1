-- Exemple 1
-- https://www.codeproject.com/Articles/28429/Basics-of-Using-a-NET-Assembly-in-MS-SQLServer-Use
use master
go
-- Etape 1 : Configurer SQL Server pour accepter le .Net
sp_configure 'clr enabled', 1
GO
RECONFIGURE
GO

-- Etape 2 : 
CREATE ASYMMETRIC KEY CLRDateConvertionKey FROM EXECUTABLE FILE = 'D:\IsiTech\Depot\ClrSQL\bin\Debug\ClrSQL.dll'
--select * from Sys.asymmetric_keys

-- Etape 3 : 
CREATE LOGIN CLRDateConvertionKeyLogin FROM ASYMMETRIC KEY CLRDateConvertionKey;
GRANT UNSAFE ASSEMBLY TO CLRDateConvertionKeyLogin;

GO
USE AdventureWorks2017;
GO
-- Etape 4 : créatin du User
CREATE USER CLRDateConvertionKeyLogin FOR LOGIN CLRDateConvertionKeyLogin;

-- Etape 5 : installation de l'assembly dans AdventureWorks
CREATE ASSEMBLY DateConvertAssembly FROM 'D:\IsiTech\Depot\ClrSQL\bin\Debug\ClrSQL.dll' WITH PERMISSION_SET = SAFE;
GO

--Etape 6 : 
CREATE FUNCTION dbo.DateConvert (@date NVARCHAR(100), @format NVARCHAR(100))
RETURNS NVARCHAR(100)
AS
     EXTERNAL NAME [DateConvertAssembly].[ClrSQL.DateConvertion].[DateConvert];
GO

-- Test
SELECT dbo.DateConvert ('10/01/2020', 'dd-MMM-yyyy') as [Date];

-- DROP
DROP ASYMMETRIC KEY CLRDateConvertionKey
DROP LOGIN CLRDateConvertionKeyLogin
DROP FUNCTION [dbo].[DateConvert]
Drop ASSEMBLY DateConvertAssembly;

-- **********************************************************************
-- **********************************************************************

-- Exemple 2 
-- https://learn.microsoft.com/fr-fr/sql/relational-databases/clr-integration-database-objects-user-defined-types/clr-user-defined-types?view=sql-server-ver16
USE AdventureWorks2017;  
CREATE ASSEMBLY Point  
FROM 'D:\Cours\CoursSQL\CLRInSQLServer\CLRInSQLServer\bin\Debug\CLRInSQLServer.dll'   
WITH PERMISSION_SET = SAFE; 

CREATE TYPE dbo.Point EXTERNAL NAME Point.[Point];  

-- Test
CREATE TABLE dbo.Dessin(
	Id [smallint] IDENTITY(1,1) NOT NULL,
	Coord Point NOT NULL)
GO
INSERT INTO dbo.Dessin (Coord) VALUES (CONVERT(Point, '3,4'));  
INSERT INTO dbo.Dessin (Coord) VALUES (CONVERT(Point, '1,5'));  
INSERT INTO dbo.Dessin (Coord) VALUES (CAST ('1,99' AS Point));  

SELECT Id, coord AS PointValue FROM dbo.Dessin;  
SELECT Id, coord.ToString() AS PointValue FROM dbo.Dessin;  
-- Etape 1 : Configurer SQL Server pour accepter le .Net
use master
go
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
CREATE FUNCTION dbo.Crypte (@cle int, @message NVARCHAR(100))
RETURNS NVARCHAR(100)
AS
     EXTERNAL NAME [DateConvertAssembly].[ClrSQL.CryptoSimple].Crypte;
GO
CREATE FUNCTION dbo.Decrypte (@cle int, @message NVARCHAR(100))
RETURNS NVARCHAR(100)
AS
     EXTERNAL NAME [DateConvertAssembly].[ClrSQL.CryptoSimple].Decrypte;
GO

-- Test
DECLARE @message nvarchar(50) = 'ABC'
DECLARE @messageCrypte nvarchar(50)
select @messageCrypte = dbo.Crypte(3, @message)
PRINT @messageCrypte
select @message = dbo.Decrypte(-3, @messageCrypte)
PRINT @message
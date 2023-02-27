use master;
CREATE DATABASE Formule1 ON  PRIMARY 
	( 
	NAME = N'Formule1', 
	FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\Formule1.mdf' , 
	SIZE = 8192KB , 
	FILEGROWTH = 65536KB )
 LOG ON 
	( 
	NAME = N'Formule1_log', 
	FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\Formule1_log.ldf' , 
	SIZE = 8192KB , 
	FILEGROWTH = 65536KB 
	)
go
USE [Formule1];
CREATE TABLE [dbo].[Ecurie]
(
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Nom] [nvarchar](max) NOT NULL,
	CONSTRAINT [PK_Ecurie] PRIMARY KEY CLUSTERED 
	(
	[Id] ASC
	)
) 
CREATE TABLE [dbo].[EcurieGrandPrix](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Ecurie] [bigint] NOT NULL,
	[GrandPrix] [bigint] NOT NULL,
	CONSTRAINT [PK_EcurieGrandPrix] PRIMARY KEY CLUSTERED 
	(
	[Id] ASC
	)
) 
CREATE TABLE [dbo].[GrandPrix]
(
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Lieu] [nvarchar](max) NOT NULL,
	CONSTRAINT [PK_GrandPrix] PRIMARY KEY CLUSTERED 
	(
	[Id] ASC
	)
)
CREATE TABLE [dbo].[Pilote](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Nom] [nvarchar](max) NOT NULL,
	[Ecurie] [bigint] NULL,
	[Numero] [char](2) NOT NULL,
	[Actif] [bit] NOT NULL,
	CONSTRAINT [PK_Pilote] PRIMARY KEY CLUSTERED 
	(
	[Id] ASC
	)
);
ALTER TABLE [dbo].[Pilote] ADD  CONSTRAINT [DF_Pilote_Actif]  DEFAULT ((0)) FOR [Actif]
GO
-- Clés étrangères 
--EcurieGrandPrix
ALTER TABLE [dbo].[EcurieGrandPrix]  WITH CHECK ADD  CONSTRAINT [FK_EcurieGrandPrix_Ecurie] FOREIGN KEY([Ecurie]) REFERENCES [dbo].[Ecurie] ([Id])
ALTER TABLE [dbo].[EcurieGrandPrix] CHECK CONSTRAINT [FK_EcurieGrandPrix_Ecurie]

ALTER TABLE [dbo].[EcurieGrandPrix]  WITH CHECK ADD  CONSTRAINT [FK_EcurieGrandPrix_GrandPrix] FOREIGN KEY([GrandPrix]) REFERENCES [dbo].[GrandPrix] ([Id])
ALTER TABLE [dbo].[EcurieGrandPrix] CHECK CONSTRAINT [FK_EcurieGrandPrix_GrandPrix]

-- Pilote
ALTER TABLE [dbo].[Pilote]  WITH CHECK ADD  CONSTRAINT [FK_Pilote_Ecurie] FOREIGN KEY([Ecurie]) REFERENCES [dbo].[Ecurie] ([Id])
ALTER TABLE [dbo].[Pilote] CHECK CONSTRAINT [FK_Pilote_Ecurie]


insert Ecurie (Nom) values
	('Renault'), 
	('Mercedes'), 
	('Alfa Romeo'), 
	('Ferrari')
insert Pilote (Nom, Ecurie, Numero, Actif) values
	('Lewis Hamilton', 2, '44', 1),
	('Charles Leclerc', 4, '12', 1),
	('George Russell', 2, '33', 1),
	('Carlos Sainz Jr.', 4, '55', 1),
	('Valtteri Bottas', 3, '47', 1),
	('Zhou Guanyu', 3, '14', 1)
insert GrandPrix (Lieu) values('Monte Carlo'), ('Bahrein'), ('Australie'), ('Espagne')
insert EcurieGrandPrix (Ecurie, GrandPrix) values
	(1,1),
	(2,1),
	(3,1),
	(1,2),
	(2,2),
	(3,3),
	(4,3)

-- Test 1 : écuries au grand prix de Monte Carlo
SELECT Ecurie.Nom
FROM     Ecurie INNER JOIN
                  EcurieGrandPrix ON Ecurie.Id = EcurieGrandPrix.Ecurie INNER JOIN
                  GrandPrix ON EcurieGrandPrix.GrandPrix = GrandPrix.Id
WHERE  (GrandPrix.Lieu = N'Monte Carlo')

-- Test 2: Grand Prix pour Renault
SELECT GrandPrix.Lieu
FROM     Ecurie INNER JOIN
                  EcurieGrandPrix ON Ecurie.Id = EcurieGrandPrix.Ecurie INNER JOIN
                  GrandPrix ON EcurieGrandPrix.GrandPrix = GrandPrix.Id
WHERE  (Ecurie.Nom = N'Renault')

-- Test 3 : Grand prix d'Hamilton
SELECT GrandPrix.Lieu
FROM     EcurieGrandPrix INNER JOIN
                  GrandPrix ON EcurieGrandPrix.GrandPrix = GrandPrix.Id INNER JOIN
                  Pilote ON EcurieGrandPrix.Ecurie = Pilote.Ecurie
WHERE  (Pilote.Nom = N'Lewis Hamilton')

-- Test 4 : liste des grand prix écurie
SELECT 
	Ecurie.Nom, GrandPrix.Lieu
FROM     
	Ecurie 
	RIGHT OUTER JOIN EcurieGrandPrix ON Ecurie.Id = EcurieGrandPrix.Ecurie 
	RIGHT OUTER JOIN GrandPrix ON EcurieGrandPrix.GrandPrix = GrandPrix.Id


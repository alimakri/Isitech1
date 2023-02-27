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
USE [Formule1]
GO
CREATE TABLE [dbo].[Ecurie]
(
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Nom] [nvarchar](max) NOT NULL,
	CONSTRAINT [PK_Ecurie] PRIMARY KEY CLUSTERED 
	(
	[Id] ASC
	)
) 
GO
CREATE TABLE [dbo].[EcurieGrandPrix](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Ecurie] [bigint] NOT NULL,
	[GrandPrix] [bigint] NOT NULL,
	CONSTRAINT [PK_EcurieGrandPrix] PRIMARY KEY CLUSTERED 
	(
	[Id] ASC
	)
) 
GO
CREATE TABLE [dbo].[GrandPrix]
(
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Lieu] [nvarchar](max) NOT NULL,
	CONSTRAINT [PK_GrandPrix] PRIMARY KEY CLUSTERED 
	(
	[Id] ASC
	)
)
GO
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
) 
GO
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







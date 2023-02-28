USE [master];
CREATE DATABASE [Vente] ON  PRIMARY 
	( 
	NAME = N'Vente', 
	FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\Vente.mdf' , 
	SIZE = 8192KB , 
	MAXSIZE = UNLIMITED, 
	FILEGROWTH = 65536KB 
	)
LOG ON 
	( 
	NAME = N'Vente_log', 
	FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\Vente_log.ldf' , 
	SIZE = 8192KB , 
	MAXSIZE = 2048GB , 
	FILEGROWTH = 65536KB
	);
GO
USE [Vente];

-- Produit
CREATE TABLE [dbo].[Produit]
(
	[Id] [uniqueidentifier] NOT NULL,
	[Libelle] [nvarchar](max) NOT NULL,
	[Prix] [decimal](18, 2) NOT NULL,
	CONSTRAINT [PK_Produit] PRIMARY KEY CLUSTERED 
		(
		[Id] ASC
		)
); 
ALTER TABLE [dbo].[Produit] ADD  CONSTRAINT [DF_Produit_Id]  DEFAULT (newid()) FOR [Id];
ALTER TABLE [dbo].[Produit] ADD  CONSTRAINT [DF_Produit_Prix]  DEFAULT ((0)) FOR [Prix];
GO
-- Commande
CREATE TABLE [dbo].[Commande]
(
	[Id] [uniqueidentifier] NOT NULL,
	[Numero] [char](10) NOT NULL,
	[DateCommande] [datetime] NOT NULL,
	CONSTRAINT [PK_Commande] PRIMARY KEY CLUSTERED 
		(
		[Id] ASC
		)
);
ALTER TABLE [dbo].[Commande] ADD  CONSTRAINT [DF_Commande_Id]  DEFAULT (newid()) FOR [Id]
ALTER TABLE [dbo].[Commande] ADD  CONSTRAINT [DF_Commande_DateCommande]  DEFAULT (getdate()) FOR [DateCommande]
GO
-- CommandeDetails
CREATE TABLE [dbo].[CommandeDetails]
(
	[Id] [uniqueidentifier] NOT NULL,
	[Commande] [uniqueidentifier] NOT NULL,
	[Produit] [uniqueidentifier] NOT NULL,
	[Qte] [decimal](18, 3) NOT NULL,
	[Prix] [decimal](18, 2) NOT NULL,
	CONSTRAINT [PK_CommandeDetails] PRIMARY KEY CLUSTERED 
		(
		[Id] ASC
	)
) 
ALTER TABLE [dbo].[CommandeDetails] ADD  CONSTRAINT [DF_CommandeDetails_Id]  DEFAULT (newid()) FOR [Id];

-- Clés étrangères
ALTER TABLE [dbo].[CommandeDetails]  WITH CHECK ADD  CONSTRAINT [FK_CommandeDetails_Commande] FOREIGN KEY([Commande]) REFERENCES [dbo].[Commande] ([Id]);
ALTER TABLE [dbo].[CommandeDetails] CHECK CONSTRAINT [FK_CommandeDetails_Commande];

ALTER TABLE [dbo].[CommandeDetails]  WITH CHECK ADD  CONSTRAINT [FK_CommandeDetails_Produit] FOREIGN KEY([Produit]) REFERENCES [dbo].[Produit] ([Id]);
ALTER TABLE [dbo].[CommandeDetails] CHECK CONSTRAINT [FK_CommandeDetails_Produit];
GO



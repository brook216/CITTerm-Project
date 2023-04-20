USE [TermProject]
GO

INSERT INTO [dbo].[Customer]
           ([CustomerID]
           ,[Name]
           ,[ZipCode]
           ,[Cell])
     VALUES
           (<CustomerID, int,>
           ,<Name, varchar(25),>
           ,<ZipCode, varchar(5),>
           ,<Cell, varchar(10),>)
GO


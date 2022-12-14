USE [master]
GO
/****** Object:  Database [RestaurantProject]    Script Date: 14-09-2022 01:30:01 ******/
CREATE DATABASE [RestaurantProject]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'RestaurantProject', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\RestaurantProject.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'RestaurantProject_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\RestaurantProject_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [RestaurantProject] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [RestaurantProject].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [RestaurantProject] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [RestaurantProject] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [RestaurantProject] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [RestaurantProject] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [RestaurantProject] SET ARITHABORT OFF 
GO
ALTER DATABASE [RestaurantProject] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [RestaurantProject] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [RestaurantProject] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [RestaurantProject] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [RestaurantProject] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [RestaurantProject] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [RestaurantProject] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [RestaurantProject] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [RestaurantProject] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [RestaurantProject] SET  DISABLE_BROKER 
GO
ALTER DATABASE [RestaurantProject] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [RestaurantProject] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [RestaurantProject] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [RestaurantProject] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [RestaurantProject] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [RestaurantProject] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [RestaurantProject] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [RestaurantProject] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [RestaurantProject] SET  MULTI_USER 
GO
ALTER DATABASE [RestaurantProject] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [RestaurantProject] SET DB_CHAINING OFF 
GO
ALTER DATABASE [RestaurantProject] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [RestaurantProject] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [RestaurantProject] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [RestaurantProject] SET QUERY_STORE = OFF
GO
USE [RestaurantProject]
GO
/****** Object:  UserDefinedFunction [dbo].[ItemPrice]    Script Date: 14-09-2022 01:30:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ItemPrice]
(
    @MenuItemID INT
 )
RETURNS float
AS 
BEGIN
    DECLARE @ItemPrice float
    Select @ItemPrice=ItemPrice from RestaurantMenuItem where (MenuItemID=@MenuItemID)
	RETURN @ItemPrice;
END;


GO
/****** Object:  Table [dbo].[Orders]    Script Date: 14-09-2022 01:30:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[RestaurantID] [int] NOT NULL,
	[MenuITemID] [int] NOT NULL,
	[ItemQuantity] [int] NOT NULL,
	[OrderAmount] [float] NOT NULL,
	[DiningTableId] [int] NOT NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[OrderDetails]    Script Date: 14-09-2022 01:30:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[OrderDetails] (
    @orderID INT
)
RETURNS TABLE
AS
RETURN
    SELECT RestaurantID,OrderAmount,DiningTableId FROM Orders WHERE orderID=@orderID
GO
/****** Object:  UserDefinedFunction [dbo].[OrderDetail]    Script Date: 14-09-2022 01:30:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[OrderDetail] (
    @orderID INT
)
RETURNS TABLE
AS
RETURN
    SELECT * FROM Orders WHERE orderID=@orderID
GO
/****** Object:  Table [dbo].[Cuisine]    Script Date: 14-09-2022 01:30:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cuisine](
	[CuisineID] [int] IDENTITY(1,1) NOT NULL,
	[RestaurantID] [int] NULL,
	[CuisineName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Cuisine] PRIMARY KEY CLUSTERED 
(
	[CuisineID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Cuisine] UNIQUE NONCLUSTERED 
(
	[CuisineID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UC_CuisineName] UNIQUE NONCLUSTERED 
(
	[CuisineName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RestaurantMenuItem]    Script Date: 14-09-2022 01:30:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RestaurantMenuItem](
	[MenuItemID] [int] IDENTITY(1,1) NOT NULL,
	[CuisineID] [int] NOT NULL,
	[ItemName] [nvarchar](100) NOT NULL,
	[ItemPrice] [float] NULL,
 CONSTRAINT [PK_RestaurantMenuItem] PRIMARY KEY CLUSTERED 
(
	[MenuItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_RestaurantMenuItem] UNIQUE NONCLUSTERED 
(
	[MenuItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UC_ItemName] UNIQUE NONCLUSTERED 
(
	[ItemName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[cusinewise item details]    Script Date: 14-09-2022 01:30:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[cusinewise item details]
AS
SELECT        dbo.Cuisine.CuisineName, dbo.RestaurantMenuItem.ItemName, dbo.RestaurantMenuItem.ItemPrice
FROM            dbo.Cuisine INNER JOIN
                         dbo.RestaurantMenuItem ON dbo.Cuisine.CuisineID = dbo.RestaurantMenuItem.CuisineID AND dbo.Cuisine.CuisineID = dbo.RestaurantMenuItem.CuisineID AND 
                         dbo.Cuisine.CuisineID = dbo.RestaurantMenuItem.CuisineID
GO
/****** Object:  Table [dbo].[Bills]    Script Date: 14-09-2022 01:30:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bills](
	[BillsID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NOT NULL,
	[RestaurantID] [int] NOT NULL,
	[BillAmount] [float] NOT NULL,
	[CustomerID] [int] NOT NULL,
 CONSTRAINT [PK_Bills] PRIMARY KEY CLUSTERED 
(
	[BillsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 14-09-2022 01:30:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[RestaurantID] [int] NOT NULL,
	[CustomerName] [nvarchar](100) NOT NULL,
	[Mobileno] [nchar](10) NOT NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DiningTable]    Script Date: 14-09-2022 01:30:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DiningTable](
	[DiningTableID] [int] IDENTITY(1,1) NOT NULL,
	[RestaurantID] [int] NOT NULL,
	[Location] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_DiningTable] PRIMARY KEY CLUSTERED 
(
	[DiningTableID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_DiningTable] UNIQUE NONCLUSTERED 
(
	[DiningTableID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UC_Location] UNIQUE NONCLUSTERED 
(
	[Location] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DiningTableTrack]    Script Date: 14-09-2022 01:30:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DiningTableTrack](
	[DiningTableTrackID] [int] NOT NULL,
	[DiningTableID] [int] NULL,
	[TableStatus] [nvarchar](100) NULL,
 CONSTRAINT [PK_DiningTableTrack] PRIMARY KEY CLUSTERED 
(
	[DiningTableTrackID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Restaurant]    Script Date: 14-09-2022 01:30:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Restaurant](
	[RestaurantID] [int] IDENTITY(1,1) NOT NULL,
	[RestaurantName] [nvarchar](200) NOT NULL,
	[Address] [nvarchar](500) NOT NULL,
	[MobileNo] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_Restaurant] PRIMARY KEY CLUSTERED 
(
	[RestaurantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Restaurant] UNIQUE NONCLUSTERED 
(
	[RestaurantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Restaurant_1] UNIQUE NONCLUSTERED 
(
	[RestaurantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UC_MobileNo] UNIQUE NONCLUSTERED 
(
	[MobileNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UC_RestaurantName] UNIQUE NONCLUSTERED 
(
	[RestaurantName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [NC_Order_CustomerID]    Script Date: 14-09-2022 01:30:01 ******/
CREATE NONCLUSTERED INDEX [NC_Order_CustomerID] ON [dbo].[Bills]
(
	[CustomerID] ASC
)
INCLUDE([BillAmount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [NC_Order_OrderID]    Script Date: 14-09-2022 01:30:01 ******/
CREATE NONCLUSTERED INDEX [NC_Order_OrderID] ON [dbo].[Bills]
(
	[OrderID] ASC
)
INCLUDE([BillAmount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [NC_Order_RestaurantID]    Script Date: 14-09-2022 01:30:01 ******/
CREATE NONCLUSTERED INDEX [NC_Order_RestaurantID] ON [dbo].[Bills]
(
	[RestaurantID] ASC
)
INCLUDE([BillAmount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [NC_Order_RestaurantID]    Script Date: 14-09-2022 01:30:01 ******/
CREATE NONCLUSTERED INDEX [NC_Order_RestaurantID] ON [dbo].[Cuisine]
(
	[RestaurantID] ASC
)
INCLUDE([CuisineName]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [NC_Order_RestaurantID]    Script Date: 14-09-2022 01:30:01 ******/
CREATE NONCLUSTERED INDEX [NC_Order_RestaurantID] ON [dbo].[Customer]
(
	[RestaurantID] ASC
)
INCLUDE([CustomerName],[Mobileno]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [NC_Order_RestaurantID]    Script Date: 14-09-2022 01:30:02 ******/
CREATE NONCLUSTERED INDEX [NC_Order_RestaurantID] ON [dbo].[DiningTable]
(
	[RestaurantID] ASC
)
INCLUDE([Location]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [NC_Order_DiningTableID]    Script Date: 14-09-2022 01:30:02 ******/
CREATE NONCLUSTERED INDEX [NC_Order_DiningTableID] ON [dbo].[DiningTableTrack]
(
	[DiningTableID] ASC
)
INCLUDE([TableStatus]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [NC_Order_DiningTableId]    Script Date: 14-09-2022 01:30:02 ******/
CREATE NONCLUSTERED INDEX [NC_Order_DiningTableId] ON [dbo].[Orders]
(
	[DiningTableId] ASC
)
INCLUDE([OrderDate],[ItemQuantity],[OrderAmount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [NC_Order_MenuITemID]    Script Date: 14-09-2022 01:30:02 ******/
CREATE NONCLUSTERED INDEX [NC_Order_MenuITemID] ON [dbo].[Orders]
(
	[MenuITemID] ASC
)
INCLUDE([OrderDate],[ItemQuantity],[OrderAmount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [NC_Order_RestaurantID]    Script Date: 14-09-2022 01:30:02 ******/
CREATE NONCLUSTERED INDEX [NC_Order_RestaurantID] ON [dbo].[Orders]
(
	[RestaurantID] ASC
)
INCLUDE([OrderDate],[ItemQuantity],[OrderAmount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [NC_Order_CuisineID]    Script Date: 14-09-2022 01:30:02 ******/
CREATE NONCLUSTERED INDEX [NC_Order_CuisineID] ON [dbo].[RestaurantMenuItem]
(
	[CuisineID] ASC
)
INCLUDE([ItemName],[ItemPrice]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Bills]  WITH CHECK ADD  CONSTRAINT [FK_Bills_Customer] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])
GO
ALTER TABLE [dbo].[Bills] CHECK CONSTRAINT [FK_Bills_Customer]
GO
ALTER TABLE [dbo].[Bills]  WITH CHECK ADD  CONSTRAINT [FK_Bills_Order] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Orders] ([OrderID])
GO
ALTER TABLE [dbo].[Bills] CHECK CONSTRAINT [FK_Bills_Order]
GO
ALTER TABLE [dbo].[Bills]  WITH CHECK ADD  CONSTRAINT [FK_Bills_Restaurant] FOREIGN KEY([RestaurantID])
REFERENCES [dbo].[Restaurant] ([RestaurantID])
GO
ALTER TABLE [dbo].[Bills] CHECK CONSTRAINT [FK_Bills_Restaurant]
GO
ALTER TABLE [dbo].[Cuisine]  WITH CHECK ADD  CONSTRAINT [FK_Cuisine_Restaurant] FOREIGN KEY([RestaurantID])
REFERENCES [dbo].[Restaurant] ([RestaurantID])
GO
ALTER TABLE [dbo].[Cuisine] CHECK CONSTRAINT [FK_Cuisine_Restaurant]
GO
ALTER TABLE [dbo].[Cuisine]  WITH CHECK ADD  CONSTRAINT [FK_Restaurant_Cuisine] FOREIGN KEY([RestaurantID])
REFERENCES [dbo].[Restaurant] ([RestaurantID])
GO
ALTER TABLE [dbo].[Cuisine] CHECK CONSTRAINT [FK_Restaurant_Cuisine]
GO
ALTER TABLE [dbo].[Cuisine]  WITH CHECK ADD  CONSTRAINT [FK_RestaurantID] FOREIGN KEY([RestaurantID])
REFERENCES [dbo].[Restaurant] ([RestaurantID])
GO
ALTER TABLE [dbo].[Cuisine] CHECK CONSTRAINT [FK_RestaurantID]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD FOREIGN KEY([RestaurantID])
REFERENCES [dbo].[Restaurant] ([RestaurantID])
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_Restaurant] FOREIGN KEY([RestaurantID])
REFERENCES [dbo].[Restaurant] ([RestaurantID])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_Restaurant]
GO
ALTER TABLE [dbo].[DiningTable]  WITH CHECK ADD  CONSTRAINT [FK_DiningTable_Restaurant] FOREIGN KEY([RestaurantID])
REFERENCES [dbo].[Restaurant] ([RestaurantID])
GO
ALTER TABLE [dbo].[DiningTable] CHECK CONSTRAINT [FK_DiningTable_Restaurant]
GO
ALTER TABLE [dbo].[DiningTableTrack]  WITH CHECK ADD  CONSTRAINT [FK_DiningTableTrack_DiningTable] FOREIGN KEY([DiningTableID])
REFERENCES [dbo].[DiningTable] ([DiningTableID])
GO
ALTER TABLE [dbo].[DiningTableTrack] CHECK CONSTRAINT [FK_DiningTableTrack_DiningTable]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Order_DiningTable] FOREIGN KEY([DiningTableId])
REFERENCES [dbo].[DiningTable] ([DiningTableID])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Order_DiningTable]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Order_Restaurant] FOREIGN KEY([RestaurantID])
REFERENCES [dbo].[Restaurant] ([RestaurantID])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Order_Restaurant]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Order_RestaurantMenuItem] FOREIGN KEY([MenuITemID])
REFERENCES [dbo].[RestaurantMenuItem] ([MenuItemID])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Order_RestaurantMenuItem]
GO
ALTER TABLE [dbo].[RestaurantMenuItem]  WITH CHECK ADD FOREIGN KEY([CuisineID])
REFERENCES [dbo].[Cuisine] ([CuisineID])
GO
ALTER TABLE [dbo].[RestaurantMenuItem]  WITH CHECK ADD  CONSTRAINT [FK_Cuisine_RestaurantMenuItem] FOREIGN KEY([CuisineID])
REFERENCES [dbo].[Cuisine] ([CuisineID])
GO
ALTER TABLE [dbo].[RestaurantMenuItem] CHECK CONSTRAINT [FK_Cuisine_RestaurantMenuItem]
GO
ALTER TABLE [dbo].[RestaurantMenuItem]  WITH CHECK ADD  CONSTRAINT [FK_RestaurantMenuItem_Cuisine] FOREIGN KEY([CuisineID])
REFERENCES [dbo].[Cuisine] ([CuisineID])
GO
ALTER TABLE [dbo].[RestaurantMenuItem] CHECK CONSTRAINT [FK_RestaurantMenuItem_Cuisine]
GO
/****** Object:  StoredProcedure [dbo].[USP_Billsmaster]    Script Date: 14-09-2022 01:30:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_Billsmaster]
      @Statement VARCHAR(10),
	  @BillsID int,
      @OrderID int,
      @BillStatus Nvarchar(50),
	  @CustomerID int,
	  @OrderAmount float
      
AS
BEGIN
      --INSERT
      IF @Statement = 'INSERT'
      BEGIN
			declare @DiningTableId int
			DECLARE @InsertedId int = 0
			declare @RestaurantID int
			declare @BillAmount float
		    SET @RestaurantID= (select RestaurantID from dbo.OrderDetails(@OrderID))
		    SET @BillAmount= (select OrderAmount from dbo.OrderDetails(@OrderID))
			SET @DiningTableId= (select DiningTableId from dbo.OrderDetails(@OrderID))
			--SET @RestaurantID=dbo.OrderDetails(@OrderID)
		  	INSERT INTO Bills(OrderID,RestaurantID,BillAmount,CustomerID)
            VALUES (@OrderID,@RestaurantID,@BillAmount,@CustomerID)
			SET @InsertedId = SCOPE_IDENTITY()
						SELECT @InsertedId
						IF(@InsertedId > 0)
						 BEGIN 
								UPDATE DiningTableTrack SET TableStatus = 'Vacant' WHERE DiningTableid=@DiningTableId
						 END
      END
 
--      --UPDATE
      IF @Statement = 'UPDATE'	
      BEGIN
	  UPDATE Bills
            SET OrderID=@OrderID,RestaurantID=@RestaurantID,BillAmount=@BillAmount,CustomerID=@CustomerID
            WHERE BillsID = @BillsID
      END
 
      --DELETE
      IF @Statement = 'DELETE'
      BEGIN
            DELETE FROM Bills
            WHERE BillsID = @BillsID
      END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Cuisinemaster]    Script Date: 14-09-2022 01:30:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_Cuisinemaster]
      @Statement VARCHAR(10),
	  @CuisineID int,
      @RestaurantID int,
      @CuisineName Nvarchar(50)
      
AS
BEGIN
      --INSERT
      IF @Statement = 'INSERT'
      BEGIN
		  	--select @RestaurantID=SCOPE_IDENTITY()
					--if exists(select RestaurantID from Restaurant)

            INSERT INTO Cuisine(RestaurantID,CuisineName)
            VALUES (@RestaurantID,@CuisineName)
      END
 
      --UPDATE
      IF @Statement = 'UPDATE'	
      BEGIN
	  UPDATE Cuisine
            SET CuisineName = @CuisineName
            WHERE CuisineID = @CuisineID
      END
 
      --DELETE
      IF @Statement = 'DELETE'
      BEGIN
            DELETE FROM Cuisine
            WHERE CuisineID = @CuisineID
      END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_CustomereMaster]    Script Date: 14-09-2022 01:30:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_CustomereMaster]
      @Statement VARCHAR(10),
	  @CustomerID int,
	  @RestaurantID int,
      @CustomerName Nvarchar(100),
	  @Mobileno Nvarchar(10)
      
AS
BEGIN
      --INSERT
      IF @Statement = 'INSERT'
      BEGIN
	                IF Len(@CustomerName) >= 10 and (@CustomerName) NOT LIKE '%[^A-Z]%'and Len(@Mobileno) = 10 
					INSERT INTO Customer(RestaurantID,CustomerName,Mobileno)
					VALUES (@RestaurantID,@CustomerName,@Mobileno)
					ELSE
					PRINT 'CustomerName should have atleast 10 characters. And check no special character, no integer is used for customer name.
					 OR  MobileNo should be exactly of 10 digits.'
      END
 
      --UPDATE
      IF @Statement = 'UPDATE'	
      BEGIN
	  IF Len(@CustomerName) >= 10 and (@CustomerName) NOT LIKE '%[^A-Z]%'and Len(@Mobileno) = 10 
	  UPDATE Customer
            SET RestaurantID = @RestaurantID,CustomerName=@CustomerName,Mobileno=@Mobileno
            WHERE CustomerID = @CustomerID
			ELSE
			PRINT 'CustomerName should have atleast 10 characters. And check no special character, no integer is used for customer name.
					 OR  MobileNo should be exactly of 10 digits.'
      END
 
   --   DELETE
      IF @Statement = 'DELETE'
      BEGIN
            DELETE FROM Customer
            WHERE CustomerID = @CustomerID
      END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_DiningTableMaster]    Script Date: 14-09-2022 01:30:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_DiningTableMaster]
      @Statement VARCHAR(10),
	  @DiningTableID int,
	  @RestaurantID int,
      @Location Nvarchar(100)
      
AS
BEGIN
      --INSERT
      IF @Statement = 'INSERT'
      BEGIN
					INSERT INTO DiningTable(RestaurantID,Location)
					VALUES (@RestaurantID,@Location)
      END
 
      --UPDATE
      IF @Statement = 'UPDATE'	
      BEGIN
	  UPDATE DiningTable
            SET RestaurantID = @RestaurantID,Location=@Location
            WHERE DiningTableID = @DiningTableID
      END
 
   --   DELETE
      IF @Statement = 'DELETE'
      BEGIN
            DELETE FROM DiningTable
            WHERE DiningTableID = @DiningTableID
      END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetAllCustomers]    Script Date: 14-09-2022 01:30:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_GetAllCustomers] 
	@SortBy NVARCHAR(100),
	@Direction NVARCHAR(4),
	@FilterBy NVARCHAR(50),
	@FilterValue NVARCHAR(MAX)
AS
BEGIN
			SELECT Customer.CustomerID as 'CustomerID'
			  ,Customer.CustomerName as 'CustomerName'
			  ,Orders.OrderID as 'OrderID'
			  ,Orders.OrderDate as 'OrderDate'
			  ,Orders.OrderAmount as 'OrderAmount'
			  ,DiningTable.DiningTableID as 'DiningTableID'
			  ,DiningTable.[Location] as 'Location'
			FROM Customer
			LEFT JOIN Bills  ON Bills.CustomerID = Customer.CustomerID
			LEFT JOIN Orders  ON Orders.OrderID = Bills.OrderID
			LEFT JOIN DiningTable ON DiningTable.DiningTableID = Orders.DiningTableId
			WHERE     @FilterBy IS NULL OR @FilterBy = '' 
				  OR (@FilterBy = 'CustomerName' AND Customer.CustomerName = @FilterValue)
				  OR (@FilterBy = 'OrderDate' AND CAST(CAST(Convert(CHAR(8),Orders.OrderDate,112) as date) as nvarchar) = @FilterValue)
				  OR (@FilterBy = 'OrderAmount' AND CAST(Orders.OrderAmount as nvarchar) = @FilterValue)
				  OR (@FilterBy = 'DinningTable' AND DiningTable.[Location] = @FilterValue)
				  
			ORDER BY
					CASE WHEN @SortBy = 'CustomerName' AND @Direction = 'ASC'  THEN Customer.CustomerName END ASC,
					CASE WHEN @SortBy = 'CustomerName' AND @Direction = 'DESC'  THEN Customer.CustomerName END DESC,
					CASE WHEN @SortBy = 'OrderDate' AND @Direction = 'ASC'  THEN Orders.OrderDate END ASC,
					CASE WHEN @SortBy = 'OrderDate' AND @Direction = 'DESC'  THEN Orders.OrderDate END DESC,
					CASE WHEN @SortBy = 'OrderAmount' AND @Direction = 'ASC'  THEN Orders.OrderAmount END ASC,
					CASE WHEN @SortBy = 'OrderAmount' AND @Direction = 'DESC'  THEN Orders.OrderAmount END DESC,
					CASE WHEN @SortBy = 'DinningTable' AND @Direction = 'ASC'  THEN DiningTable.[Location] END ASC,
					CASE WHEN @SortBy = 'DinningTable' AND @Direction = 'DESC'  THEN DiningTable.[Location] END DESC	
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetOrderAmountByDayAndTable]    Script Date: 14-09-2022 01:30:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_GetOrderAmountByDayAndTable] 
	
AS
BEGIN
		SELECT CAST(o.OrderDate as date) as 'OrderDate'
			  ,dt.[Location]
			  ,sum(o.OrderAmount) as 'OrderAmount'
		FROM Orders o
		LEFT JOIN DiningTable dt ON dt.DiningTableID = o.DiningTableId

		GROUP BY CAST(o.OrderDate as date) ,dt.[Location]
		ORDER BY 'OrderDate' DESC
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetOrderAmountByRestaurantAndYear]    Script Date: 14-09-2022 01:30:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_GetOrderAmountByRestaurantAndYear] 
	
AS
BEGIN
		SELECT R.RestaurantID
			  ,R.RestaurantName	
			  ,YEAR(o.OrderDate) as 'Year'
			  ,sum(o.OrderAmount) as 'OrderAmount'
		FROM Restaurant R
		LEFT JOIN Bills B ON B.RestaurantID = R.RestaurantID
		LEFT JOIN Orders O ON O.OrderID = O.OrderID

		GROUP BY R.RestaurantID,R.RestaurantName,YEAR(o.OrderDate)
		ORDER BY 'Year' DESC
END
GO
/****** Object:  StoredProcedure [dbo].[USP_OrderMaster]    Script Date: 14-09-2022 01:30:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [dbo].[USP_OrderMaster]
      @Statement VARCHAR(10),
	  @OrderID int,
	  @OrderDate Datetime,
      @RestaurantID int,
	  @MenuITemID int,
	  @temQuantity int,
	  @OrderAmount Float,
	  @DiningTableId int
      
AS
BEGIN
	DECLARE @TableStatus nvarchar(100)
	DECLARE @InsertedId INT = 0
      --INSERT
      IF LOWER(@Statement) = 'insert'
      BEGIN
	        declare @itemprice float
			
			SET @TableStatus = (SELECT TOP(1)TableStatus from DiningTableTrack where DiningTableid=@DiningTableId)
	        SET @itemprice=dbo.ItemPrice(@MenuItemID)
	        
			IF @OrderDate= CAST( GETDATE() AS Date ) and @temQuantity>0 and @TableStatus='Vacant' 
				BEGIN		
						INSERT INTO Orders(OrderDate,RestaurantID,MenuITemID,ItemQuantity,OrderAmount,DiningTableId)
						VALUES (@OrderDate,@RestaurantID,@MenuITemID,@temQuantity,@temQuantity * @itemprice,@DiningTableId)
						SET @InsertedId = SCOPE_IDENTITY()
						SELECT @InsertedId
						IF(@InsertedId > 0)
						 BEGIN 
								UPDATE DiningTableTrack SET TableStatus = 'Occupied' WHERE DiningTableid=@DiningTableId
						 END
				END
			ELSE
				BEGIN 
					SELECT 'Table is not vacant'
				END
      END
 
      --UPDATE
      IF @Statement = 'UPDATE'	
      BEGIN
		DECLARE @OldDinningTableId INT = NULL
			-- check if order exists to update
			IF(SELECT TOP(1)OrderID FROM Orders WHERE OrderID = @OrderID) IS NOT NULL
			 BEGIN
				-- check if dinning table is changed or not
				IF ((SELECT TOP(1)DiningTableId FROM Orders WHERE OrderID = @OrderID) <> @DiningTableId)
				 BEGIN
					 -- if dinning table changed then new table is vacant or not
					 IF (LOWER((SELECT TOP(1)TableStatus from DiningTableTrack where DiningTableid=@DiningTableId)) = 'vacant')
						BEGIN
							SET @OldDinningTableId = (SELECT TOP(1)DiningTableId FROM Orders WHERE OrderID = @OrderID)
						END
					 ELSE
					    BEGIN
							PRINT'New Table is not vacant'
						END

				 END
					UPDATE Orders
						SET OrderDate = @OrderDate,RestaurantID=@RestaurantID,MenuITemID=@MenuITemID,ItemQuantity=@temQuantity,OrderAmount=@OrderAmount,DiningTableId=@DiningTableId
						WHERE OrderID = @OrderID

					IF(@OldDinningTableId IS NOT NULL)
					 BEGIN
							UPDATE DiningTableTrack SET TableStatus = 'Occupied' WHERE DiningTableid=@DiningTableId
							UPDATE DiningTableTrack SET TableStatus = 'Vacant' WHERE DiningTableid=@OldDinningTableId
					 END
			 END
			 ELSE 
			  BEGIN
				SELECT 'Order does not exists'
			  END
      END
 
   ----   DELETE
      IF @Statement = 'DELETE'
      BEGIN
	  -- check if order exists to update
			IF(SELECT TOP(1)OrderID FROM Orders WHERE OrderID = @OrderID) IS NOT NULL
			 BEGIN
					SET @DiningTableId = (SELECT TOP(1)DiningTableId FROM Orders WHERE OrderID = @OrderID)
					
					DELETE FROM Orders
					WHERE OrderID = @OrderID

					UPDATE DiningTableTrack SET TableStatus = 'Vacant' WHERE DiningTableid=@DiningTableId
			 END
			ELSE 
			  BEGIN
				SELECT 'Order does not exists'
			  END
      END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_RestaurantMenuItemMaster]    Script Date: 14-09-2022 01:30:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RestaurantMenuItemMaster]
      @Statement VARCHAR(10),
	  @MenuItemID int,
	  @CuisineID int,
      @ItemName Nvarchar(100),
      @ItemPrice Float
      
AS
BEGIN
      --INSERT
      IF @Statement = 'INSERT'
      BEGIN
				  IF @ItemPrice >0
					INSERT INTO RestaurantMenuItem(CuisineID,ItemName,ItemPrice)
					VALUES (@CuisineID,@ItemName,@ItemPrice)
				  ELSE
				  PRINT 'Item Price should be greater than 0'
      END
 
      --UPDATE
      IF @Statement = 'UPDATE'	
      BEGIN
	  UPDATE RestaurantMenuItem
            SET CuisineID = @CuisineID,ItemName=@ItemName,ItemPrice=@ItemPrice
            WHERE MenuItemID = @MenuItemID
      END
 
   --   DELETE
      IF @Statement = 'DELETE'
      BEGIN
            DELETE FROM RestaurantMenuItem
            WHERE MenuItemID = @MenuItemID
      END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_restmaster]    Script Date: 14-09-2022 01:30:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_restmaster]
      @Statement VARCHAR(10),
	  @RestaurantID int,
      @RestaurantName nvarchar(200),
      @Address nvarchar(200) ,
      @MobileNo nvarchar(10) 
AS
BEGIN
      --INSERT
      IF @Statement = 'INSERT'
      BEGIN
		  
	  IF not @MobileNo is Null and Len(@MobileNo) = 10 and ISNUMERIC(@MobileNo) = 1 and Len(@Address) > 10 and ISNUMERIC(SUBSTRING(@Address,1,1)) = 1
            INSERT INTO Restaurant(RestaurantName,Address,MobileNo)
            VALUES (@RestaurantName,@Address,@MobileNo)
	  ELSE
	     PRINT'Mobile no.should be 10  digit or Address should be atleast more than 10 characters and atleast 1st letter of the address column should be numeric only. '
      END
 
      --UPDATE
      IF @Statement = 'UPDATE'	
      BEGIN

	  IF not @MobileNo is Null and Len(@MobileNo) = 10 and ISNUMERIC(@MobileNo) = 1 and Len(@Address) > 10 and ISNUMERIC(SUBSTRING(@Address,1,1)) = 1
            UPDATE Restaurant
            SET RestaurantName = @RestaurantName, Address = @Address,MobileNo=@MobileNo
            WHERE RestaurantID = @RestaurantID
	  ELSE
	  	  PRINT'Mobile no.should be 10  digit or Address should be atleast more than 10 characters and atleast 1st letter of the address column should be numeric only. '

      END
 
      --DELETE
      IF @Statement = 'DELETE'
      BEGIN
            DELETE FROM Restaurant
            WHERE RestaurantID = @RestaurantID
      END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_VacantTables]    Script Date: 14-09-2022 01:30:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_VacantTables]
 	  @RestaurantID int
      AS
BEGIN
      SELECT	 dt.DiningTableID
					,dt.[Location],r.Restaurantname
			FROM DiningTable dt
			INNER  JOIN DiningTableTrack dtt  ON dtt.DiningTableID = dt.DiningTableID
			INNER JOIN Restaurant r ON r.RestaurantID = dt.RestaurantID
			WHERE dt.RestaurantID = @RestaurantId AND dtt.TableStatus = 'Vacant'

END



GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Cuisine"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 119
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RestaurantMenuItem"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 136
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'cusinewise item details'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'cusinewise item details'
GO
USE [master]
GO
ALTER DATABASE [RestaurantProject] SET  READ_WRITE 
GO

use Inv 



/****** Object:  Table [dbo].[tbCategories]    Script Date: 1/5/2022 12:21:37 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE [dbo].[tbUserDetails](
	[UserId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](200) NULL,
	[UserEmail] [nvarchar](100) NULL,
	[UserType] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbUserDetails] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbCategories](
	[CategoryId] [bigint] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](500) NULL,
	[CategoryDescription] [nvarchar](max) NULL,
 CONSTRAINT [PK_tbItemRegistry] PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbInventoryEntries](
	[InventoryId] [bigint] IDENTITY(1,1) NOT NULL,
	[CategoryId] [bigint] NULL,
	[SubCategoryId] [bigint] NULL,
	[InventoryName] [nvarchar](500) NULL,
	[InventoryDescription] [nvarchar](max) NULL,
	[PurchaseDate] [datetime] NULL,
	[PurchasedFrom] [nvarchar](max) NULL,
	[Bill_InvoiceNo] [nvarchar](100) NULL,
	[ItemQuantity] [int] NULL,
	[ItemRatePerUnit] [float] NULL,
	[ItemTotalCost] [float] NULL,
	[SalesTax] [float] NULL,
	[TotalAmount] [float] NULL,
	[IsConsumable] [bit] NULL,
	[Iswarranty] [bit] NULL,
	[WarrantyFrom] [datetime] NULL,
	[WarrantyTo] [datetime] NULL,
	[IsConvenorMarked] [bit] NULL,
	[ConvenorMarkedBy] [nvarchar](100) NULL,
	[ConvenorMarkedOn] [datetime] NULL,
	[CreatedBy] [nvarchar](100) NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](100) NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_tbInventoryEntries] PRIMARY KEY CLUSTERED 
(
	[InventoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[tbInventoryEntries]  WITH CHECK ADD  CONSTRAINT [FK_tbInventoryEntries_tbCategories] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[tbCategories] ([CategoryId])
GO

ALTER TABLE [dbo].[tbInventoryEntries] CHECK CONSTRAINT [FK_tbInventoryEntries_tbCategories]
GO

ALTER TABLE [dbo].[tbInventoryEntries]  WITH CHECK ADD  CONSTRAINT [FK_tbInventoryEntries_tbInventoryEntries] FOREIGN KEY([SubCategoryId])
REFERENCES [dbo].[tbSubCategory] ([SubCategoryId])
GO

ALTER TABLE [dbo].[tbInventoryEntries] CHECK CONSTRAINT [FK_tbInventoryEntries_tbInventoryEntries]
GO

CREATE TABLE [dbo].[tbIssueDetails](
	[IssueId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NULL,
	[IssueDate] [datetime] NULL,
	[IssuedBy] [bigint] NULL,
	[IssueQuantity] [int] NULL,
	[InventoryId] [bigint] NULL,
	[IsReceived] [bit] NULL,
	[IssuerRemarks] [nvarchar](max) NULL,
	[ReceiptRemarks] [nvarchar](max) NULL,
 CONSTRAINT [PK_tbIssueDetails] PRIMARY KEY CLUSTERED 
(
	[IssueId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbSubCategory](
	[SubCategoryId] [bigint] IDENTITY(1,1) NOT NULL,
	[SubCategoryName] [nvarchar](500) NULL,
	[CategoryDescription] [nvarchar](max) NULL,
	[CategoryId] [bigint] NULL,
 CONSTRAINT [PK_tbSubCategory] PRIMARY KEY CLUSTERED 
(
	[SubCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[tbSubCategory]  WITH CHECK ADD  CONSTRAINT [FK_tbSubCategory_tbCategories] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[tbCategories] ([CategoryId])
GO

ALTER TABLE [dbo].[tbSubCategory] CHECK CONSTRAINT [FK_tbSubCategory_tbCategories]
GO



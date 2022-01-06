USE [inv]
GO

/****** Object:  StoredProcedure [dbo].[spInventories]    Script Date: 1/5/2022 1:02:36 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 --delete from tbCategories
 --delete from tbSubCategory
 -- delete from tbInventoryEntries
 --delete from tbUserdetails
 --select * from tbInventoryEntries
 --select * from tbSubCategory
 --select * from tbCategories
 --select * from tbIssuedetails

alter PROCEDURE [dbo].[spInventories]  
(  
	@UserId  bigint = NULL,  
	@IssueId bigint = NULL,
	@UserName NVARCHAR(100) = NULL,
	@UserEmail NVARCHAR(100) = NULL,
	@UserType NVARCHAR(100) = NULL,
    @CategoryId INT = NULL,  
    @CategoryName VARCHAR(max) = NULL,  
    @CategoryDescription NVARCHAR(max) = NULL, 
	@SubCategoryId INT = NULL,  
    @SubCategoryName VARCHAR(max) = NULL,  
    @SubCategoryDescription NVARCHAR(max) = NULL, 
	@ItemCreatedBy NVARCHAR(100) = NULL, 
    @ItemCreatedOn datetime = NULL, 
	@ItemUpdatedBy NVARCHAR(100) = NULL, 
	@ItemUpdatedOn datetime = NULL, 
	@InventoryName Nvarchar(max)=null,
	@InventoryDescription	nvarchar(MAX)=null,
	@PurchaseDate	datetime=null,
	@PurchasedFrom	nvarchar(MAX)	=null,
	@Bill_InvoiceNo	nvarchar(100)	=null,
	@ItemQuantity	int	=null,
	@ItemRatePerUnit	float	=null,
	@ItemTotalCost	float	=null,
	@SalesTax	float	=null,
	@TotalAmount	float	=null,
	@IsConsumable	bit	=null,
	@Iswarranty	bit	=null,
	@WarrantyFrom	datetime	=null,
	@WarrantyTo	datetime	=null,
	@IsConvenorMarked	bit	=null,
	@ConvenorMarkedBy	nvarchar(100)	=null,
	@ConvenorMarkedOn	datetime	=null,
	@InventoryId INT = NULL,
	@InventoryCreatedBy NVARCHAR(100) = NULL, 
    @InventoryCreatedOn datetime = NULL, 
	@InventoryUpdatedBy NVARCHAR(100) = NULL, 
	@InventoryUpdatedOn datetime = NULL, 

	@IssueDate datetime	=null,
	@IssuedBy bigint = NULL,
	@IssueQuantity INT = NULL,
	@IsReceived bit	=null,
	@IssuerRemarks nvarchar(MAX)	=null,
	@ReceiptRemarks nvarchar(MAX)	=null,



	@ActionType NVARCHAR(25)
		)
AS  

BEGIN 
IF @ActionType = 'SaveUserDetails'  
    BEGIN  
        IF NOT EXISTS (SELECT * FROM tbUserDetails WHERE UserId=@UserId)  
        BEGIN  
            INSERT INTO tbUserDetails (UserName,UserEmail,UserType)  
            VALUES (@UserName,@UserEmail,@UserType)  
        END  
        ELSE  
        BEGIN  
            UPDATE tbUserDetails SET UserName=@UserName,UserEmail=@UserEmail, UserType=@UserType WHERE UserId=@UserId  
        END  
    END 
	 IF @ActionType = 'DeletUserDetails'  
    BEGIN  
        DELETE tbUserDetails WHERE UserId=@UserId  
    END  
    IF @ActionType = 'FetchUserDetails'  
    BEGIN  
        Select UserId,UserName, UserEmail, UserType from tbUserDetails
		    END 
IF @ActionType = 'SaveCategory'  
    BEGIN  
        IF NOT EXISTS (SELECT * FROM tbCategories WHERE CategoryId=@CategoryId)  
        BEGIN  
		INSERT INTO [tbCategories] ([CategoryName], [CategoryDescription]) VALUES (@CategoryName,@CategoryDescription)
        END  
        ELSE  
        BEGIN  	
           UPDATE tbCategories SET CategoryName=@CategoryName,CategoryDescription=@CategoryDescription WHERE CategoryId=@CategoryId  
        END  
    END 

	


	IF @ActionType = 'SaveCateNSubCat'  
    BEGIN  
        IF NOT EXISTS (SELECT * FROM tbCategories WHERE CategoryId=@CategoryId)  
        BEGIN  
            BEGIN TRANSACTION;
					DECLARE @id [bigint]=null;
					INSERT INTO [tbCategories] ([CategoryName], [CategoryDescription]) VALUES (@CategoryName,@CategoryDescription)
					SELECT @id = SCOPE_IDENTITY();
					INSERT INTO [tbSubCategory] ( [CategoryId],[SubCategoryName],[SubCategoryDescription]) 
					VALUES (@id, @SubCategoryName,@SubCategoryDescription);
			COMMIT TRANSACTION;
        END  
        ELSE  
        BEGIN  
            UPDATE tbCategories SET CategoryName=@CategoryName,CategoryDescription=@CategoryDescription WHERE CategoryId=@CategoryId  
        END  
    END 
	 IF @ActionType = 'DeletCategory'  
    BEGIN  
        DELETE tbCategories WHERE CategoryId=@CategoryId  
    END  
    IF @ActionType = 'FetchCategories'  
		BEGIN  
			Select CategoryId,CategoryName,CategoryDescription from tbCategories
		END 
	IF @ActionType = 'FetchSubCategories'  
		BEGIN  
			Select CategoryName,CategoryDescription, SubCategoryName, SubCategoryDescription, SubCategoryId from
			tbSubCategory sc inner  join tbCategories c on sc.CategoryId = c.CategoryId where sc.CategoryId=@CategoryId
		END 
	IF @ActionType = 'SaveInventoryEntries'  
    BEGIN  
        IF NOT EXISTS (SELECT * FROM tbInventoryEntries WHERE InventoryId=@InventoryId)  
        BEGIN  
            INSERT INTO tbInventoryEntries 
			(
			CategoryId,
			InventoryName,
			InventoryDescription,
			PurchaseDate,
			PurchasedFrom,
			Bill_InvoiceNo,
			ItemQuantity,
			ItemRatePerUnit,
			ItemTotalCost,
			SalesTax,
			TotalAmount,
			IsConsumable,
			Iswarranty,
			WarrantyFrom,
			WarrantyTo,
			IsConvenorMarked,
			ConvenorMarkedBy,
			ConvenorMarkedOn,			
			CreatedBy,
			CreatedOn,
			UpdatedBy,
			UpdatedOn)  
            VALUES (
			@CategoryId,
			@InventoryName,
			@InventoryDescription,
			@PurchaseDate,
			@PurchasedFrom,
			@Bill_InvoiceNo,
			@ItemQuantity,
			@ItemRatePerUnit,
			@ItemTotalCost,
			@SalesTax,
			@TotalAmount,
			@IsConsumable,
			@Iswarranty,
			@WarrantyFrom,
			@WarrantyTo,
			@IsConvenorMarked,
			@ConvenorMarkedBy,
			@ConvenorMarkedOn,			
			@InventoryCreatedBy,
			@InventoryCreatedOn,
			@InventoryUpdatedBy,
			@InventoryUpdatedOn)  
        END  
        ELSE  
        BEGIN  
            UPDATE tbInventoryEntries SET 
			CategoryId=@CategoryId,
			InventoryName=@InventoryName,
			InventoryDescription=@InventoryDescription,
			PurchaseDate=@PurchaseDate,
			PurchasedFrom=@PurchasedFrom,
			Bill_InvoiceNo=@Bill_InvoiceNo,
			ItemQuantity=@ItemQuantity,
			ItemRatePerUnit=@ItemRatePerUnit,
			ItemTotalCost=@ItemTotalCost,
			SalesTax=@SalesTax,
			TotalAmount=@TotalAmount,
			IsConsumable=@IsConsumable,
			Iswarranty=@Iswarranty,
			WarrantyFrom=@WarrantyFrom,
			WarrantyTo=@WarrantyTo,
			IsConvenorMarked=@IsConvenorMarked,
			ConvenorMarkedBy=@ConvenorMarkedBy,
			ConvenorMarkedOn=@ConvenorMarkedOn,
			CreatedBy=@InventoryCreatedBy,  
            CreatedOn=@InventoryCreatedOn,
			UpdatedBy=@InventoryUpdatedBy,
			UpdatedOn=@InventoryUpdatedOn
			WHERE InventoryId=@InventoryId  
        END  
    END
	 IF @ActionType = 'DeletInventoryEntries'  
    BEGIN  
        DELETE tbInventoryEntries WHERE CategoryId=@CategoryId  
    END  
    IF @ActionType = 'FetchInventoryEntries'  
		BEGIN  
			SELECT	* FROM	tbInventoryEntries 
			SELECT * FROM tbCategories
		END
	IF @ActionType = 'FetchInventoryForGrid'  
		BEGIN  
			SELECT	InventoryId, c.CategoryName,  InventoryName, InventoryDescription, 
					PurchasedFrom, 	PurchaseDate, Bill_InvoiceNo, 
					ItemQuantity, ItemRatePerUnit, 
					CreatedBy, CreatedOn, UpdatedBy, UpdatedOn
			FROM	tbInventoryEntries i, tbCategories c
			where	i.CategoryId = c.CategoryId
		END
	IF @ActionType = 'FetchSubCatsByCatId'  
		BEGIN  
			SELECT * FROM tbSubCategory where CategoryId=@CategoryId
		END 

			    IF @ActionType = 'FetchIssueDetails'  
    BEGIN  
        Select * from tbIssuedetails
		    END 
IF @ActionType = 'SaveIssueDetails'  
    BEGIN  
        IF NOT EXISTS (SELECT * FROM tbIssuedetails WHERE IssueId=@IssueId)  
        BEGIN  
		INSERT INTO tbIssuedetails (UserId,	IssueDate, IssuedBy, IssueQuantity, InventoryId, IsReceived, IssuerRemarks,	ReceiptRemarks) 
		VALUES (@UserId,	@IssueDate, @IssuedBy, @IssueQuantity, @InventoryId, @IsReceived, @IssuerRemarks,	@ReceiptRemarks)
        END  
        ELSE  
        BEGIN  	
           UPDATE tbIssuedetails SET UserId=@UserId,	IssueDate=@IssueDate, IssuedBy=@IssuedBy, IssueQuantity=@IssueQuantity, InventoryId=@InventoryId, 
		   IsReceived=@IsReceived, IssuerRemarks=@IssuerRemarks,	ReceiptRemarks=@ReceiptRemarks WHERE IssueId=@IssueId  
        END  
    END 


	
END
GO



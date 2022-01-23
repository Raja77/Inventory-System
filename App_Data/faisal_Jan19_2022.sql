Use INV
GO
  
  
ALTER TABLE [tbUserDetails]
ADD IssuerName nvarchar(200),
[password] nvarchar(50),
IsActive bit;

ALTER TABLE [tbUserDetails]
ADD Constraint unq_userDetails_UserName unique(UserName);

ALTER TABLE [tbUserDetails]
Alter column UserName nvarchar(100);

--select * from tbuserDetails where (UserEmail='Admin' or  UserName='Admin') and Password ='admin@123'
 delete  from [tbUserDetails]
  
  Declare @XmlData XML='<ROOT>
  <UserDetails UserName="Admin" UserEmail="admin@gmail.com" UserType="SuperAdmin" IssuerName="NA" Password="admin@123" IsActive="1"/>
  <UserDetails UserName="Data Entry Operator 1" UserEmail="deo1@gmail.com" UserType="DEO1" IssuerName="NA" Password="deo1@123" IsActive="1"/>
  <UserDetails UserName="Data Entry Operator 2" UserEmail="deo2@gmail.com" UserType="DEO2" IssuerName="NA" Password="deo2@123" IsActive="1"/>
  </ROOT>'

  INSERT INTO [tbUserDetails] ([UserName],[UserEmail],[UserType],[IssuerName],[password],[Isactive])           
   SELECT  p.value('@UserName','NVARCHAR(100)'),  
    p.value('@UserEmail','NVARCHAR(100)'),
	p.value('@UserType','NVARCHAR(50)'),
	p.value('@IssuerName','NVARCHAR(200)'),  
    p.value('@Password','NVARCHAR(50)'),
	p.value('@IsActive','bit')
	FROM @XmlData.nodes('/ROOT/UserDetails')n(p)
	select * from [tbUserDetails]




	SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 --delete from tbCategories
 --delete from tbSubCategory
 -- delete from tbInventoryEntries
 ----delete from tbUserdetails
 --select * from tbInventoryEntries
 --select * from tbSubCategory
 --select * from tbCategories
 --select * from tbIssuedetails

ALTER PROCEDURE [dbo].[spInventories]  
(  


				@IssueId bigint = NULL,
    @CategoryId INT = NULL,  
    @CategoryName VARCHAR(max) = NULL,  
    @CategoryDescription NVARCHAR(max) = NULL, 
	@SubCategoryId INT = NULL,  
    @SubCategoryName NVARCHAR(200) = NULL,           
    @SubCategoryDescription NVARCHAR(max) = NULL, 
	@ItemCreatedBy NVARCHAR(100) = NULL, 
    @ItemCreatedOn datetime = NULL, 
	@ItemUpdatedBy NVARCHAR(100) = NULL, 
	@ItemUpdatedOn datetime = NULL, 
	@InventoryName Nvarchar(max)=null,
	@InventoryDescription	nvarchar(MAX)=null,
	@InventoryDescription1	nvarchar(MAX)=null,
	@InventoryDescription2	nvarchar(MAX)=null,
	@InventoryDescription3	nvarchar(MAX)=null,
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
	@InventoryRegisterNo NVARCHAR(100)=NULL,
	@InventoryPageNo bigint=NULL,

	--User Details
	@UserId  bigint = NULL,  	
	@UserName NVARCHAR(100) = NULL,
	@UserEmail NVARCHAR(100) = NULL,
	@UserType NVARCHAR(50) = NULL,
	@UserPassword NVARCHAR(50) = NULL,
    @IssuerName NVARCHAR(200) = NULL,
    @IsActive BIT = NULL,
	
	--Issue Details
	@IssueDate datetime	=null,
	@IssuedBy bigint = NULL,
	@IssueQuantity INT = NULL,
	@IsReceived bit	=null,
	@IssuerRemarks nvarchar(MAX)	=null,
	@ReceiptRemarks nvarchar(MAX)	=null,

	@CommentId  bigint = NULL,  
	@CommentCreatorName NVARCHAR(100) = NULL,
	@CommentSubject NVARCHAR(100) = NULL,
	@CommentDescription NVARCHAR(max) = NULL,
	@CommentPageName NVARCHAR(100) = NULL,
	@CommentCreatedOn datetime = NULL, 
	@CommentReplierName NVARCHAR(100) = NULL,
	@CommentReply NVARCHAR(max) = NULL,
	@CommentRepliedOn datetime = NULL, 

	@XmlData XML=null,

	@ActionType NVARCHAR(25),
	@SubActionType NVARCHAR(25)=null
		)
AS  

BEGIN 
IF @ActionType = 'SaveUserDetails'  
    BEGIN  
        IF NOT EXISTS (SELECT * FROM tbUserDetails WHERE UserId=@UserId)  
        BEGIN  
            INSERT INTO tbUserDetails (UserName,UserEmail,UserType,[Password],IssuerName,IsActive)  
            VALUES (@UserName,@UserEmail,@UserType,@UserPassword,@IssuerName,@IsActive)  
        END  
        ELSE  
        BEGIN  
            UPDATE tbUserDetails SET UserName=@UserName,UserEmail=@UserEmail, UserType=@UserType, [Password]=@UserPassword,IssuerName=@IssuerName,
			IsActive=@IsActive WHERE UserId=@UserId  
        END  
    END 
	 IF @ActionType = 'DeletUserDetails'  
    BEGIN  
        DELETE tbUserDetails WHERE UserId=@UserId  
    END  
    IF @ActionType = 'FetchUserDetails'  
    BEGIN  
        Select * from tbUserDetails where IsActive<>1
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

	IF @ActionType = 'SaveSubCategory'  
    BEGIN  
        IF NOT EXISTS (SELECT * FROM tbSubCategory WHERE SubCategoryName=@SubCategoryName and CategoryId=@CategoryId)  
			BEGIN 
				IF @SubActionType = 'Update' OR @SubActionType='Insert'
					BEGIN
						INSERT INTO [tbSubCategory] ([SubCategoryName], [SubCategoryDescription],[CategoryId]) 
						VALUES (@SubCategoryName,@SubCategoryDescription,@CategoryId)
					END  
				ELSE  
					BEGIN  	
						UPDATE tbSubCategory SET SubCategoryName=@SubCategoryName,SubCategoryDescription=@SubCategoryDescription WHERE SubCategoryId=@SubCategoryId  
					END  
			END
		END

	IF @ActionType = 'SaveUpdSubCat'  
    BEGIN  
		IF @SubActionType='Insert'
			BEGIN
				INSERT INTO [tbSubCategory] ([SubCategoryName], [SubCategoryDescription],[CategoryId]) 
				VALUES (@SubCategoryName,@SubCategoryDescription,@CategoryId)
			END  
        ELSE  IF @SubActionType='Update'
			BEGIN  	
			   UPDATE tbSubCategory SET SubCategoryName=@SubCategoryName,SubCategoryDescription=@SubCategoryDescription 
			   WHERE SubCategoryId=@SubCategoryId  
			END  
    END

	IF @ActionType = 'SaveCateNSubCat'  
    BEGIN  
	--SET IDENTITY_INSERT tbSubCategory ON
        IF NOT EXISTS (SELECT * FROM tbCategories WHERE CategoryId=@CategoryId)  
        BEGIN  
            BEGIN TRANSACTION;
					DECLARE @id [bigint]=null;
					INSERT INTO [tbCategories] ([CategoryName], [CategoryDescription]) VALUES (@CategoryName,@CategoryDescription)
					SELECT @id = SCOPE_IDENTITY();
					--INSERT INTO [tbSubCategory] ( [CategoryId],[SubCategoryName],[SubCategoryDescription]) 
					--VALUES (@id, @SubCategoryName,@SubCategoryDescription);

						INSERT INTO [tbSubCategory] (CategoryId,[SubCategoryName],[SubCategoryDescription])           
   SELECT  @id, p.value('@SubCategoryName','NVARCHAR(200)'),  
    p.value('@SubCategoryDescription','NVARCHAR(MAX)')  FROM @XmlData.nodes('/ROOT/SubCategory')n(p);
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
			Select c.CategoryId,CategoryName,CategoryDescription, SubCategoryName, SubCategoryDescription, SubCategoryId from
			tbSubCategory sc inner  join tbCategories c on sc.CategoryId = c.CategoryId where sc.CategoryId=@CategoryId
		END 
		IF @ActionType = 'DeleteSubCategory'  
    BEGIN  
        IF EXISTS (SELECT * FROM tbSubCategory WHERE SubCategoryId=@SubCategoryId)  
        BEGIN  
		DELETE FROM tbSubCategory WHERE SubCategoryId=@SubCategoryId 
        END  
    END 

		IF @ActionType = 'SaveIEandIssue_x'
		   BEGIN  
            BEGIN TRANSACTION;
					DECLARE @invId [bigint]=null;
					INSERT INTO [tbInventoryEntries]
					(
					CategoryId,
					SubCategoryId,
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
					VALUES 
					(@CategoryId,
					@SubCategoryId,
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
					SELECT @invId = SCOPE_IDENTITY();
					INSERT INTO tbIssuedetails (UserId,	IssueDate, IssuedBy, IssueQuantity, InventoryId, IsReceived, IssuerRemarks,	ReceiptRemarks) 
					VALUES (@UserId, @IssueDate, @IssuedBy, @IssueQuantity, @invId, @IsReceived, @IssuerRemarks,	@ReceiptRemarks);
			COMMIT TRANSACTION;
        END

IF @ActionType = 'SaveIEandIssue'  
    BEGIN  
	--SET IDENTITY_INSERT tbSubCategory ON
        IF NOT EXISTS (SELECT * FROM tbInventoryEntries WHERE InventoryId=@InventoryId)  
        BEGIN  
            BEGIN TRANSACTION;
					DECLARE @invnId [bigint]=null;
					
					INSERT INTO [tbInventoryEntries]
					(
					CategoryId,
					SubCategoryId,
					InventoryName,
					InventoryDescription1,
					InventoryDescription2,
					InventoryDescription3,
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
					UpdatedOn,
					InventoryRegisterNo,
					InventoryPageNo) 
					VALUES 
					(@CategoryId,
					@SubCategoryId,
					@InventoryName,
					@InventoryDescription1,
					@InventoryDescription2,
					@InventoryDescription3,
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
					@InventoryUpdatedOn,
					@InventoryRegisterNo,
					@InventoryPageNo)
					
					SELECT @invnId = SCOPE_IDENTITY();
					
					INSERT INTO [tbIssueDetails] 
						(InventoryId, [UserId],[IssueDate],[IssuedBy],[IssueQuantity],[IsReceived],[IssuerRemarks],[ReceiptRemarks])           
						SELECT  @invnId, 
								p.value('@UserId','BIGINT'),  
								p.value('@IssueDate','DATETIME') ,
								p.value('@IssuedBy','BIGINT') ,
								p.value('@IssueQuantity','INT') ,
								p.value('@IsReceived','BIT') ,
								p.value('@IssuerRemarks','NVARCHAR(MAX)') ,
								p.value('@ReceiptRemarks','NVARCHAR(MAX)') 
								FROM @XmlData.nodes('/ROOT/IssueDetails')n(p);
			COMMIT TRANSACTION;
        END  
        ELSE  
        BEGIN  
            UPDATE tbInventoryEntries SET CategoryId=@CategoryId,
					SubCategoryId=@SubCategoryId,
					InventoryName=@InventoryName,
					InventoryDescription1=@InventoryDescription1,
					InventoryDescription2=@InventoryDescription2,
					InventoryDescription3=@InventoryDescription3,
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
					UpdatedOn=@InventoryUpdatedOn,
					InventoryRegisterNo=@InventoryRegisterNo,
					InventoryPageNo=@InventoryPageNo
					WHERE InventoryId=@InventoryId
        END  
    END 

	
	IF @ActionType = 'SaveInventoryEntries'  
    BEGIN  
        IF NOT EXISTS (SELECT * FROM tbInventoryEntries WHERE InventoryId=@InventoryId)  
        BEGIN  
            INSERT INTO tbInventoryEntries 
			(
			CategoryId,
			InventoryName,
			InventoryDescription1,
			InventoryDescription2,
			InventoryDescription3,
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
			UpdatedOn,
			InventoryRegisterNo,
			InventoryPageNo)  
            VALUES (
			@CategoryId,
			@InventoryName,
			@InventoryDescription1,
			@InventoryDescription2,
			@InventoryDescription3,
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
			@InventoryUpdatedOn,
			@InventoryRegisterNo,
			@InventoryPageNo)  
        END  
        ELSE  
        BEGIN  
            UPDATE tbInventoryEntries SET 
			CategoryId=@CategoryId,
			InventoryName=@InventoryName,
			InventoryDescription1=@InventoryDescription1,
			InventoryDescription2=@InventoryDescription2,
			InventoryDescription3=@InventoryDescription3,
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
			UpdatedBy=@InventoryUpdatedBy,
			UpdatedOn=@InventoryUpdatedOn,
			InventoryRegisterNo=@InventoryRegisterNo,
			InventoryPageNo=@InventoryPageNo
			WHERE InventoryId=@InventoryId  
        END  
    END
	 IF @ActionType = 'DeletInventoryEntries'  
    BEGIN  
        DELETE tbInventoryEntries WHERE CategoryId=@CategoryId  
    END  
    IF @ActionType = 'FetchInventoryEntries'  
		BEGIN  
			SELECT	InventoryId, InventoryName, c.CategoryId, CategoryName, 
					InventoryDescription,  InventoryDescription1, InventoryDescription2, InventoryDescription3,
					PurchasedFrom, 	PurchaseDate, Bill_InvoiceNo, ItemTotalCost, TotalAmount,
					ItemQuantity, ItemRatePerUnit ,IsConsumable , SalesTax, WarrantyTo, 
					InventoryRegisterNo, InventoryPageNo
					FROM	tbInventoryEntries i inner join 
					tbCategories c on c.CategoryId = i.CategoryId
			SELECT * FROM tbCategories
			Select UserId, IssuerName from tbUserDetails where IsActive<>1
		END
	IF @ActionType = 'FetchInventoryForGrid'  
		BEGIN  
			SELECT	InventoryId, InventoryName, CategoryName,
					InventoryDescription,  InventoryDescription1, InventoryDescription2, InventoryDescription3,
					PurchasedFrom, 	PurchaseDate, Bill_InvoiceNo, 
					ItemQuantity, ItemRatePerUnit ,IsConsumable , InventoryRegisterNo, InventoryPageNo
					FROM	tbInventoryEntries i inner join 
					tbCategories c on c.CategoryId = i.CategoryId
					--CreatedBy, CreatedOn, UpdatedBy, UpdatedOn
			--FROM	tbInventoryEntries i, tbCategories c
			--where	i.CategoryId = c.CategoryId

			Select * from tbCategories c inner  join tbSubCategory sc on sc.CategoryId = c.CategoryId-- where sc.CategoryId=@CategoryId

			 Select UserId, IssuerName from tbUserDetails where IsActive<>1
		END
	IF @ActionType = 'FetchSubCatsByCatId'  
		BEGIN  
			SELECT * FROM tbSubCategory where CategoryId=@CategoryId
		END 
	IF @ActionType = 'FetchIssueByInvId'  
    BEGIN  
        Select * from tbIssuedetails i inner join tbUserDetails u on i.UserId=u.UserId  where i.InventoryId=@InventoryId
		    END 
	IF @ActionType = 'FetchIssueDetails'  
    BEGIN  
		Select* from tbIssuedetails i inner join tbUserDetails u on i.UserId=u.UserId WHERE InventoryId=@InventoryId
		Select UserId, IssuerName from tbUserDetails where IsActive<>1
		SELECT DISTINCT InventoryRegisterNo from tbInventoryEntries ORDER BY InventoryRegisterNo
		SELECT DISTINCT InventoryPageNo from tbInventoryEntries WHERE InventoryRegisterNo=@InventoryRegisterNo ORDER BY InventoryPageNo
		SELECT InventoryId, InventoryName from tbInventoryEntries WHERE InventoryRegisterNo=@InventoryRegisterNo AND InventoryPageNo=@InventoryPageNo
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
IF @ActionType = 'DeleteIssueDetails'  
    BEGIN  
        IF EXISTS (SELECT * FROM tbIssuedetails WHERE IssueId=@IssueId)  
        BEGIN  
		DELETE FROM tbIssuedetails WHERE IssueId = @IssueId
        END  
    END 

		IF @ActionType = 'SaveCommentDetails'  
    BEGIN  
        IF NOT EXISTS (SELECT * FROM tbComments WHERE CommentId=@CommentId)  
        BEGIN  
            INSERT INTO tbComments(CommentCreatorName,CommentSubject,CommentDescription,CommentPageName,CommentCreatedOn)  
            VALUES (@CommentCreatorName,@CommentSubject,@CommentDescription,@CommentPageName,@CommentCreatedOn)  
        END  
        ELSE  
        BEGIN  
            UPDATE tbComments SET CommentReplierName=@CommentReplierName,CommentReply=@CommentReply, 
			CommentRepliedOn=@CommentRepliedOn WHERE CommentId=@CommentId 
        END  
    END 
    IF @ActionType = 'FetchCommentDetails'  
    BEGIN  
        Select * from tbComments order by CommentCreatedOn desc
	END
	IF @ActionType = 'FetchPageComments'  
    BEGIN  
        Select * from tbComments 
		where CommentPageName=@CommentPageName
		order by CommentCreatedOn desc
	END 
	
END
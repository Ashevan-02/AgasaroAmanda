-- Stored Procedures for write operations and reporting
USE GearInventory;
GO

-- Upsert Branch
IF OBJECT_ID('dbo.sp_Branch_Upsert','P') IS NOT NULL DROP PROCEDURE dbo.sp_Branch_Upsert;
GO
CREATE PROCEDURE dbo.sp_Branch_Upsert
  @BranchId INT = NULL OUTPUT,
  @BranchCode NVARCHAR(20),
  @BranchName NVARCHAR(100),
  @AddressLine1 NVARCHAR(200) = NULL,
  @AddressLine2 NVARCHAR(200) = NULL,
  @City NVARCHAR(100) = NULL,
  @StateProvince NVARCHAR(100) = NULL,
  @PostalCode NVARCHAR(20) = NULL,
  @Country NVARCHAR(100) = NULL,
  @IsActive BIT = 1
AS
BEGIN
  SET NOCOUNT ON;
  IF @BranchId IS NULL
  BEGIN
    INSERT INTO dbo.Branch (BranchCode, BranchName, AddressLine1, AddressLine2, City, StateProvince, PostalCode, Country, IsActive)
    VALUES (@BranchCode, @BranchName, @AddressLine1, @AddressLine2, @City, @StateProvince, @PostalCode, @Country, @IsActive);
    SET @BranchId = SCOPE_IDENTITY();
  END
  ELSE
  BEGIN
    UPDATE dbo.Branch SET
      BranchCode = @BranchCode,
      BranchName = @BranchName,
      AddressLine1 = @AddressLine1,
      AddressLine2 = @AddressLine2,
      City = @City,
      StateProvince = @StateProvince,
      PostalCode = @PostalCode,
      Country = @Country,
      IsActive = @IsActive,
      UpdatedAt = SYSUTCDATETIME()
    WHERE BranchId = @BranchId;
  END
END
GO

-- Upsert Supplier
IF OBJECT_ID('dbo.sp_Supplier_Upsert','P') IS NOT NULL DROP PROCEDURE dbo.sp_Supplier_Upsert;
GO
CREATE PROCEDURE dbo.sp_Supplier_Upsert
  @SupplierId INT = NULL OUTPUT,
  @SupplierCode NVARCHAR(30),
  @SupplierName NVARCHAR(150),
  @ContactName NVARCHAR(100) = NULL,
  @Phone NVARCHAR(50) = NULL,
  @Email NVARCHAR(150) = NULL,
  @Address NVARCHAR(300) = NULL,
  @IsActive BIT = 1
AS
BEGIN
  SET NOCOUNT ON;
  IF @SupplierId IS NULL
  BEGIN
    INSERT INTO dbo.Supplier (SupplierCode, SupplierName, ContactName, Phone, Email, Address, IsActive)
    VALUES (@SupplierCode, @SupplierName, @ContactName, @Phone, @Email, @Address, @IsActive);
    SET @SupplierId = SCOPE_IDENTITY();
  END
  ELSE
  BEGIN
    UPDATE dbo.Supplier SET
      SupplierCode = @SupplierCode,
      SupplierName = @SupplierName,
      ContactName = @ContactName,
      Phone = @Phone,
      Email = @Email,
      Address = @Address,
      IsActive = @IsActive,
      UpdatedAt = SYSUTCDATETIME()
    WHERE SupplierId = @SupplierId;
  END
END
GO

-- Upsert Category
IF OBJECT_ID('dbo.sp_Category_Upsert','P') IS NOT NULL DROP PROCEDURE dbo.sp_Category_Upsert;
GO
CREATE PROCEDURE dbo.sp_Category_Upsert
  @CategoryId INT = NULL OUTPUT,
  @ParentCategoryId INT = NULL,
  @CategoryCode NVARCHAR(30),
  @CategoryName NVARCHAR(150),
  @IsActive BIT = 1
AS
BEGIN
  SET NOCOUNT ON;
  IF @CategoryId IS NULL
  BEGIN
    INSERT INTO dbo.Category (ParentCategoryId, CategoryCode, CategoryName, IsActive)
    VALUES (@ParentCategoryId, @CategoryCode, @CategoryName, @IsActive);
    SET @CategoryId = SCOPE_IDENTITY();
  END
  ELSE
  BEGIN
    UPDATE dbo.Category SET
      ParentCategoryId = @ParentCategoryId,
      CategoryCode = @CategoryCode,
      CategoryName = @CategoryName,
      IsActive = @IsActive,
      UpdatedAt = SYSUTCDATETIME()
    WHERE CategoryId = @CategoryId;
  END
END
GO

-- Upsert Gear
IF OBJECT_ID('dbo.sp_Gear_Upsert','P') IS NOT NULL DROP PROCEDURE dbo.sp_Gear_Upsert;
GO
CREATE PROCEDURE dbo.sp_Gear_Upsert
  @GearId INT = NULL OUTPUT,
  @SKU NVARCHAR(50),
  @GearName NVARCHAR(200),
  @CategoryId INT,
  @UnitOfMeasure NVARCHAR(20),
  @ReorderLevel DECIMAL(18,2) = 0,
  @IsActive BIT = 1
AS
BEGIN
  SET NOCOUNT ON;
  IF @GearId IS NULL
  BEGIN
    INSERT INTO dbo.Gear (SKU, GearName, CategoryId, UnitOfMeasure, ReorderLevel, IsActive)
    VALUES (@SKU, @GearName, @CategoryId, @UnitOfMeasure, @ReorderLevel, @IsActive);
    SET @GearId = SCOPE_IDENTITY();
  END
  ELSE
  BEGIN
    UPDATE dbo.Gear SET
      SKU = @SKU,
      GearName = @GearName,
      CategoryId = @CategoryId,
      UnitOfMeasure = @UnitOfMeasure,
      ReorderLevel = @ReorderLevel,
      IsActive = @IsActive,
      UpdatedAt = SYSUTCDATETIME()
    WHERE GearId = @GearId;
  END
END
GO

-- Authentication helpers
IF OBJECT_ID('dbo.sp_User_Create','P') IS NOT NULL DROP PROCEDURE dbo.sp_User_Create;
GO
CREATE PROCEDURE dbo.sp_User_Create
  @Username NVARCHAR(100),
  @PasswordHash VARBINARY(256),
  @PasswordSalt VARBINARY(128),
  @DisplayName NVARCHAR(150),
  @UserId INT = NULL OUTPUT
AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO dbo.[User](Username, PasswordHash, PasswordSalt, DisplayName)
  VALUES (@Username, @PasswordHash, @PasswordSalt, @DisplayName);
  SET @UserId = SCOPE_IDENTITY();
END
GO

IF OBJECT_ID('dbo.sp_User_AssignRole','P') IS NOT NULL DROP PROCEDURE dbo.sp_User_AssignRole;
GO
CREATE PROCEDURE dbo.sp_User_AssignRole
  @UserId INT,
  @RoleName NVARCHAR(50)
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @RoleId INT;
  SELECT @RoleId = RoleId FROM dbo.[Role] WHERE RoleName = @RoleName;
  IF @RoleId IS NULL
  BEGIN
    INSERT INTO dbo.[Role](RoleName) VALUES(@RoleName);
    SET @RoleId = SCOPE_IDENTITY();
  END
  IF NOT EXISTS (SELECT 1 FROM dbo.UserRole WHERE UserId = @UserId AND RoleId = @RoleId)
  BEGIN
    INSERT INTO dbo.UserRole(UserId, RoleId) VALUES (@UserId, @RoleId);
  END
END
GO

-- Stock intake (I) with moving average update
IF OBJECT_ID('dbo.sp_Stock_Intake','P') IS NOT NULL DROP PROCEDURE dbo.sp_Stock_Intake;
GO
CREATE PROCEDURE dbo.sp_Stock_Intake
  @BranchId INT,
  @CreatedBy INT,
  @Lines dbo.TVP_TransactionLine READONLY
AS
BEGIN
  SET NOCOUNT ON;
  IF dbo.fn_UserHasRole(@CreatedBy,'InventoryClerk') = 0 AND dbo.fn_UserHasRole(@CreatedBy,'Admin') = 0
  BEGIN
    RAISERROR('User not allowed to intake stock', 16, 1);
    RETURN;
  END

  BEGIN TRAN;
  BEGIN TRY
    DECLARE @Now DATETIME2 = SYSUTCDATETIME();

    DECLARE line_cur CURSOR LOCAL FAST_FORWARD FOR
      SELECT GearId, Quantity, UnitCost, SupplierId, ReferenceNo, Notes FROM @Lines;

    DECLARE @GearId INT, @Qty DECIMAL(18,2), @Cost DECIMAL(18,4), @SupplierId INT, @Ref NVARCHAR(100), @Notes NVARCHAR(500);

    OPEN line_cur;
    FETCH NEXT FROM line_cur INTO @GearId, @Qty, @Cost, @SupplierId, @Ref, @Notes;
    WHILE @@FETCH_STATUS = 0
    BEGIN
      IF @Qty <= 0 OR @Cost IS NULL OR @Cost < 0
        RAISERROR('Invalid quantity or unit cost for intake',16,1);

      -- Insert transaction row
      INSERT INTO dbo.InventoryTransaction(BranchId, GearId, TransactionType, Quantity, UnitCost, SupplierId, ReferenceNo, Notes, CreatedBy, CreatedAt)
      VALUES (@BranchId, @GearId, 'I', @Qty, @Cost, @SupplierId, @Ref, @Notes, @CreatedBy, @Now);

      -- Update inventory qty
      MERGE dbo.BranchInventory AS tgt
      USING (SELECT @BranchId AS BranchId, @GearId AS GearId) AS src
      ON (tgt.BranchId = src.BranchId AND tgt.GearId = src.GearId)
      WHEN MATCHED THEN UPDATE SET Quantity = tgt.Quantity + @Qty
      WHEN NOT MATCHED THEN INSERT(BranchId, GearId, Quantity) VALUES(@BranchId, @GearId, @Qty);

      -- Update moving average cost
      DECLARE @OldQty DECIMAL(18,2) = ISNULL((SELECT Quantity FROM dbo.BranchInventory WHERE BranchId=@BranchId AND GearId=@GearId),0);
      DECLARE @OldAvg DECIMAL(18,4) = ISNULL((SELECT AvgUnitCost FROM dbo.BranchGearValuation WHERE BranchId=@BranchId AND GearId=@GearId),0);
      DECLARE @NewAvg DECIMAL(18,4);

      IF EXISTS (SELECT 1 FROM dbo.BranchGearValuation WHERE BranchId=@BranchId AND GearId=@GearId)
      BEGIN
        -- Weighted average: ((oldQty*oldAvg)+(inQty*unitCost)) / (oldQty+inQty)
        SET @NewAvg = CASE WHEN (@OldQty + @Qty) = 0 THEN 0 ELSE ((@OldQty * @OldAvg) + (@Qty * @Cost)) / (@OldQty + @Qty) END;
        UPDATE dbo.BranchGearValuation SET AvgUnitCost = @NewAvg WHERE BranchId=@BranchId AND GearId=@GearId;
      END
      ELSE
      BEGIN
        SET @NewAvg = @Cost;
        INSERT INTO dbo.BranchGearValuation(BranchId, GearId, AvgUnitCost) VALUES(@BranchId, @GearId, @NewAvg);
      END

      FETCH NEXT FROM line_cur INTO @GearId, @Qty, @Cost, @SupplierId, @Ref, @Notes;
    END

    CLOSE line_cur; DEALLOCATE line_cur;

    COMMIT TRAN;
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
    DECLARE @Err NVARCHAR(4000) = ERROR_MESSAGE();
    RAISERROR(@Err,16,1);
  END CATCH
END
GO

-- Issue (O), Return (R), Write-off (W)
IF OBJECT_ID('dbo.sp_Stock_IssueReturnWriteOff','P') IS NOT NULL DROP PROCEDURE dbo.sp_Stock_IssueReturnWriteOff;
GO
CREATE PROCEDURE dbo.sp_Stock_IssueReturnWriteOff
  @BranchId INT,
  @CreatedBy INT,
  @TransactionType CHAR(1), -- 'O','R','W'
  @Lines dbo.TVP_TransactionLine READONLY
AS
BEGIN
  SET NOCOUNT ON;
  IF @TransactionType NOT IN ('O','R','W') RAISERROR('Invalid transaction type',16,1);

  IF @TransactionType = 'O' AND dbo.fn_UserHasRole(@CreatedBy,'InventoryClerk') = 0 AND dbo.fn_UserHasRole(@CreatedBy,'Admin') = 0
  BEGIN RAISERROR('User not allowed to issue stock',16,1); RETURN; END
  IF @TransactionType IN ('R','W') AND dbo.fn_UserHasRole(@CreatedBy,'Admin') = 0 AND dbo.fn_UserHasRole(@CreatedBy,'Manager') = 0
  BEGIN RAISERROR('User not allowed for this operation',16,1); RETURN; END

  BEGIN TRAN;
  BEGIN TRY
    DECLARE @Now DATETIME2 = SYSUTCDATETIME();

    DECLARE line_cur CURSOR LOCAL FAST_FORWARD FOR
      SELECT GearId, Quantity, UnitCost, SupplierId, ReferenceNo, Notes FROM @Lines;
    DECLARE @GearId INT, @Qty DECIMAL(18,2), @Cost DECIMAL(18,4), @SupplierId INT, @Ref NVARCHAR(100), @Notes NVARCHAR(500);

    OPEN line_cur;
    FETCH NEXT FROM line_cur INTO @GearId, @Qty, @Cost, @SupplierId, @Ref, @Notes;
    WHILE @@FETCH_STATUS = 0
    BEGIN
      IF @Qty <= 0 RAISERROR('Invalid quantity',16,1);

      DECLARE @CurrentQty DECIMAL(18,2) = ISNULL((SELECT Quantity FROM dbo.BranchInventory WHERE BranchId=@BranchId AND GearId=@GearId),0);
      DECLARE @AvgCost DECIMAL(18,4) = ISNULL((SELECT AvgUnitCost FROM dbo.BranchGearValuation WHERE BranchId=@BranchId AND GearId=@GearId),0);

      IF @TransactionType = 'O' AND @CurrentQty < @Qty
        RAISERROR('Insufficient stock',16,1);

      DECLARE @QtyDelta DECIMAL(18,2) = CASE @TransactionType WHEN 'O' THEN -@Qty WHEN 'R' THEN @Qty WHEN 'W' THEN -@Qty END;
      INSERT INTO dbo.InventoryTransaction(BranchId, GearId, TransactionType, Quantity, UnitCost, SupplierId, ReferenceNo, Notes, CreatedBy, CreatedAt)
      VALUES (@BranchId, @GearId, @TransactionType, @Qty, CASE WHEN @TransactionType='R' THEN @AvgCost ELSE @AvgCost END, @SupplierId, @Ref, @Notes, @CreatedBy, @Now);

      -- Update quantity
      UPDATE dbo.BranchInventory SET Quantity = ISNULL(Quantity,0) + @QtyDelta WHERE BranchId=@BranchId AND GearId=@GearId;
      IF @@ROWCOUNT = 0
        INSERT INTO dbo.BranchInventory(BranchId, GearId, Quantity) VALUES(@BranchId, @GearId, @QtyDelta);

      -- For write-off, cost may be provided to override avg cost for valuation impact
      IF @TransactionType = 'W' AND @Cost IS NOT NULL SET @AvgCost = @Cost;

      -- Do not change moving average on issue/return; only adjust on intake. Optionally could on return, keep AvgCost unchanged.

      FETCH NEXT FROM line_cur INTO @GearId, @Qty, @Cost, @SupplierId, @Ref, @Notes;
    END

    CLOSE line_cur; DEALLOCATE line_cur;

    COMMIT TRAN;
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
    DECLARE @Err NVARCHAR(4000) = ERROR_MESSAGE();
    RAISERROR(@Err,16,1);
  END CATCH
END
GO

-- Reports
IF OBJECT_ID('dbo.sp_Report_StockByBranch','P') IS NOT NULL DROP PROCEDURE dbo.sp_Report_StockByBranch;
GO
CREATE PROCEDURE dbo.sp_Report_StockByBranch
  @BranchId INT = NULL,
  @CategoryId INT = NULL
AS
BEGIN
  SET NOCOUNT ON;
  SELECT b.BranchCode, g.SKU, g.GearName, c.CategoryName, bi.Quantity, v.AvgUnitCost,
         (bi.Quantity * v.AvgUnitCost) AS StockValue
  FROM dbo.BranchInventory bi
  JOIN dbo.Branch b ON b.BranchId = bi.BranchId
  JOIN dbo.Gear g ON g.GearId = bi.GearId
  JOIN dbo.Category c ON c.CategoryId = g.CategoryId
  LEFT JOIN dbo.BranchGearValuation v ON v.BranchId = bi.BranchId AND v.GearId = bi.GearId
  WHERE (@BranchId IS NULL OR bi.BranchId = @BranchId)
    AND (@CategoryId IS NULL OR g.CategoryId = @CategoryId)
  ORDER BY b.BranchCode, c.CategoryName, g.GearName;
END
GO

IF OBJECT_ID('dbo.sp_Report_Transactions','P') IS NOT NULL DROP PROCEDURE dbo.sp_Report_Transactions;
GO
CREATE PROCEDURE dbo.sp_Report_Transactions
  @FromDate DATETIME2 = NULL,
  @ToDate DATETIME2 = NULL,
  @BranchId INT = NULL,
  @TransactionType CHAR(1) = NULL -- I,O,R,W
AS
BEGIN
  SET NOCOUNT ON;
  SELECT it.InventoryTransactionId, it.CreatedAt, b.BranchCode, g.SKU, g.GearName, it.TransactionType,
         it.Quantity, it.UnitCost, s.SupplierName, it.ReferenceNo, it.Notes, u.Username
  FROM dbo.InventoryTransaction it
  JOIN dbo.Branch b ON b.BranchId = it.BranchId
  JOIN dbo.Gear g ON g.GearId = it.GearId
  LEFT JOIN dbo.Supplier s ON s.SupplierId = it.SupplierId
  JOIN dbo.[User] u ON u.UserId = it.CreatedBy
  WHERE (@FromDate IS NULL OR it.CreatedAt >= @FromDate)
    AND (@ToDate IS NULL OR it.CreatedAt <= @ToDate)
    AND (@BranchId IS NULL OR it.BranchId = @BranchId)
    AND (@TransactionType IS NULL OR it.TransactionType = @TransactionType)
  ORDER BY it.CreatedAt DESC;
END
GO

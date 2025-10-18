-- Read-only query stored procedures (for lookups and auth)
USE GearInventory;
GO

IF OBJECT_ID('dbo.sp_User_GetAuthByUsername','P') IS NOT NULL DROP PROCEDURE dbo.sp_User_GetAuthByUsername;
GO
CREATE PROCEDURE dbo.sp_User_GetAuthByUsername
  @Username NVARCHAR(100)
AS
BEGIN
  SET NOCOUNT ON;
  SELECT TOP 1 u.UserId, u.Username, u.PasswordHash, u.PasswordSalt, u.DisplayName, u.IsActive
  FROM dbo.[User] u
  WHERE u.Username = @Username;
END
GO

IF OBJECT_ID('dbo.sp_User_GetRoles','P') IS NOT NULL DROP PROCEDURE dbo.sp_User_GetRoles;
GO
CREATE PROCEDURE dbo.sp_User_GetRoles
  @UserId INT
AS
BEGIN
  SET NOCOUNT ON;
  SELECT r.RoleName
  FROM dbo.UserRole ur
  JOIN dbo.[Role] r ON r.RoleId = ur.RoleId
  WHERE ur.UserId = @UserId;
END
GO

IF OBJECT_ID('dbo.sp_User_Count','P') IS NOT NULL DROP PROCEDURE dbo.sp_User_Count;
GO
CREATE PROCEDURE dbo.sp_User_Count
AS
BEGIN
  SET NOCOUNT ON;
  SELECT COUNT(*) AS TotalUsers FROM dbo.[User];
END
GO

IF OBJECT_ID('dbo.sp_Branch_List','P') IS NOT NULL DROP PROCEDURE dbo.sp_Branch_List;
GO
CREATE PROCEDURE dbo.sp_Branch_List
AS
BEGIN
  SET NOCOUNT ON;
  SELECT BranchId, BranchCode, BranchName FROM dbo.Branch WHERE IsActive = 1 ORDER BY BranchCode;
END
GO

IF OBJECT_ID('dbo.sp_Supplier_List','P') IS NOT NULL DROP PROCEDURE dbo.sp_Supplier_List;
GO
CREATE PROCEDURE dbo.sp_Supplier_List
AS
BEGIN
  SET NOCOUNT ON;
  SELECT SupplierId, SupplierCode, SupplierName FROM dbo.Supplier WHERE IsActive = 1 ORDER BY SupplierName;
END
GO

IF OBJECT_ID('dbo.sp_Category_Tree','P') IS NOT NULL DROP PROCEDURE dbo.sp_Category_Tree;
GO
CREATE PROCEDURE dbo.sp_Category_Tree
AS
BEGIN
  SET NOCOUNT ON;
  SELECT CategoryId, ParentCategoryId, CategoryCode, CategoryName, IsActive FROM dbo.Category ORDER BY CategoryName;
END
GO

IF OBJECT_ID('dbo.sp_Gear_List','P') IS NOT NULL DROP PROCEDURE dbo.sp_Gear_List;
GO
CREATE PROCEDURE dbo.sp_Gear_List
  @CategoryId INT = NULL
AS
BEGIN
  SET NOCOUNT ON;
  SELECT g.GearId, g.SKU, g.GearName, g.CategoryId, g.UnitOfMeasure
  FROM dbo.Gear g
  WHERE g.IsActive = 1 AND (@CategoryId IS NULL OR g.CategoryId = @CategoryId)
  ORDER BY g.GearName;
END
GO

IF OBJECT_ID('dbo.sp_Report_ReorderAlerts','P') IS NOT NULL DROP PROCEDURE dbo.sp_Report_ReorderAlerts;
GO
CREATE PROCEDURE dbo.sp_Report_ReorderAlerts
  @BranchId INT = NULL
AS
BEGIN
  SET NOCOUNT ON;
  SELECT b.BranchCode, g.SKU, g.GearName, bi.Quantity, g.ReorderLevel
  FROM dbo.BranchInventory bi
  JOIN dbo.Branch b ON b.BranchId = bi.BranchId
  JOIN dbo.Gear g ON g.GearId = bi.GearId
  WHERE (@BranchId IS NULL OR bi.BranchId = @BranchId)
    AND bi.Quantity <= g.ReorderLevel
  ORDER BY b.BranchCode, g.GearName;
END
GO

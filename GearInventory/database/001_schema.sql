-- Gear Inventory Management - Database Schema (SQL Server)
-- All writes and reports to be via stored procedures only.

IF DB_ID('GearInventory') IS NULL
BEGIN
  CREATE DATABASE GearInventory;
END
GO

USE GearInventory;
GO

-- Branches
IF OBJECT_ID('dbo.Branch','U') IS NOT NULL DROP TABLE dbo.Branch;
CREATE TABLE dbo.Branch (
  BranchId        INT IDENTITY(1,1) PRIMARY KEY,
  BranchCode      NVARCHAR(20) NOT NULL UNIQUE,
  BranchName      NVARCHAR(100) NOT NULL,
  AddressLine1    NVARCHAR(200) NULL,
  AddressLine2    NVARCHAR(200) NULL,
  City            NVARCHAR(100) NULL,
  StateProvince   NVARCHAR(100) NULL,
  PostalCode      NVARCHAR(20) NULL,
  Country         NVARCHAR(100) NULL,
  IsActive        BIT NOT NULL DEFAULT 1,
  CreatedAt       DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
  UpdatedAt       DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

-- Suppliers
IF OBJECT_ID('dbo.Supplier','U') IS NOT NULL DROP TABLE dbo.Supplier;
CREATE TABLE dbo.Supplier (
  SupplierId   INT IDENTITY(1,1) PRIMARY KEY,
  SupplierCode NVARCHAR(30) NOT NULL UNIQUE,
  SupplierName NVARCHAR(150) NOT NULL,
  ContactName  NVARCHAR(100) NULL,
  Phone        NVARCHAR(50) NULL,
  Email        NVARCHAR(150) NULL,
  Address      NVARCHAR(300) NULL,
  IsActive     BIT NOT NULL DEFAULT 1,
  CreatedAt    DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
  UpdatedAt    DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

-- Categories (hierarchical)
IF OBJECT_ID('dbo.Category','U') IS NOT NULL DROP TABLE dbo.Category;
CREATE TABLE dbo.Category (
  CategoryId      INT IDENTITY(1,1) PRIMARY KEY,
  ParentCategoryId INT NULL REFERENCES dbo.Category(CategoryId),
  CategoryCode    NVARCHAR(30) NOT NULL UNIQUE,
  CategoryName    NVARCHAR(150) NOT NULL,
  IsActive        BIT NOT NULL DEFAULT 1,
  CreatedAt       DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
  UpdatedAt       DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

-- Gear (items)
IF OBJECT_ID('dbo.Gear','U') IS NOT NULL DROP TABLE dbo.Gear;
CREATE TABLE dbo.Gear (
  GearId        INT IDENTITY(1,1) PRIMARY KEY,
  SKU           NVARCHAR(50) NOT NULL UNIQUE,
  GearName      NVARCHAR(200) NOT NULL,
  CategoryId    INT NOT NULL REFERENCES dbo.Category(CategoryId),
  UnitOfMeasure NVARCHAR(20) NOT NULL,
  ReorderLevel  DECIMAL(18,2) NOT NULL DEFAULT 0,
  IsActive      BIT NOT NULL DEFAULT 1,
  CreatedAt     DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
  UpdatedAt     DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

-- Users & Roles
IF OBJECT_ID('dbo.[User]','U') IS NOT NULL DROP TABLE dbo.[User];
IF OBJECT_ID('dbo.[Role]','U') IS NOT NULL DROP TABLE dbo.[Role];
IF OBJECT_ID('dbo.UserRole','U') IS NOT NULL DROP TABLE dbo.UserRole;

CREATE TABLE dbo.[Role](
  RoleId INT IDENTITY(1,1) PRIMARY KEY,
  RoleName NVARCHAR(50) NOT NULL UNIQUE
);
GO

CREATE TABLE dbo.[User](
  UserId INT IDENTITY(1,1) PRIMARY KEY,
  Username NVARCHAR(100) NOT NULL UNIQUE,
  PasswordHash VARBINARY(256) NOT NULL,
  PasswordSalt VARBINARY(128) NOT NULL,
  DisplayName NVARCHAR(150) NOT NULL,
  IsActive BIT NOT NULL DEFAULT 1,
  CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
  UpdatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

CREATE TABLE dbo.UserRole(
  UserId INT NOT NULL REFERENCES dbo.[User](UserId),
  RoleId INT NOT NULL REFERENCES dbo.[Role](RoleId),
  PRIMARY KEY(UserId, RoleId)
);
GO

-- Branch Inventory: quantity per gear per branch
IF OBJECT_ID('dbo.BranchInventory','U') IS NOT NULL DROP TABLE dbo.BranchInventory;
CREATE TABLE dbo.BranchInventory (
  BranchId INT NOT NULL REFERENCES dbo.Branch(BranchId),
  GearId   INT NOT NULL REFERENCES dbo.Gear(GearId),
  Quantity DECIMAL(18,2) NOT NULL DEFAULT 0,
  PRIMARY KEY(BranchId, GearId)
);
GO

-- Transactions: intake, issue, return, write-off
IF OBJECT_ID('dbo.InventoryTransaction','U') IS NOT NULL DROP TABLE dbo.InventoryTransaction;
CREATE TABLE dbo.InventoryTransaction (
  InventoryTransactionId BIGINT IDENTITY(1,1) PRIMARY KEY,
  BranchId INT NOT NULL REFERENCES dbo.Branch(BranchId),
  GearId   INT NOT NULL REFERENCES dbo.Gear(GearId),
  TransactionType CHAR(1) NOT NULL CHECK (TransactionType IN ('I','O','R','W')), -- I=intake, O=issue out, R=return, W=write-off
  Quantity DECIMAL(18,2) NOT NULL,
  UnitCost DECIMAL(18,4) NULL, -- only for intake/write-off valuation
  SupplierId INT NULL REFERENCES dbo.Supplier(SupplierId),
  ReferenceNo NVARCHAR(100) NULL,
  Notes NVARCHAR(500) NULL,
  CreatedBy INT NOT NULL REFERENCES dbo.[User](UserId),
  CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

-- Stock valuation per branch + gear (moving average)
IF OBJECT_ID('dbo.BranchGearValuation','U') IS NOT NULL DROP TABLE dbo.BranchGearValuation;
CREATE TABLE dbo.BranchGearValuation (
  BranchId INT NOT NULL REFERENCES dbo.Branch(BranchId),
  GearId   INT NOT NULL REFERENCES dbo.Gear(GearId),
  AvgUnitCost DECIMAL(18,4) NOT NULL DEFAULT 0,
  PRIMARY KEY(BranchId, GearId)
);
GO

-- Indexes
CREATE INDEX IX_InventoryTransaction_Branch_Gear_Date ON dbo.InventoryTransaction(BranchId, GearId, CreatedAt DESC);
CREATE INDEX IX_Gear_Category ON dbo.Gear(CategoryId);
GO

-- Utility function for role check
IF OBJECT_ID('dbo.fn_UserHasRole','FN') IS NOT NULL DROP FUNCTION dbo.fn_UserHasRole;
GO
CREATE FUNCTION dbo.fn_UserHasRole(@UserId INT, @RoleName NVARCHAR(50))
RETURNS BIT
AS
BEGIN
  DECLARE @Has BIT = 0;
  IF EXISTS (
    SELECT 1 FROM dbo.UserRole ur
    JOIN dbo.[Role] r ON r.RoleId = ur.RoleId
    WHERE ur.UserId = @UserId AND r.RoleName = @RoleName
  ) SET @Has = 1;
  RETURN @Has;
END
GO

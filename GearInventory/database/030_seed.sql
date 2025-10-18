-- Seed data for quick demo
USE GearInventory;
GO

-- Roles
IF NOT EXISTS (SELECT 1 FROM dbo.[Role] WHERE RoleName='Admin') INSERT INTO dbo.[Role](RoleName) VALUES('Admin');
IF NOT EXISTS (SELECT 1 FROM dbo.[Role] WHERE RoleName='Manager') INSERT INTO dbo.[Role](RoleName) VALUES('Manager');
IF NOT EXISTS (SELECT 1 FROM dbo.[Role] WHERE RoleName='InventoryClerk') INSERT INTO dbo.[Role](RoleName) VALUES('InventoryClerk');
GO

-- Branches
IF NOT EXISTS (SELECT 1 FROM dbo.Branch WHERE BranchCode='HQ') INSERT INTO dbo.Branch(BranchCode, BranchName, City, Country) VALUES('HQ','Headquarters','CityA','CountryX');
IF NOT EXISTS (SELECT 1 FROM dbo.Branch WHERE BranchCode='BR1') INSERT INTO dbo.Branch(BranchCode, BranchName, City, Country) VALUES('BR1','Branch One','CityB','CountryX');
GO

-- Categories
IF NOT EXISTS (SELECT 1 FROM dbo.Category WHERE CategoryCode='PPE') INSERT INTO dbo.Category(CategoryCode, CategoryName) VALUES('PPE','Protective Equipment');
IF NOT EXISTS (SELECT 1 FROM dbo.Category WHERE CategoryCode='TOOLS') INSERT INTO dbo.Category(CategoryCode, CategoryName) VALUES('TOOLS','Tools');
GO

-- Suppliers
IF NOT EXISTS (SELECT 1 FROM dbo.Supplier WHERE SupplierCode='SUP1') INSERT INTO dbo.Supplier(SupplierCode, SupplierName) VALUES('SUP1','Supplier One');
GO

-- Gear
DECLARE @catPPE INT = (SELECT CategoryId FROM dbo.Category WHERE CategoryCode='PPE');
DECLARE @catTOOLS INT = (SELECT CategoryId FROM dbo.Category WHERE CategoryCode='TOOLS');
IF NOT EXISTS (SELECT 1 FROM dbo.Gear WHERE SKU='GLOVES-M') INSERT INTO dbo.Gear(SKU, GearName, CategoryId, UnitOfMeasure, ReorderLevel) VALUES('GLOVES-M','Safety Gloves - M', @catPPE, 'pair', 10);
IF NOT EXISTS (SELECT 1 FROM dbo.Gear WHERE SKU='HAMMER-16') INSERT INTO dbo.Gear(SKU, GearName, CategoryId, UnitOfMeasure, ReorderLevel) VALUES('HAMMER-16','Hammer 16oz', @catTOOLS, 'ea', 5);
GO

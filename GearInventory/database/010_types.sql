-- Table Types for TVPs
USE GearInventory;
GO

IF TYPE_ID('dbo.TVP_TransactionLine') IS NOT NULL DROP TYPE dbo.TVP_TransactionLine;
GO
CREATE TYPE dbo.TVP_TransactionLine AS TABLE
(
  GearId INT NOT NULL,
  Quantity DECIMAL(18,2) NOT NULL,
  UnitCost DECIMAL(18,4) NULL, -- required for intakes/write-off
  SupplierId INT NULL,
  ReferenceNo NVARCHAR(100) NULL,
  Notes NVARCHAR(500) NULL
);
GO

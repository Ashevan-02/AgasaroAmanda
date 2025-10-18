using System;

namespace GearInventory.Domain.Models;

public sealed class InventoryTransaction
{
    public long InventoryTransactionId { get; set; }
    public int BranchId { get; set; }
    public int GearId { get; set; }
    public char TransactionType { get; set; } // I,O,R,W
    public decimal Quantity { get; set; }
    public decimal? UnitCost { get; set; }
    public int? SupplierId { get; set; }
    public string? ReferenceNo { get; set; }
    public string? Notes { get; set; }
    public int CreatedBy { get; set; }
    public DateTime CreatedAt { get; set; }
}

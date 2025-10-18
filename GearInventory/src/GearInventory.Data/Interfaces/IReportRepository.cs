using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace GearInventory.Data.Interfaces;

public interface IReportRepository
{
    Task<IReadOnlyList<StockByBranchRow>> GetStockByBranchAsync(int? branchId = null, int? categoryId = null);
    Task<IReadOnlyList<TransactionRow>> GetTransactionsAsync(DateTime? fromDate = null, DateTime? toDate = null, int? branchId = null, char? transactionType = null);
}

public sealed class StockByBranchRow
{
    public string BranchCode { get; set; } = string.Empty;
    public string SKU { get; set; } = string.Empty;
    public string GearName { get; set; } = string.Empty;
    public string CategoryName { get; set; } = string.Empty;
    public decimal Quantity { get; set; }
    public decimal AvgUnitCost { get; set; }
    public decimal StockValue { get; set; }
}

public sealed class TransactionRow
{
    public long InventoryTransactionId { get; set; }
    public DateTime CreatedAt { get; set; }
    public string BranchCode { get; set; } = string.Empty;
    public string SKU { get; set; } = string.Empty;
    public string GearName { get; set; } = string.Empty;
    public char TransactionType { get; set; }
    public decimal Quantity { get; set; }
    public decimal? UnitCost { get; set; }
    public string? SupplierName { get; set; }
    public string? ReferenceNo { get; set; }
    public string? Notes { get; set; }
    public string Username { get; set; } = string.Empty;
}
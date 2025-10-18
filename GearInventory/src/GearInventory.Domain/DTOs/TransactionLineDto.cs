namespace GearInventory.Domain.DTOs;

public sealed class TransactionLineDto
{
    public int GearId { get; set; }
    public decimal Quantity { get; set; }
    public decimal? UnitCost { get; set; }
    public int? SupplierId { get; set; }
    public string? ReferenceNo { get; set; }
    public string? Notes { get; set; }
}

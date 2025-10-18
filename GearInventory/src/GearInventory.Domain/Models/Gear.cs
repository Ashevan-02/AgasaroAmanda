namespace GearInventory.Domain.Models;

public sealed class Gear
{
    public int GearId { get; set; }
    public string SKU { get; set; } = string.Empty;
    public string GearName { get; set; } = string.Empty;
    public int CategoryId { get; set; }
    public string UnitOfMeasure { get; set; } = string.Empty;
}

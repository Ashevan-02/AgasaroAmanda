namespace GearInventory.Domain.Models;

public sealed class Category
{
    public int CategoryId { get; set; }
    public int? ParentCategoryId { get; set; }
    public string CategoryCode { get; set; } = string.Empty;
    public string CategoryName { get; set; } = string.Empty;
    public bool IsActive { get; set; } = true;
}

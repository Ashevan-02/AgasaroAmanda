using System.Collections.Generic;
using System.Threading.Tasks;
using GearInventory.Domain.Models;

namespace GearInventory.Data.Interfaces;

public interface ILookupRepository
{
    Task<IReadOnlyList<Branch>> GetBranchesAsync();
    Task<IReadOnlyList<Supplier>> GetSuppliersAsync();
    Task<IReadOnlyList<Category>> GetCategoriesAsync();
    Task<IReadOnlyList<Gear>> GetGearAsync(int? categoryId = null);
}

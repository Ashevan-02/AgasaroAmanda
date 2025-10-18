using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using GearInventory.Data.Interfaces;
using GearInventory.Domain.Models;
using Microsoft.Data.SqlClient;

namespace GearInventory.Data;

public sealed class LookupRepository : ILookupRepository
{
    private readonly SqlConnectionFactory _connectionFactory;

    public LookupRepository(SqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<IReadOnlyList<Branch>> GetBranchesAsync()
    {
        using var conn = _connectionFactory.CreateOpen();
        using var cmd = new SqlCommand("dbo.sp_Branch_List", conn) { CommandType = CommandType.StoredProcedure };
        var list = new List<Branch>();
        using var rd = await cmd.ExecuteReaderAsync();
        while (await rd.ReadAsync())
        {
            list.Add(new Branch
            {
                BranchId = rd.GetInt32(0),
                BranchCode = rd.GetString(1),
                BranchName = rd.GetString(2)
            });
        }
        return list;
    }

    public async Task<IReadOnlyList<Supplier>> GetSuppliersAsync()
    {
        using var conn = _connectionFactory.CreateOpen();
        using var cmd = new SqlCommand("dbo.sp_Supplier_List", conn) { CommandType = CommandType.StoredProcedure };
        var list = new List<Supplier>();
        using var rd = await cmd.ExecuteReaderAsync();
        while (await rd.ReadAsync())
        {
            list.Add(new Supplier
            {
                SupplierId = rd.GetInt32(0),
                SupplierCode = rd.GetString(1),
                SupplierName = rd.GetString(2)
            });
        }
        return list;
    }

    public async Task<IReadOnlyList<Category>> GetCategoriesAsync()
    {
        using var conn = _connectionFactory.CreateOpen();
        using var cmd = new SqlCommand("dbo.sp_Category_Tree", conn) { CommandType = CommandType.StoredProcedure };
        var list = new List<Category>();
        using var rd = await cmd.ExecuteReaderAsync();
        while (await rd.ReadAsync())
        {
            list.Add(new Category
            {
                CategoryId = rd.GetInt32(0),
                ParentCategoryId = rd.IsDBNull(1) ? null : rd.GetInt32(1),
                CategoryCode = rd.GetString(2),
                CategoryName = rd.GetString(3),
                IsActive = rd.GetBoolean(4)
            });
        }
        return list;
    }

    public async Task<IReadOnlyList<Gear>> GetGearAsync(int? categoryId = null)
    {
        using var conn = _connectionFactory.CreateOpen();
        using var cmd = new SqlCommand("dbo.sp_Gear_List", conn) { CommandType = CommandType.StoredProcedure };
        cmd.Parameters.Add(new SqlParameter("@CategoryId", SqlDbType.Int) { Value = (object?)categoryId ?? System.DBNull.Value });
        var list = new List<Gear>();
        using var rd = await cmd.ExecuteReaderAsync();
        while (await rd.ReadAsync())
        {
            list.Add(new Gear
            {
                GearId = rd.GetInt32(0),
                SKU = rd.GetString(1),
                GearName = rd.GetString(2),
                CategoryId = rd.GetInt32(3),
                UnitOfMeasure = rd.GetString(4)
            });
        }
        return list;
    }
}

using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using GearInventory.Data.Interfaces;
using Microsoft.Data.SqlClient;

namespace GearInventory.Data;

public sealed class ReportRepository : IReportRepository
{
    private readonly SqlConnectionFactory _connectionFactory;

    public ReportRepository(SqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<IReadOnlyList<StockByBranchRow>> GetStockByBranchAsync(int? branchId = null, int? categoryId = null)
    {
        using var conn = _connectionFactory.CreateOpen();
        using var cmd = new SqlCommand("dbo.sp_Report_StockByBranch", conn) { CommandType = CommandType.StoredProcedure };
        cmd.Parameters.Add(new SqlParameter("@BranchId", SqlDbType.Int) { Value = (object?)branchId ?? System.DBNull.Value });
        cmd.Parameters.Add(new SqlParameter("@CategoryId", SqlDbType.Int) { Value = (object?)categoryId ?? System.DBNull.Value });
        var list = new List<StockByBranchRow>();
        using var rd = await cmd.ExecuteReaderAsync();
        while (await rd.ReadAsync())
        {
            list.Add(new StockByBranchRow
            {
                BranchCode = rd.GetString(0),
                SKU = rd.GetString(1),
                GearName = rd.GetString(2),
                CategoryName = rd.GetString(3),
                Quantity = rd.IsDBNull(4) ? 0 : rd.GetDecimal(4),
                AvgUnitCost = rd.IsDBNull(5) ? 0 : rd.GetDecimal(5),
                StockValue = rd.IsDBNull(6) ? 0 : rd.GetDecimal(6)
            });
        }
        return list;
    }

    public async Task<IReadOnlyList<TransactionRow>> GetTransactionsAsync(DateTime? fromDate = null, DateTime? toDate = null, int? branchId = null, char? transactionType = null)
    {
        using var conn = _connectionFactory.CreateOpen();
        using var cmd = new SqlCommand("dbo.sp_Report_Transactions", conn) { CommandType = CommandType.StoredProcedure };
        cmd.Parameters.Add(new SqlParameter("@FromDate", SqlDbType.DateTime2) { Value = (object?)fromDate ?? System.DBNull.Value });
        cmd.Parameters.Add(new SqlParameter("@ToDate", SqlDbType.DateTime2) { Value = (object?)toDate ?? System.DBNull.Value });
        cmd.Parameters.Add(new SqlParameter("@BranchId", SqlDbType.Int) { Value = (object?)branchId ?? System.DBNull.Value });
        cmd.Parameters.Add(new SqlParameter("@TransactionType", SqlDbType.Char, 1) { Value = (object?)transactionType ?? System.DBNull.Value });
        var list = new List<TransactionRow>();
        using var rd = await cmd.ExecuteReaderAsync();
        while (await rd.ReadAsync())
        {
            list.Add(new TransactionRow
            {
                InventoryTransactionId = rd.GetInt64(0),
                CreatedAt = rd.GetDateTime(1),
                BranchCode = rd.GetString(2),
                SKU = rd.GetString(3),
                GearName = rd.GetString(4),
                TransactionType = rd.GetString(5)[0],
                Quantity = rd.GetDecimal(6),
                UnitCost = rd.IsDBNull(7) ? null : rd.GetDecimal(7),
                SupplierName = rd.IsDBNull(8) ? null : rd.GetString(8),
                ReferenceNo = rd.IsDBNull(9) ? null : rd.GetString(9),
                Notes = rd.IsDBNull(10) ? null : rd.GetString(10),
                Username = rd.GetString(11)
            });
        }
        return list;
    }
}

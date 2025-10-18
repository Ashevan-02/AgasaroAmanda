using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using GearInventory.Data.Interfaces;
using GearInventory.Domain.DTOs;
using Microsoft.Data.SqlClient;

namespace GearInventory.Data;

public sealed class InventoryRepository : IInventoryRepository
{
    private readonly SqlConnectionFactory _connectionFactory;

    public InventoryRepository(SqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public Task IntakeAsync(int branchId, int createdBy, IEnumerable<TransactionLineDto> lines) =>
        ExecuteLinesAsync("dbo.sp_Stock_Intake", branchId, createdBy, null, lines);

    public Task IssueAsync(int branchId, int createdBy, IEnumerable<TransactionLineDto> lines) =>
        ExecuteLinesAsync("dbo.sp_Stock_IssueReturnWriteOff", branchId, createdBy, 'O', lines);

    public Task ReturnAsync(int branchId, int createdBy, IEnumerable<TransactionLineDto> lines) =>
        ExecuteLinesAsync("dbo.sp_Stock_IssueReturnWriteOff", branchId, createdBy, 'R', lines);

    public Task WriteOffAsync(int branchId, int createdBy, IEnumerable<TransactionLineDto> lines) =>
        ExecuteLinesAsync("dbo.sp_Stock_IssueReturnWriteOff", branchId, createdBy, 'W', lines);

    private async Task ExecuteLinesAsync(string procedureName, int branchId, int createdBy, char? txType, IEnumerable<TransactionLineDto> lines)
    {
        using var conn = _connectionFactory.CreateOpen();
        using var cmd = new SqlCommand(procedureName, conn) { CommandType = CommandType.StoredProcedure };
        cmd.Parameters.Add(new SqlParameter("@BranchId", SqlDbType.Int) { Value = branchId });
        cmd.Parameters.Add(new SqlParameter("@CreatedBy", SqlDbType.Int) { Value = createdBy });
        if (txType.HasValue) cmd.Parameters.Add(new SqlParameter("@TransactionType", SqlDbType.Char, 1) { Value = txType.Value });

        var tvp = new DataTable();
        tvp.Columns.Add("GearId", typeof(int));
        tvp.Columns.Add("Quantity", typeof(decimal));
        tvp.Columns.Add("UnitCost", typeof(decimal));
        tvp.Columns.Add("SupplierId", typeof(int));
        tvp.Columns.Add("ReferenceNo", typeof(string));
        tvp.Columns.Add("Notes", typeof(string));

        foreach (var l in lines)
        {
            tvp.Rows.Add(l.GearId, l.Quantity, (object?)l.UnitCost ?? System.DBNull.Value, (object?)l.SupplierId ?? System.DBNull.Value, (object?)l.ReferenceNo ?? System.DBNull.Value, (object?)l.Notes ?? System.DBNull.Value);
        }

        var p = cmd.Parameters.AddWithValue("@Lines", tvp);
        p.SqlDbType = SqlDbType.Structured;
        p.TypeName = "dbo.TVP_TransactionLine";

        await cmd.ExecuteNonQueryAsync();
    }
}

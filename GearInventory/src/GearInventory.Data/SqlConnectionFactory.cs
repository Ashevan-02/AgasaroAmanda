using System.Data;
using Microsoft.Data.SqlClient;

namespace GearInventory.Data;

public sealed class SqlConnectionFactory
{
    private readonly string _connectionString;

    public SqlConnectionFactory(string connectionString)
    {
        _connectionString = connectionString;
    }

    public SqlConnection CreateOpen()
    {
        var conn = new SqlConnection(_connectionString);
        conn.Open();
        return conn;
    }

    public SqlConnection Create() => new SqlConnection(_connectionString);
}

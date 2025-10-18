using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using GearInventory.Data.Interfaces;
using GearInventory.Domain.Models;
using Microsoft.Data.SqlClient;

namespace GearInventory.Data;

public sealed class AuthRepository : IAuthRepository
{
    private readonly SqlConnectionFactory _connectionFactory;

    public AuthRepository(SqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<(User? user, byte[]? passwordHash, byte[]? passwordSalt, IReadOnlyList<string> roles)> GetAuthByUsernameAsync(string username)
    {
        using var conn = _connectionFactory.CreateOpen();

        using var cmd = new SqlCommand("dbo.sp_User_GetAuthByUsername", conn) { CommandType = CommandType.StoredProcedure };
        cmd.Parameters.Add(new SqlParameter("@Username", SqlDbType.NVarChar, 100) { Value = username });

        using var reader = await cmd.ExecuteReaderAsync();
        User? user = null; byte[]? hash = null; byte[]? salt = null; bool isActive = false;
        if (await reader.ReadAsync())
        {
            user = new User
            {
                UserId = reader.GetInt32(reader.GetOrdinal("UserId")),
                Username = reader.GetString(reader.GetOrdinal("Username")),
                DisplayName = reader.GetString(reader.GetOrdinal("DisplayName")),
                IsActive = reader.GetBoolean(reader.GetOrdinal("IsActive"))
            };
            hash = (byte[])reader["PasswordHash"]; // VARBINARY
            salt = (byte[])reader["PasswordSalt"]; // VARBINARY
            isActive = user.IsActive;
        }
        await reader.CloseAsync();

        var roles = new List<string>();
        if (user != null)
        {
            using var cmdRoles = new SqlCommand("dbo.sp_User_GetRoles", conn) { CommandType = CommandType.StoredProcedure };
            cmdRoles.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = user.UserId });
            using var rd = await cmdRoles.ExecuteReaderAsync();
            while (await rd.ReadAsync()) roles.Add(rd.GetString(0));
        }

        return (user, hash, salt, roles);
    }
}

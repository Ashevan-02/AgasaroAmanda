using System;
using Microsoft.Extensions.Configuration;
using GearInventory.Data;

namespace GearInventory.App;

public static class AppBootstrapper
{
    private static IConfigurationRoot? _configuration;
    private static string? _connectionString;

    public static void Initialize()
    {
        var builder = new ConfigurationBuilder()
            .SetBasePath(AppContext.BaseDirectory)
            .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);
        _configuration = builder.Build();
        _connectionString = _configuration.GetConnectionString("Default");
        if (string.IsNullOrWhiteSpace(_connectionString))
            throw new InvalidOperationException("Connection string 'Default' not found.");

        SqlConnectionFactory = new SqlConnectionFactory(_connectionString);
        AuthRepository = new AuthRepository(SqlConnectionFactory);
        LookupRepository = new LookupRepository(SqlConnectionFactory);
        InventoryRepository = new InventoryRepository(SqlConnectionFactory);
        ReportRepository = new ReportRepository(SqlConnectionFactory);
    }

    public static SqlConnectionFactory SqlConnectionFactory { get; private set; } = null!;
    public static AuthRepository AuthRepository { get; private set; } = null!;
    public static LookupRepository LookupRepository { get; private set; } = null!;
    public static InventoryRepository InventoryRepository { get; private set; } = null!;
    public static ReportRepository ReportRepository { get; private set; } = null!;
}

using System.Collections.Generic;
using System.Threading.Tasks;
using GearInventory.Domain.Models;

namespace GearInventory.Data.Interfaces;

public interface IAuthRepository
{
    Task<(User? user, byte[]? passwordHash, byte[]? passwordSalt, IReadOnlyList<string> roles)> GetAuthByUsernameAsync(string username);
}

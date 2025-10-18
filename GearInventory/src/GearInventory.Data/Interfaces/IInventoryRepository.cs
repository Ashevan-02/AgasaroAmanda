using System.Collections.Generic;
using System.Threading.Tasks;
using GearInventory.Domain.DTOs;

namespace GearInventory.Data.Interfaces;

public interface IInventoryRepository
{
    Task IntakeAsync(int branchId, int createdBy, IEnumerable<TransactionLineDto> lines);
    Task IssueAsync(int branchId, int createdBy, IEnumerable<TransactionLineDto> lines);
    Task ReturnAsync(int branchId, int createdBy, IEnumerable<TransactionLineDto> lines);
    Task WriteOffAsync(int branchId, int createdBy, IEnumerable<TransactionLineDto> lines);
}

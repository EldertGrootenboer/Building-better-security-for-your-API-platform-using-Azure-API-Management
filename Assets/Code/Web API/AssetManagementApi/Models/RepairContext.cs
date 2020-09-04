using Microsoft.EntityFrameworkCore;

namespace AssetManagementApi.Models
{
    public class RepairContext : DbContext
    {
        public RepairContext(DbContextOptions<RepairContext> options) : base(options)
        {
        }

        public DbSet<Repair> Repairs { get; set; }
    }
}
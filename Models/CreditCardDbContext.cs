using Microsoft.EntityFrameworkCore;

namespace CreditCardAPI.Models
{
    public class CreditCardDbContext : DbContext
    {
        public CreditCardDbContext(DbContextOptions<CreditCardDbContext> options)
            : base(options)
        {
        }

        public DbSet<CardHolder> CardHolders { get; set; }
        public DbSet<CreditCard> CreditCards { get; set; }
        public DbSet<Transaction> Transactions { get; set; }
    }
}

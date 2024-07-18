using CreditCardAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace CreditCardAPI.Data
{
    public class CreditCardDbContext : DbContext
    {
        public CreditCardDbContext(DbContextOptions<CreditCardDbContext> options)
            : base(options)
        {
        }

        public DbSet<CreditCard> CreditCards { get; set; }
        //public DbSet<Transaction> Transactions { get; set; }
        public DbSet<Purchase> Purchases { get; set; }
        public DbSet<Payment> Payments { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<CreditCard>()
                .HasKey(c => c.CreditCardId);

            modelBuilder.Entity<Purchase>()
                .HasKey(p => p.PurchaseId);

            modelBuilder.Entity<Payment>()
                .HasKey(p => p.PaymentId);
        }
    }
}

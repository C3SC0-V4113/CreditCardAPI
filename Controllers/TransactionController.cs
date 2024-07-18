using CreditCardAPI.Data;
using CreditCardAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace CreditCardAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TransactionController : ControllerBase
    {
        private readonly CreditCardDbContext _context;

        public TransactionController(CreditCardDbContext context)
        {
            _context = context;
        }

        [HttpGet("{creditCardId}")]
        public async Task<IActionResult> GetTransactions(int creditCardId)
        {
            var creditCard = await _context.CreditCards.FindAsync(creditCardId);
            if (creditCard == null)
            {
                return NotFound();
            }

            var purchases = await _context.Purchases
                .Where(p => p.CreditCardId == creditCardId)
                .Select(p => new Transaction
                {
                    TransactionDate = p.PurchaseDate,
                    Description = p.Description,
                    Charge = p.Amount,
                    Credit = null
                })
                .ToListAsync();

            var payments = await _context.Payments
                .Where(p => p.CreditCardId == creditCardId)
                .Select(p => new Transaction
                {
                    TransactionDate = p.PaymentDate,
                    Description = "Pago TC",
                    Charge = null,
                    Credit = p.Amount
                })
                .ToListAsync();

            var transactions = purchases.Concat(payments)
                .OrderByDescending(t => t.TransactionDate)
                .ToList();

            return Ok(transactions);
        }

    }
}

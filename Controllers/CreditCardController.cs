using CreditCardAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace CreditCardAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CreditCardController:ControllerBase
    {
        private readonly CreditCardDbContext _context;

        public CreditCardController(CreditCardDbContext context)
        {
            _context = context;
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<CreditCardStatementDto>> GetCreditCardStatement(int id)
        {
            var creditCard = await _context.CreditCards
                .Include(cc => cc.CardHolder)
                .Include(cc => cc.Transactions)
                .FirstOrDefaultAsync(cc => cc.CreditCardId == id);

            if (creditCard == null)
            {
                return NotFound();
            }

            var statement = new CreditCardStatementDto
            {
                CardHolderName = creditCard.CardHolder.Name,
                CardNumber = creditCard.CardNumber,
                CurrentBalance = creditCard.CurrentBalance,
                CreditLimit = creditCard.CreditLimit,
                AvailableBalance = creditCard.AvailableBalance,
                Transactions = creditCard.Transactions.Select(t => new TransactionDto
                {
                    TransactionDate = t.TransactionDate,
                    Description = t.Description,
                    Amount = t.Amount,
                    TransactionType = t.TransactionType
                }),
                TotalPurchasesThisMonth = creditCard.Transactions
                    .Where(t => t.TransactionDate.Month == DateTime.Now.Month && t.TransactionType == "Purchase")
                    .Sum(t => t.Amount),
                TotalPurchasesLastMonth = creditCard.Transactions
                    .Where(t => t.TransactionDate.Month == DateTime.Now.AddMonths(-1).Month && t.TransactionType == "Purchase")
                    .Sum(t => t.Amount),
                BonifiableInterest = creditCard.CurrentBalance * 0.25M,
                MinimumPayment = creditCard.CurrentBalance * 0.05M,
                TotalPayment = creditCard.CurrentBalance,
                FullPaymentWithInterest = creditCard.CurrentBalance + (creditCard.CurrentBalance * 0.25M)
            };

            return statement;
        }

        [HttpPost("transaction")]
        public async Task<ActionResult<Transaction>> PostTransaction(Transaction transaction)
        {
            _context.Transactions.Add(transaction);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetTransaction", new { id = transaction.TransactionId }, transaction);
        }

        [HttpGet("history/{id}")]
        public async Task<ActionResult<IEnumerable<TransactionDto>>> GetTransactionHistory(int id)
        {
            var transactions = await _context.Transactions
                 .Where(t => t.CreditCardId == id)
                 .OrderByDescending(t => t.TransactionDate)
                 .Select(t => new TransactionDto
                 {
                     TransactionDate = t.TransactionDate,
                     Description = t.Description,
                     Amount = t.Amount,
                     TransactionType = t.TransactionType
                 })
                 .ToListAsync();

            return transactions;
        }
    }
}

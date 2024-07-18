using CreditCardAPI.Data;
using CreditCardAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace CreditCardAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StatementController:ControllerBase
    {
        private readonly CreditCardDbContext _context;

        public StatementController(CreditCardDbContext context)
        {
            _context = context;
        }

        [HttpGet("{creditCardId}")]
        public async Task<IActionResult> GetStatement(int creditCardId)
        {
            var creditCard = await _context.CreditCards.FindAsync(creditCardId);
            if (creditCard == null)
            {
                return NotFound();
            }

            var purchases = await _context.Purchases
                .Where(p => p.CreditCardId == creditCardId)
                .ToListAsync();

            var currentMonthPurchases = purchases
    .Where(p => p.PurchaseDate.Month == System.DateTime.Now.Month && p.PurchaseDate.Year == System.DateTime.Now.Year)
    .Sum(p => p.Amount);

            var previousMonthPurchases = purchases
                .Where(p => p.PurchaseDate.Month == System.DateTime.Now.AddMonths(-1).Month && p.PurchaseDate.Year == System.DateTime.Now.AddMonths(-1).Year)
                .Sum(p => p.Amount);

            // Configurable interest and minimum payment percentages
            decimal interestRate = 0.25M;  // 25%
            decimal minimumPaymentRate = 0.05M;  // 5%

            var BonificableInterest = creditCard.CurrentBalance * interestRate;
            var AvailableBalance = creditCard.CreditLimit - creditCard.CurrentBalance;
            var MinimumPayment = creditCard.CurrentBalance * minimumPaymentRate;

            var statement = new
            {
                creditCard.FirstName,
                creditCard.LastName,
                creditCard.CardNumber,
                creditCard.CurrentBalance,
                creditCard.CreditLimit,
                AvailableBalance= AvailableBalance,
                BonificableInterest= BonificableInterest,
                MinimumPayment= MinimumPayment,
                Purchases = purchases,
                currentMonthTotal= currentMonthPurchases,
                previousMonthTotal= previousMonthPurchases,
            };

            return Ok(statement);
        }
    }
}

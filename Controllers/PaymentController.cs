using CreditCardAPI.Data;
using CreditCardAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace CreditCardAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PaymentController : ControllerBase
    {
        private readonly CreditCardDbContext _context;

        public PaymentController(CreditCardDbContext context)
        {
            _context = context;
        }

        [HttpPost]
        public async Task<ActionResult<Payment>> PostPayment(Payment payment)
        {
            _context.Payments.Add(payment);
            await _context.SaveChangesAsync();

            // Actualizar el saldo de la tarjeta de crédito
            var creditCard = await _context.CreditCards.FindAsync(payment.CreditCardId);
            if (creditCard != null)
            {
                creditCard.CurrentBalance -= payment.Amount;
                await _context.SaveChangesAsync();
            }

            return CreatedAtAction(nameof(PostPayment), new { id = payment.PaymentId }, payment);
        }
    }
}

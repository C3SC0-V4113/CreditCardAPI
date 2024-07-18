using CreditCardAPI.Data;
using CreditCardAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace CreditCardAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PurchaseController:ControllerBase
    {
        private readonly CreditCardDbContext _context;

        public PurchaseController(CreditCardDbContext context)
        {
            _context = context;
        }

        [HttpPost]
        public async Task<ActionResult<Purchase>> PostPurchase(Purchase purchase)
        {
            _context.Purchases.Add(purchase);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(PostPurchase), new { id = purchase.PurchaseId }, purchase);
        }
    }
}

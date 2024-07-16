namespace CreditCardAPI.Models
{
    public class TransactionDto
    {
        public DateTime TransactionDate { get; set; }
        public string Description { get; set; }
        public decimal Amount { get; set; }
        public string TransactionType { get; set; } // "Purchase" or "Payment"
    }
}

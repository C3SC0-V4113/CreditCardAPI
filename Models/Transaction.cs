namespace CreditCardAPI.Models
{
    public class Transaction
    {
        public int TransactionId { get; set; }
        public int CreditCardId { get; set; }
        public DateTime TransactionDate { get; set; }
        public string Description { get; set; }
        public decimal Amount { get; set; }
        public string TransactionType { get; set; } // "Purchase" or "Payment"
        public CreditCard CreditCard { get; set; }
    }
}

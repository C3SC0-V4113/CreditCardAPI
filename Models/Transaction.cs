namespace CreditCardAPI.Models
{
    public class Transaction
    {
        public DateTime TransactionDate { get; set; }
        public string Description { get; set; }
        public decimal? Charge { get; set; }
        public decimal? Credit { get; set; }
    }
}

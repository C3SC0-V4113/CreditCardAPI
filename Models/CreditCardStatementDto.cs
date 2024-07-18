namespace CreditCardAPI.Models
{
    public class CreditCardStatementDto
    {
        public int CreditCardId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string CardNumber { get; set; }
        public decimal CurrentBalance { get; set; }
        public decimal CreditLimit { get; set; }
        public decimal AvailableBalance { get; set; }
        public List<Purchase> Purchases { get; set; }
        public decimal TotalCurrentMonth { get; set; }
        public decimal TotalPreviousMonth { get; set; }
        public decimal InterestRate { get; set; }
        public decimal MinimumPaymentRate { get; set; }
    }
}

namespace CreditCardAPI.Models
{
    public class CreditCardStatementDto
    {
        public string CardHolderName { get; set; }
        public string CardNumber { get; set; }
        public decimal CurrentBalance { get; set; }
        public decimal CreditLimit { get; set; }
        public decimal AvailableBalance { get; set; }
        public IEnumerable<TransactionDto> Transactions { get; set; }
        public decimal TotalPurchasesThisMonth { get; set; }
        public decimal TotalPurchasesLastMonth { get; set; }
        public decimal BonifiableInterest { get; set; }
        public decimal MinimumPayment { get; set; }
        public decimal TotalPayment { get; set; }
        public decimal FullPaymentWithInterest { get; set; }
    }
}

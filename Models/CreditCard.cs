namespace CreditCardAPI.Models
{
    public class CreditCard
    {
        public int CreditCardId { get; set; }
        public int CardHolderId { get; set; }
        public string CardNumber { get; set; }
        public decimal CreditLimit { get; set; }
        public decimal CurrentBalance { get; set; }
        public decimal AvailableBalance => CreditLimit - CurrentBalance;
        public CardHolder CardHolder { get; set; }
        public List<Transaction> Transactions { get; set; }
    }
}

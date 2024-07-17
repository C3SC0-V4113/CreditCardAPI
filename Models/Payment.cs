namespace CreditCardAPI.Models
{
    public class Payment
    {
        public int PaymentId { get; set; }
        public int CreditCardId { get; set; }
        public DateTime PaymentDate { get; set; }
        public decimal Amount { get; set; }

        public CreditCard CreditCard { get; set; }
    }
}

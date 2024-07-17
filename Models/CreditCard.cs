namespace CreditCardAPI.Models
{
    public class CreditCard
    {
        public int CreditCardId { get; set; }
        public string CardNumber { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public decimal CurrentBalance { get; set; }
        public decimal CreditLimit { get; set; }
    }
}

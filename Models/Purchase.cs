namespace CreditCardAPI.Models
{
    public class Purchase
    {
        public int PurchaseId { get; set; }
        public int CreditCardId { get; set; }
        public DateTime PurchaseDate { get; set; }
        public string Description { get; set; }
        public decimal Amount { get; set; }
    }
}

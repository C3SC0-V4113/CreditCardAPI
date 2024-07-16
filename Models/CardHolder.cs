namespace CreditCardAPI.Models
{
    public class CardHolder
    {
        public int CardHolderId { get; set; }
        public string Name { get; set; }
        public List<CreditCard> CreditCards { get; set; }
    }
}

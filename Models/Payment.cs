using System.ComponentModel.DataAnnotations;

namespace CreditCardAPI.Models
{
    public class Payment
    {
        [Key]
        public int PaymentId { get; set; }
        public int CreditCardId { get; set; }
        public DateTime PaymentDate { get; set; }
        public decimal Amount { get; set; }
    }
}

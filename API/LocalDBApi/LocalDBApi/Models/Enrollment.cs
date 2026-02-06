using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using LocalDBApi.Enums;

namespace LocalDBApi.Models
{
    [Table("enrollments")]
    public class Enrollment
    {
        [Key]
        [Column("id")]
        public long Id { get; set; }

        [Required]
        [Column("user_id")]
        public long UserId { get; set; }

        [Required]
        [Column("course_id")]
        public long CourseId { get; set; }

        [Required]
        [Column("payment_status_id")]
        public int PaymentStatusId { get; set; }

        [Required]
        [Column("enroll_date")]
        public DateTime EnrollDate { get; set; } = DateTime.Now;

        [Required]
        [Column("amount")]
        public decimal Amount { get; set; }

        public virtual Course Course { get; set; }
        public virtual User User { get; set; }
        [NotMapped]
        public PaymentStatusEnum PaymentStatus
        {
            get => (PaymentStatusEnum)PaymentStatusId;
            set => PaymentStatusId = (int)value;
        }
    }
}


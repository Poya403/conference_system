using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using Microsoft.EntityFrameworkCore.Metadata.Internal;

namespace LocalDBApi.Models
{
    public class Reservation
    {
        [Key]
        public long Id { get; set; }

        [Required]
        [Column("cid")]
        public long Cid { get; set; }

        [Required]
        [Column("hid")]
        public long Hid { get; set; }

        [Required]
        [Column("holding_date")]
        public DateTime HoldingDate { get; set; }

        [Required]
        [Column("start_time")]
        public TimeSpan StartTime { get; set; }

        [Required]
        [Column("end_time")]
        public TimeSpan EndTime { get; set; }

        [Required]
        [StringLength(20)]
        [Column("status_type")]
        public string StatusType { get; set; }

        [ForeignKey("Cid")]
        public virtual Course Course { get; set; }

        [ForeignKey("Hid")]
        public virtual Hall Hall { get; set; }
    }
}

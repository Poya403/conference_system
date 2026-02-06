using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LocalDBApi.Models
{
    [Table("Courses")]
    public class Course
    {
        [Key]
        [Column("id")]
        public long Id { get; set; }

        [Required]
        [Column("title")]
        public string Title { get; set; } = null!;

        [Required]
        [Column("crs_type_id")]
        public long CourseTypeId { get; set; }

        [Required]
        [Column("delivery_type")]
        public string DeliveryType { get; set; } = null!;

        [Required]
        [Column("cost")]
        public decimal Cost { get; set; }

        [Column("description")]
        public string? Description { get; set; }

        [Column("contact_phone")]
        public string? ContactPhone { get; set; }

        [Required]
        [Column("uid")]
        public long Uid { get; set; }

        [Column("created_at")]
        public DateTime CreatedAt { get; set; } = DateTime.Now;
        
        [ForeignKey(nameof(CourseTypeId))]
        public virtual CourseTypes CourseType { get; set; } = null!;
    }
}

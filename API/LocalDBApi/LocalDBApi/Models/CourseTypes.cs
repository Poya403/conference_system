using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LocalDBApi.Models
{
    [Table("courses_types")]
    public class CourseTypes
    {
        [Key]
        [Column("type_id")]
        public long Id { get; set; }

        [Required]
        [Column("type_title")]
        public string Title { get; set; } = null!;
    }
}

using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LocalDBApi.Models
{
    [Table("Halls")]
    public class Hall
    {
        [Key]
        [Column("id")]
        public long Id { get; set; }
        
        [Required]
        [Column("title")]
        public string Title { get; set; } = null!;
        
        [Column("description")]
        public string? description { get; set; }

        [Required]
        [Column("capacity")]
        public int Capacity { get; set; }

        [Column("city")]
        public string? City { get; set; }

        [Column("area")]
        public string? Area { get; set; }

        [Column("address")]
        public string? Address { get; set; }

        [Column("img_url")]
        public string? ImageUrl { get; set; }

        // public List<string> Amanities { get; set; }

        [Column("created_at")]
        public DateTime CreatedAt { get; set; } = DateTime.Now;
    }
}

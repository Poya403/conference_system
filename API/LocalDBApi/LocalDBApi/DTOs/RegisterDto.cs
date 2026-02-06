using System.ComponentModel.DataAnnotations;

namespace LocalDBApi.DTOs
{
    public class RegisterDto
    {
        [Required]
        public string FullName { get; set; } = null!;

        [Required]
        [EmailAddress]
        public string Email { get; set; } = null!;

        [Required]
        public string Password { get; set; } = null!;

        public string? Phone { get; set; }
    }
}

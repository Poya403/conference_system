namespace LocalDBApi.DTOs
{
    public class UpdateUserDto
    {
        public string? FullName { get; set; }
        public string? Phone { get; set; }
        public string? Bio { get; set; }
        public string? NewPassword { get; set; }
        public string? OldPassword { get; set; }
    }
}

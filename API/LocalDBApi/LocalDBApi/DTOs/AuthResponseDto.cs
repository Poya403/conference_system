namespace LocalDBApi.DTOs
{
    public class AuthResponseDto
    {
        public bool Success { get; set; }
        public string? Token { get; set; }
        public DateTime? TokenExpiry { get; set; }
        public UserDto? User { get; set; }
        public string? Message { get; set; }
        public List<string>? Errors { get; set; }

        // Factory methods for success responses
        public static AuthResponseDto SuccessResponse(string token, UserDto user, int expireDays,
            string message = "عملیات موفقیت‌آمیز")
        {
            return new AuthResponseDto
            {
                Success = true,
                Token = token,
                TokenExpiry = DateTime.UtcNow.AddDays(expireDays),
                User = user,
                Message = message
            };
        }

        public static AuthResponseDto SuccessResponse(UserDto user, string message = "عملیات موفقیت‌آمیز")
        {
            return new AuthResponseDto
            {
                Success = true,
                User = user,
                Message = message
            };
        }

        // Factory methods for error responses
        public static AuthResponseDto ErrorResponse(string message, List<string>? errors = null)
        {
            return new AuthResponseDto
            {
                Success = false,
                Message = message,
                Errors = errors
            };
        }

        public static AuthResponseDto ValidationErrorResponse(List<string> errors)
        {
            return new AuthResponseDto
            {
                Success = false,
                Message = "خطا در اعتبارسنجی",
                Errors = errors
            };
        }

        // Helper methods
        public bool HasErrors() => Errors != null && Errors.Any();
        public string GetFirstError() => Errors?.FirstOrDefault() ?? Message ?? "خطای نامشخص";
    }

    public class UserDto
    {
        public long Id { get; set; }
        public string FullName { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string Role { get; set; } = null!;
        public string? Phone { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? LastLogin { get; set; }

        public bool IsAdmin => Role?.Equals("Admin", StringComparison.OrdinalIgnoreCase) == true;
        public string DisplayName => !string.IsNullOrEmpty(FullName) ? FullName : Email.Split('@')[0];
    }
}
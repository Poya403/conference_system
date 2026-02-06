namespace LocalDBApi.DTOs
{
    public class EnrollmentDto
    {
        public long Id { get; set; }
        public DateTime EnrollDate { get; set; }
        public string PaymentStatus { get; set; }
        public long CourseId { get; set; }
        public string CourseTitle { get; set; } = string.Empty;
        public string DeliveryType { get; set; } = string.Empty;
        public decimal Cost { get; set; }
        public string? CourseDescription { get; set; }
        public string ContactPhone { get; set; } = string.Empty;

        public long UserId { get; set; }
        public string UserFullName { get; set; } = string.Empty;
        public string UserPhoneNumber { get; set; }

        public long HallId { get; set; }
        public string HallName { get; set;} = string.Empty;
        public string? HallCity { get; set;} = string.Empty;
        public string? HallAddress { get; set;} = string.Empty;
    }
}

using LocalDBApi.Enums;

namespace LocalDBApi.DTOs
{
    public class CourseListDto
    {
        public long Id { get; set; }
        public string Title { get; set; }
        public decimal Cost { get; set; }
        public string DeliveryType { get; set; }

        public long CourseTypeId { get; set; }
        public string CourseTypeTitle { get; set; }
        public string ContactPhone { get; set; }

        public UserCourseStatus UserStatus { get; set; }
    }

}

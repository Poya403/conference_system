namespace LocalDBApi.DTOs
{
    public class CourseFilterDTO
    {
        public int? CourseTypeId { get; set; }
        public string? DeliveryType { get; set; }
        public decimal? MinCost { get; set; }
        public decimal? MaxCost { get; set; }
        public string? Description { get; set; }
        public string? ContactPhone { get; set; }
        public string? CourseTitle { get; set; }
    }

}

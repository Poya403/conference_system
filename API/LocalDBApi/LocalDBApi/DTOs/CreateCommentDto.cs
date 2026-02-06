using LocalDBApi.Enums;

namespace LocalDBApi.DTOs
{
    public class CreateCommentDto
    {
        public string TargetType { get; set; }
        public long TargetId { get; set; }
        public long? ParentId { get; set; }
        public string Text { get; set; } = null!;
        public int? Score { get; set; }
    }

}

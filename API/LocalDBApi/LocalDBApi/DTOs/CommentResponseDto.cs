using LocalDBApi.Models;

namespace LocalDBApi.DTOs
{
    public class CommentUserDto
    {
        public long Id { get; set; }
        public string FullName { get; set; }

        public CommentUserDto() { }

        public CommentUserDto(User user)
        {
            Id = user.Id;
            FullName = user.FullName;
        }
    }
    public class CommentResponseDto
    {
        public long Id { get; set; }
        public string Text { get; set; }
        public int? Score { get; set; }
        public string TargetType { get; set; }
        public long TargetId { get; set; }

        public DateTime CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }

        public CommentUserDto User { get; set; }

        public CommentResponseDto() { }
        public CommentResponseDto(Comment comment)
        {
            Id = comment.Id;
            Text = comment.Text;
            Score = comment.Score;
            TargetType = comment.TargetType.ToString();
            TargetId = comment.TargetId;
            CreatedAt = comment.CreatedAt;
            UpdatedAt = comment.UpdatedAt ?? null;
            User = new CommentUserDto(comment.User);
        }
    }
}

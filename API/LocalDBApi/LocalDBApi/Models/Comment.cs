using LocalDBApi.Enums;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.CompilerServices;

namespace LocalDBApi.Models
{
    public class Comment
    {
        public long Id { get; set; }

        [Column("user_id")]
        public long UserId { get; set; }
        public User User { get; set; }

        [Column("target_type")]
        public CommentTargetType TargetType { get; set; } // course | hall

        [Column("target_id")]
        public long TargetId { get; set; }

        [Column("parent_id")]
        public long? ParentId { get; set; }

        public Comment? Parent { get; set; }

        public ICollection<Comment> Replies { get; set; } = new List<Comment>();

        public string Text { get; set; } = null!;

        public int? Score { get; set; }

        [Column("created_at")]
        public DateTime CreatedAt { get; set; } = DateTime.Now;
        [Column("updated_at")]
        public DateTime? UpdatedAt { get; set; }
}

}

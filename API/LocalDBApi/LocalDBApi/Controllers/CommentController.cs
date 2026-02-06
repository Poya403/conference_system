using LocalDBApi.DTOs;
using LocalDBApi.Enums;
using LocalDBApi.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace LocalDBApi.Controllers
{
    [ApiController]
    [Route("api/v1/comments")]
    public class CommentController : ControllerBase
    {
        private readonly APPDbContext _context;

        public CommentController(APPDbContext context)
        {
            _context = context;
        }


        [HttpGet]
        public async Task<IActionResult> GetComments(CommentTargetType targetType,long targetId)
        {
            var comments = await _context.Comments
            .Where(c => c.TargetType == targetType
                     && c.TargetId == targetId
                     && c.ParentId == null)
            .Include(c => c.User)
            .OrderByDescending(c => c.CreatedAt)
            .Select(c => new CommentResponseDto(c))
            .ToListAsync();


            return Ok(comments);
        }



        [Authorize]
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] CreateCommentDto dto)
        {
            if (!Enum.TryParse<CommentTargetType>(dto.TargetType, out var targetType))
                return BadRequest("Invalid target type");

            var comment = new Comment
            {
                UserId = User.GetUserId(),
                TargetType = targetType,
                TargetId = dto.TargetId,
                ParentId = dto.ParentId,
                Text = dto.Text,
                Score = dto.ParentId == null ? dto.Score : null
            };

            _context.Comments.Add(comment);
            await _context.SaveChangesAsync();

            return Ok(comment);
        }

        [Authorize]
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(long id, [FromBody] CreateCommentDto dto)
        {
            var userId = User.GetUserId();

            var comment = await _context.Comments.FindAsync(id);
            if (comment == null)
                return NotFound(
                   new{
                       success = false,
                       message = "کامنت مورد نظر یافت نشد."
                   });

            if (!Enum.TryParse<CommentTargetType>(dto.TargetType, out var targetType))
                return BadRequest("Invalid target type");

            if (comment.UserId != userId)
                return Forbid();

            comment.Text = dto.Text;
            comment.Score = dto.Score;
            comment.UpdatedAt = DateTime.Now;

            await _context.SaveChangesAsync();
            return Ok(comment);
        }

        [Authorize]
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(long id)
        {
            var userId = User.GetUserId();
            var comment = await _context.Comments
               .Include(c => c.Replies)
               .FirstOrDefaultAsync(c => c.Id == id);


            if (comment == null)
                return NotFound(new {
                    success = false,
                    message = "کامنت مورد نظر یافت نشد."
                });

            if (comment.UserId != userId)
                return Forbid();

            if (comment.Replies.Any())
            {
                _context.Comments.RemoveRange(comment.Replies);
            }

            _context.Comments.Remove(comment);
            await _context.SaveChangesAsync();

            return Ok(new { success = true, message = "کامنت حذف شد." });
        }
    }
    
}

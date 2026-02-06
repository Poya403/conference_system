using LocalDBApi.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Mvc;
using LocalDBApi.DTOs;

namespace LocalDBApi.Controllers
{
    [Route("api/v1/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly APPDbContext _context;

        public UsersController(APPDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<IActionResult> GetUsers()
        {
            var users = await _context.Users.ToListAsync();
            return Ok(users);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetUserById(long id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null) return NotFound();
            return Ok(user);
        }

        [HttpPost]
        public async Task<IActionResult> CreateUser([FromBody] User user)
        {
            // بررسی ایمیل تکراری
            if (await _context.Users.AnyAsync(u => u.Email == user.Email))
                return BadRequest("این ایمیل قبلاً ثبت شده است.");

            _context.Users.Add(user);
            await _context.SaveChangesAsync();
            return Ok(user);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateUser(long id, [FromBody] UpdateUserDto dto)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null)
                return NotFound();

            if (!string.IsNullOrWhiteSpace(dto.FullName))
                user.FullName = dto.FullName;

            if (!string.IsNullOrWhiteSpace(dto.Phone))
                user.Phone = dto.Phone;

            if (!string.IsNullOrWhiteSpace(dto.Bio))
                user.Bio = dto.Bio;

            bool passwordChanged = false;
            bool passwordError = false;

            if (!string.IsNullOrWhiteSpace(dto.OldPassword) &&
                !string.IsNullOrWhiteSpace(dto.NewPassword))
            {
                var isOldPasswordCorrect =
                    BCrypt.Net.BCrypt.Verify(dto.OldPassword, user.PasswordHash);

                if (isOldPasswordCorrect)
                {
                    user.PasswordHash =
                        BCrypt.Net.BCrypt.HashPassword(dto.NewPassword);
                    passwordChanged = true;
                }
                else
                {
                    passwordError = true;
                }
            }

            await _context.SaveChangesAsync();

            return Ok(new
            {
                success = true,
                passwordChanged,
                passwordError,
                message = passwordChanged
                    ? "اطلاعات و رمز عبور با موفقیت بروزرسانی شد"
                    : passwordError
                        ? "خطا در ویرایش رمز عبور"
                        : "اطلاعات با موفقیت بروزرسانی شد"
            });
        }



        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUser(long id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null) return NotFound();

            _context.Users.Remove(user);
            await _context.SaveChangesAsync();
            return Ok();
        }
    }
}

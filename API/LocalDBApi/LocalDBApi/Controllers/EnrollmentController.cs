using LocalDBApi.DTOs;
using LocalDBApi.Enums;
using LocalDBApi.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace LocalDBApi.Controllers
{
    [Route("api/v1/[controller]")]
    [ApiController]
    public class EnrollmentController : ControllerBase
    {
        private readonly APPDbContext _context;

        public EnrollmentController(APPDbContext context)
        {
            _context = context;
        }

        [HttpPost("add-to-basket")]
        public async Task<IActionResult> AddToBasket(long uid, long cid)
        {
            try
            {
                var course = await _context.Courses.FindAsync(cid);
                if (course == null)
                    return NotFound(new
                    {
                        success = false,
                        message = "دوره یافت نشد."
                    });

                var enrollment = await _context.Enrollments
                    .FirstOrDefaultAsync(e => e.UserId == uid && e.CourseId == cid);

                string message;

                if (enrollment != null)
                {
                    if (enrollment.PaymentStatus != PaymentStatusEnum.InBasket)
                    {
                        enrollment.PaymentStatus = PaymentStatusEnum.InBasket;
                        message = "دوره به سبد خرید اضافه شد";
                    }
                    else
                    {
                        message = "دوره قبلاً در سبد خرید شماست";
                    }
                }
                else
                {
                    var newEnrollment = new Enrollment
                    {
                        UserId = uid,
                        CourseId = cid,
                        EnrollDate = DateTime.UtcNow,
                        PaymentStatus = PaymentStatusEnum.InBasket,
                    };
                    _context.Enrollments.Add(newEnrollment);
                    message = "دوره به سبد خرید اضافه شد";
                }

                await _context.SaveChangesAsync();

                return Ok(new
                {
                    success = true,
                    message = message
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    success = false,
                    message = "خطای سرور"
                });
            }
        }

        [HttpDelete("remove-from-basket")]
        public async Task<IActionResult> RemoveFromBasket(long uid, long cid)
        {
            try
            {
                var enrollment = await _context.Enrollments
                    .FirstOrDefaultAsync(e => e.UserId == uid && e.CourseId == cid);

                if (enrollment == null)
                    return NotFound(new
                    {
                        success = false,
                        message = "رکوردی یافت نشد."
                    });

                if (enrollment.PaymentStatus != PaymentStatusEnum.InBasket)
                {
                    return BadRequest(new
                    {
                        success = false,
                        message = "این دوره در سبد خرید شما نیست"
                    });
                }

                enrollment.PaymentStatus = PaymentStatusEnum.Cancelled;
                await _context.SaveChangesAsync();

                return Ok(new
                {
                    success = true,
                    message = "دوره از سبد خرید حذف شد"
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    success = false,
                    message = "خطای سرور"
                });
            }
        }

        [HttpGet("{courseId}")]
        public async Task<ActionResult<IEnumerable<EnrollmentDto>>> GetEnrollmentByCourse(long courseId)
        {
            var enrollments = await _context.Enrollments
                .Include(e => e.Course)
                .Include(e => e.User)
                .Where(e => e.PaymentStatusId != (int)PaymentStatusEnum.Cancelled)
                .Where(e => e.CourseId == courseId)
                .Select(e => new EnrollmentDto
                {
                    Id = e.Id,
                    EnrollDate = e.EnrollDate,
                    PaymentStatus = e.PaymentStatus.ToText(),
                    CourseId = e.Course.Id,
                    CourseTitle = e.Course.Title,
                    DeliveryType = e.Course.DeliveryType,
                    Cost = e.Course.Cost,
                    ContactPhone = e.Course.ContactPhone ?? string.Empty,
                    UserId = e.User.Id,
                    UserFullName = e.User.FullName,
                    UserPhoneNumber = e.User.Phone ?? "ثبت نشده",
                })
                .ToListAsync();

            return Ok(enrollments);
        }

        [HttpPost("finalize")]
        public async Task<IActionResult> FinalizeSingleEnrollment([FromBody] FinalizeEnrollmentDto request)
        {

            var enrollment = await _context.Enrollments
                .Include(e => e.Course)
                .FirstOrDefaultAsync(e =>
                    e.UserId == request.UserId &&
                    e.CourseId == request.CourseId &&
                    e.PaymentStatusId == (int)PaymentStatusEnum.InBasket
                );

            if (enrollment == null)
            {
                return BadRequest(new
                {
                    success = false,
                    message = "این دوره در سبد خرید شما نیست یا قبلاً ثبت‌نام شده است"
                });
            }

            enrollment.PaymentStatus = PaymentStatusEnum.Registered;
            enrollment.Amount = enrollment.Course.Cost;
            enrollment.EnrollDate = DateTime.Now;

            await _context.SaveChangesAsync();

            return Ok(new
            {
                success = true,
                message = "ثبت‌نام نهایی دوره با موفقیت انجام شد"
            });
        }
          
    }
}

using LocalDBApi.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Mvc;
using LocalDBApi.Enums;
using static LocalDBApi.DTOs.CourseListDto;
using LocalDBApi.DTOs;

namespace LocalDBApi.Controllers
{
    [Route("api/v1/[controller]")]
    [ApiController]
    public class CoursesController : ControllerBase
    {
        private readonly APPDbContext _context;

        public CoursesController(APPDbContext context)
        {
            _context = context;
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Course>> GetCourse(long id)
        {
            var course = await _context.Courses
                .Include(c => c.CourseType)
                .FirstOrDefaultAsync(c => c.Id == id);

            if (course == null)
            {
                return NotFound();
            }

            return course;
        }

        [HttpGet("list")]
        public async Task<IActionResult> GetCoursesList(
            long uid,
            CourseCategory category,
            [FromQuery] CourseFilterDTO? filter)
        {
            IQueryable<Course> coursesQuery;

            // دسته‌بندی‌ها
            switch (category)
            {
                case CourseCategory.MyCourses:
                    coursesQuery = _context.Courses
                        .Include(c => c.CourseType)
                        .Where(c => c.Uid == uid);
                    break;

                case CourseCategory.RegisteredCourses:
                    coursesQuery = _context.Enrollments
                        .Include(e => e.Course)
                        .ThenInclude(c => c.CourseType)
                        .Where(e => e.UserId == uid && e.PaymentStatusId == (int)PaymentStatusEnum.Registered)
                        .Select(e => e.Course);
                    break;

                case CourseCategory.InBasketCourses:
                    coursesQuery = _context.Enrollments
                        .Include(e => e.Course)
                        .ThenInclude(c => c.CourseType)
                        .Where(e => e.UserId == uid && e.PaymentStatusId == (int)PaymentStatusEnum.InBasket)
                        .Select(e => e.Course);
                    break;

                case CourseCategory.WaitingCourses:
                    coursesQuery = _context.Enrollments
                        .Include(e => e.Course)
                        .ThenInclude(c => c.CourseType)
                        .Where(e => e.UserId == uid && e.PaymentStatusId == (int)PaymentStatusEnum.InWaiting)
                        .Select(e => e.Course);
                    break;

                case CourseCategory.AvailableCourses:
                    var blockedStatuses = new[]
                    {
                    (int)PaymentStatusEnum.Registered,
                    (int)PaymentStatusEnum.InWaiting
                };

                    coursesQuery = _context.Courses
                        .Include(c => c.CourseType)
                        .Where(c =>
                            c.Uid != uid &&
                            !_context.Enrollments.Any(e =>
                                e.CourseId == c.Id &&
                                e.UserId == uid &&
                                blockedStatuses.Contains(e.PaymentStatusId)
                            )
                        );
                    break;

                default:
                    return BadRequest("دسته‌بندی نامعتبر است.");
            }

            // اعمال فیلتر از DTO
            if (filter != null)
            {
                if (filter.CourseTypeId.HasValue)
                    coursesQuery = coursesQuery.Where(c => c.CourseTypeId == filter.CourseTypeId.Value);

                if (!string.IsNullOrEmpty(filter.DeliveryType))
                    coursesQuery = coursesQuery.Where(c => c.DeliveryType.Contains(filter.DeliveryType));

                if (filter.MinCost.HasValue)
                    coursesQuery = coursesQuery.Where(c => c.Cost >= filter.MinCost.Value);

                if (filter.MaxCost.HasValue)
                    coursesQuery = coursesQuery.Where(c => c.Cost <= filter.MaxCost.Value);

                if (!string.IsNullOrEmpty(filter.Description))
                    coursesQuery = coursesQuery.Where(c => c.Description != null && c.Description.Contains(filter.Description));

                if (!string.IsNullOrEmpty(filter.ContactPhone))
                    coursesQuery = coursesQuery.Where(c => c.ContactPhone.Contains(filter.ContactPhone));

                if (!string.IsNullOrEmpty(filter.CourseTitle))
                    coursesQuery = coursesQuery.Where(c => c.Title.Contains(filter.CourseTitle));
            }

            var coursesList = await coursesQuery.ToListAsync();

            // تبدیل به DTO خروجی همراه با وضعیت سبد خرید
            var coursesDto = coursesList.Select(c => new
            {
                c.Id,
                c.Title,
                c.Cost,
                DeliveryType = c.DeliveryType ?? "",
                CourseTypeId = c.CourseType?.Id ?? 0,
                CourseTypeTitle = c.CourseType?.Title ?? "",
                ContactPhone = c.ContactPhone ?? "",
                UserStatus = _context.Enrollments
                    .Where(e => e.CourseId == c.Id && e.UserId == uid)
                    .Select(e => e.PaymentStatusId == (int)PaymentStatusEnum.InBasket ? "InBasket"
                                  : e.PaymentStatusId == (int)PaymentStatusEnum.Registered ? "Registered"
                                  : e.PaymentStatusId == (int)PaymentStatusEnum.InWaiting ? "InWaiting"
                                  : "Available")
                    .FirstOrDefault() ?? "Available"
            }).ToList();

            return Ok(coursesDto);
        }
    }
}


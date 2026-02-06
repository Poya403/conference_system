using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

namespace LocalDBApi.Controllers
{
    [Route("api/v1/[controller]")]
    [ApiController]
    public class ReservationController : ControllerBase
    {
        private readonly APPDbContext _context;
        
        public ReservationController(APPDbContext context) { 
            _context = context;
        }

        [HttpGet("api/v1/halls/{hallId}/reservations")]
        public async Task<IActionResult> GetReservationsByHall(int hallId)
        {
            var reservations = await _context.Reservations
                .Where(r => r.Hid == hallId)
                .OrderBy(r => r.HoldingDate)
                .ThenBy(r => r.StartTime)
                .Select(r => new
                {
                    r.Id,
                    r.Cid,
                    r.Hid,
                    r.HoldingDate,
                    r.StartTime,
                    r.EndTime,
                    r.StatusType,
                    CourseName = r.Course.Title
                })
                .ToListAsync();

            return Ok(reservations);
        }

    }
}

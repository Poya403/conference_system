using Microsoft.EntityFrameworkCore;
using LocalDBApi.Models;
using LocalDBApi.Enums;

namespace LocalDBApi
{
    public class APPDbContext : DbContext
    {
        public APPDbContext(DbContextOptions<APPDbContext> options)
        : base(options) { }

        public DbSet<User> Users { get; set; }
        public DbSet<Hall> Halls { get; set; }
        public DbSet<Course> Courses { get; set; }
        public DbSet<CourseTypes> CourseTypes { get; set; }
        public DbSet<Enrollment> Enrollments { get; set; }
        public DbSet<Reservation> Reservations { get; set; }
        public DbSet<Comment> Comments { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.Entity<Comment>()
                .Property(c => c.TargetType)
                .HasConversion(
                    v => v.ToString(), // Enum → string
                    v => (CommentTargetType)Enum.Parse(typeof(CommentTargetType), v) // string → Enum
                );

            modelBuilder.Entity<Comment>()
            .HasOne(c => c.User)
            .WithMany()
            .HasForeignKey(c => c.UserId)
            .OnDelete(DeleteBehavior.Restrict);

        }
    }
}

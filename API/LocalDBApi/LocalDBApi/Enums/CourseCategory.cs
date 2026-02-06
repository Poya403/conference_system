using System.ComponentModel.DataAnnotations;

namespace LocalDBApi.Enums
{
    public enum CourseCategory
    {
        [Display(Name = "دوره‌های من")]
        MyCourses,

        [Display(Name = "ثبت‌نام‌شده")]
        RegisteredCourses,

        [Display(Name = "سبد خرید")]
        InBasketCourses,

        [Display(Name = "در انتظار")]
        WaitingCourses,

        [Display(Name = "دوره‌های در دسترس")]
        AvailableCourses
    }

}

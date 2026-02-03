enum CourseCategory {
  myCourses,
  registeredCourses,
  inBasketCourses,
  waitingCourses,
  availableCourses,
}

extension CourseCategoryExtension on CourseCategory {
  String get apiValue {
    switch (this) {
      case CourseCategory.myCourses:
        return 'MyCourses';
      case CourseCategory.registeredCourses:
        return 'RegisteredCourses';
      case CourseCategory.inBasketCourses:
        return 'InBasketCourses';
      case CourseCategory.waitingCourses:
        return 'WaitingCourses';
      case CourseCategory.availableCourses:
        return 'AvailableCourses';
    }
  }

  String get title {
    switch (this) {
      case CourseCategory.myCourses:
        return 'دوره‌های من';
      case CourseCategory.registeredCourses:
        return 'ثبت‌نام‌شده';
      case CourseCategory.inBasketCourses:
        return 'سبد خرید';
      case CourseCategory.waitingCourses:
        return 'در انتظار';
      case CourseCategory.availableCourses:
        return 'دوره‌ها';
    }
  }
}

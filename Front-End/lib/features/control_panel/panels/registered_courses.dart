import 'package:conference_system/enums/course_category.dart';
import 'package:conference_system/features/course_panels/courses_list_screen.dart';
import 'package:flutter/material.dart';

class RegisteredCourses extends StatefulWidget {
  const RegisteredCourses({super.key});

  @override
  State<RegisteredCourses> createState() => _RegisteredCoursesState();
}

class _RegisteredCoursesState extends State<RegisteredCourses> {
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CoursesListScreen(category: CourseCategory.registeredCourses);
  }
}

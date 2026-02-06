import 'package:conference_system/enums/course_category.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/features/course_panel/courses_list_screen.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CoursesListScreen(category: CourseCategory.myCourses);
  }
}



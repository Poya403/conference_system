import 'package:conference_system/enums/course_category.dart';
import 'package:conference_system/features/course_panels/courses_list_screen.dart';
import 'package:flutter/material.dart';

class WaitingList extends StatefulWidget {
  const WaitingList({super.key});

  @override
  State<WaitingList> createState() => _WaitingListState();
}

class _WaitingListState extends State<WaitingList> {
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CoursesListScreen(category: CourseCategory.waitingCourses);
  }
}

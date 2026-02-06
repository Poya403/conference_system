import 'package:conference_system/enums/course_category.dart';
import 'package:conference_system/features/course_panel/courses_list_screen.dart';
import 'package:flutter/material.dart';

class ShoppingBasket extends StatefulWidget {
  const ShoppingBasket({super.key});

  @override
  State<ShoppingBasket> createState() => _ShoppingBasketState();
}

class _ShoppingBasketState extends State<ShoppingBasket> {
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CoursesListScreen(category: CourseCategory.inBasketCourses);
  }
}

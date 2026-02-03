import 'package:conference_system/enums/course_category.dart';
import 'package:conference_system/features/about_us_page/about_us_screen.dart';
import 'package:conference_system/main_wrapper.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:flutter/material.dart';
import '../hall_panel/hall_list_screen.dart';
import 'package:conference_system/bloc/auth/auth_bloc.dart';
import 'package:conference_system/bloc/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conference_system/bloc/courses/courses_bloc.dart';
import 'package:conference_system/bloc/courses/courses_event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int userId;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;

    if (authState is AuthSuccess) {
      userId = authState.authResponse.userId ?? 0;

      context.read<CourseBloc>().add(
        GetCoursesList(userId, CourseCategory.availableCourses),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // bool isDesktop = MediaQuery.of(context).size.width > 700;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              spacing: 20,
              children: [
                SizedBox(height: 30),
                AboutContainerWide(),
                Text(
                  AppTexts.hall,
                  style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.w500,
                    fontSize: 35,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: HallList(limit: 4),
                ),
                ShowMoreButton(currentPageType: PageType.halls),
                Text(
                  AppTexts.courses,
                  style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.w500,
                    fontSize: 35,
                  ),
                ),
                ShowMoreButton(currentPageType: PageType.courses),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShowMoreButton extends StatelessWidget {
  const ShowMoreButton({super.key, required this.currentPageType});

  final PageType currentPageType;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => MainWrapper(page: currentPageType),
            transitionDuration: Duration.zero,
          ),
        );
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
      child: Text(AppTexts.showAll, style: TextStyle(color: Colors.white)),
    );
  }
}

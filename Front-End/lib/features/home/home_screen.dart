import 'package:conference_system/features/about_us_page/about_us_screen.dart';
import 'package:conference_system/features/courses_list/courses_list_screen.dart';
import 'package:conference_system/main_wrapper.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/features/hall_panel/hall_screen.dart';
import 'package:conference_system/server/services/courses_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final coursesService = CoursesService();
  List<Map<String, dynamic>> allCourses = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    setState(() => loading = true);
    final result = await coursesService.getCoursesList();

    setState(() {
      allCourses = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 700;
    return Scaffold(
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                SizedBox(height: 30),
                Expanded(
                  child: isDesktop
                      ? Wide(courses: allCourses)
                      : Narrow(courses: allCourses),
                ),
              ],
            ),
    );
  }
}

class Wide extends StatelessWidget {
  const Wide({
    required this.courses,
    super.key
  });
  final List<Map<String, dynamic>> courses;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            AboutContainerWide(),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    AppTexts.hall,
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.w500,
                      fontSize: 35,
                    ),
                  ),
                  SizedBox(height: 30),
                  HallList(limit: 4),
                  SizedBox(height: 50),
                  ShowMoreButton(currentPageType: PageType.halls),
                  SizedBox(height: 50),
                  Text(
                    AppTexts.courses,
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.w500,
                      fontSize: 35,
                    ),
                  ),
                  CoursesList(limit: 4, courses: courses),
                  SizedBox(height: 50),
                  ShowMoreButton(currentPageType: PageType.courses),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Narrow extends StatelessWidget {
  const Narrow({super.key, required this.courses});

  final List<Map<String,dynamic>> courses;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            AboutContainerNarrow(),
            SizedBox(height: 23),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    AppTexts.hall,
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.w500,
                      fontSize: 35,
                    ),
                  ),
                  SizedBox(height: 30),
                  HallList(limit: 4),
                  SizedBox(height: 50),
                  ShowMoreButton(currentPageType: PageType.halls),
                  SizedBox(height: 50),
                  Text(
                    AppTexts.courses,
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.w500,
                      fontSize: 35,
                    ),
                  ),
                  CoursesList(limit: 4, courses: courses),
                  SizedBox(height: 50),
                  ShowMoreButton(currentPageType: PageType.courses),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShowMoreButton extends StatelessWidget {
  const ShowMoreButton({super.key,required this.currentPageType});
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

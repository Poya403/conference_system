import 'package:conference_system/enums/course_category.dart';
import 'package:conference_system/features/control_panel/control_screen.dart';
import 'package:conference_system/features/course_panel/courses_list_screen.dart';
import 'package:conference_system/features/hall_panel/hall_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/features/home/home_screen.dart';
import 'package:conference_system/features/about_us_page/about_us_screen.dart';
import 'package:conference_system/widgets/button_navigator.dart';
import 'package:conference_system/widgets/appbars/desktop_appbar.dart';
import 'package:conference_system/widgets/appbars/mobile_appbar.dart';
import 'package:conference_system/utils/app_texts.dart';

class MainWrapper extends StatefulWidget {
  final PageType page;

  const MainWrapper({super.key, required this.page});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  late PageType selectedPage;

  @override
  void initState() {
    super.initState();
    selectedPage = widget.page;
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedPage = PageType.values[index];
    });
  }

  String get currentTitle {
    switch (selectedPage) {
      case PageType.home:
        return AppTexts.home;
      case PageType.halls:
        return AppTexts.hall;
      case PageType.courses:
        return AppTexts.courses;
      case PageType.aboutUs:
        return AppTexts.aboutUs;
      case PageType.controlPanel:
        return AppTexts.controlPanel;
    }
  }

  Widget get currentBody {
    switch (selectedPage) {
      case PageType.home:
        return const HomeScreen();
      case PageType.halls:
        return const HallListScreen();
      case PageType.courses:
        return const CoursesListScreen(
            category: CourseCategory.availableCourses);
      case PageType.aboutUs:
        return const AboutUsScreen();
      case PageType.controlPanel:
        return const ControlScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: isDesktop
          ? DesktopAppBar(
        title: currentTitle,
        selectedIndex: selectedPage.index,
        onItemSelected: _onItemTapped,
      )
          : MobileAppBar(title: currentTitle),

      body: currentBody,

      bottomNavigationBar: isDesktop
          ? null
          : ButtonNavigator(
        selectedIndex: selectedPage.index,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

enum PageType { controlPanel, aboutUs, courses, halls, home }

import 'package:flutter/material.dart';
import 'package:conference_system/features/home_page/home_screen.dart';
import 'package:conference_system/features/conference_panel/conference_screen.dart';
import 'package:conference_system/features/courses_list/courses_list_screen.dart';
import 'package:conference_system/features/about_us_page/about_us_screen.dart';
import 'package:conference_system/widgets/button_navigator.dart';
import 'package:conference_system/widgets/desktop_appbar.dart';
import 'package:conference_system/widgets/mobile_appbar.dart';
import 'package:conference_system/utils/app_texts.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  PageType selectedPage = PageType.home;

  void _onItemTapped(int index) {
    setState(() {
      selectedPage = PageType.values[index];
    });
  }

  String get currentTitle {
    switch (selectedPage) {
      case PageType.home:
        return AppTexts.home;
      case PageType.hall:
        return AppTexts.hall;
      case PageType.courses:
        return AppTexts.courses;
      case PageType.aboutUs:
        return AppTexts.aboutUs;
    }
  }

  Widget get currentBody {
    switch (selectedPage) {
      case PageType.home:
        return const HomeScreen();
      case PageType.hall:
        return const ConferenceScreen();
      case PageType.courses:
        return const CoursesListScreen();
      case PageType.aboutUs:
        return const AboutUsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    int selectedIndex = selectedPage.index;
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
        selectedIndex: selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

enum PageType { aboutUs, courses, hall, home }
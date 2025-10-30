import 'package:flutter/material.dart';
import 'package:conference_system/features/home/home_screen.dart';
import 'package:conference_system/features/conference_panel/conference_screen.dart';
import 'package:conference_system/features/courses_list/courses_list_screen.dart';
import 'package:conference_system/features/about_us_page/about_us_screen.dart';
import 'package:conference_system/widgets/button_navigator.dart';
import 'package:conference_system/widgets/desktop_appbar.dart';
import 'package:conference_system/widgets/mobile_appbar.dart';
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
      Widget targetPage;
      switch (selectedPage) {
        case PageType.home:
          targetPage = const MainWrapper(page: PageType.home);
          break;
        case PageType.halls:
          targetPage = const MainWrapper(page: PageType.halls);
          break;
        case PageType.courses:
          targetPage = const MainWrapper(page: PageType.courses);
          break;
        case PageType.aboutUs:
          targetPage = const MainWrapper(page: PageType.aboutUs);
          break;
      }
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => targetPage,
          transitionDuration: Duration.zero,
        ),
      );
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
    }
  }

  Widget get currentBody {
    switch (selectedPage) {
      case PageType.home:
        return const HomeScreen();
      case PageType.halls:
        return const HallScreen();
      case PageType.courses:
        return const CoursesListScreen();
      case PageType.aboutUs:
        return const AboutUsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
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

enum PageType { aboutUs, courses, halls, home }

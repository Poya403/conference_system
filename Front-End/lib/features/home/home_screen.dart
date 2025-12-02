import 'package:conference_system/features/about_us_page/about_us_screen.dart';
import 'package:conference_system/main_wrapper.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/features/hall_panel/hall_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 700;
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: 30),
          Expanded(child: isDesktop ? Wide() : Narrow()),
        ],
      ),
    );
  }
}

class Wide extends StatelessWidget {
  const Wide({super.key});

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
                  ShowMoreButton(),
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
  const Narrow({super.key});

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
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 50),
                  HallList(limit: 4),
                  SizedBox(height: 50),
                  ShowMoreButton(),
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
  const ShowMoreButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => MainWrapper(page: PageType.halls),
            transitionDuration: Duration.zero,
          ),
        );
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
      child: Text(AppTexts.showAll, style: TextStyle(color: Colors.white)),
    );
  }
}

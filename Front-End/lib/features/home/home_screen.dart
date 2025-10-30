import 'package:conference_system/main_wrapper.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/features/conference_panel/conference_screen.dart';

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
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                color: Colors.grey[200],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Image(
                        image: AssetImage('assets/images/hamayesh2.jpg'),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppTexts.aboutUs,
                            style: TextStyle(
                              color: Colors.purple,
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 30),
                          Text(
                            textDirection: TextDirection.rtl,
                            AppTexts.about,
                            style: TextStyle(fontSize: 16, height: 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                  SizedBox(height: 50),
                  HallLists(),
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
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                color: Colors.grey[200],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image(
                          image: AssetImage('assets/images/hamayesh2.jpg'),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppTexts.aboutUs,
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Expanded(
                      child: Text(
                        textDirection: TextDirection.rtl,
                        AppTexts.about,
                        style: TextStyle(fontSize: 15, height: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                  HallLists(),
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
            pageBuilder: (_, __, ___) =>
                MainWrapper(page: PageType.halls),
            transitionDuration: Duration.zero,
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
      ),
      child: Text(
        AppTexts.showAll,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

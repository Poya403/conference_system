import 'package:conference_system/features/control_panel/panels/edit_form.dart';
import 'package:conference_system/features/control_panel/panels/my_courses_page.dart';
import 'package:conference_system/features/control_panel/panels/registered_courses.dart';
import 'package:conference_system/features/control_panel/panels/profile_screen.dart';
import 'package:conference_system/features/control_panel/panels/shopping_basket.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/server/services/auth_service.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  late Widget currentPanel;
  @override
  void initState() {
    super.initState();
    currentPanel = ProfileScreen(editButtonOnPressed: changePanel);
  }

  void changePanel(int index) {
    setState(() {
      switch (index) {
        case 0:
          currentPanel = ProfileScreen(editButtonOnPressed: changePanel);
          break;
        case 1:
          currentPanel = MyCoursesPage();
          break;
        case 2:
          currentPanel = RegisteredCourses();
          break;
        case 3:
          currentPanel = ShoppingBasket();
          break;
        case 5:
          currentPanel = EditForm();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 700;
    return Scaffold(
      body: isDesktop
          ? Wide(currentPanel: currentPanel, onPanelChanged: changePanel)
          : Narrow(currentPanel: currentPanel, onPanelChanged: changePanel),
    );
  }
}

class Wide extends StatelessWidget {
  const Wide({
    super.key,
    required this.currentPanel,
    required this.onPanelChanged,
  });

  final Widget currentPanel;
  final Function(int) onPanelChanged;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.rtl,
          children: [
            SizedBox(
              width: 270,
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  elevation: 4,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.rtl,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 23.0, top: 18.0),
                        child: Text(
                            AppTexts.controlPanel,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                        ),
                      ),
                      SizedBox(height: 10),
                      FormButton(
                        title: AppTexts.userInfo,
                        icon: Icons.person_outline_outlined,
                        onPressed: () => onPanelChanged(0),
                      ),
                      SizedBox(height: 10),
                      FormButton(
                        title: AppTexts.myCourses,
                        icon: Icons.my_library_add_rounded,
                        onPressed: () => onPanelChanged(1),
                      ),
                      SizedBox(height: 10),
                      FormButton(
                        title: AppTexts.registeredCourses,
                        icon: Icons.my_library_books_outlined,
                        onPressed: () => onPanelChanged(2),
                      ),
                      SizedBox(height: 10),
                      FormButton(
                        title: AppTexts.shoppingBasket,
                        icon: Icons.shopping_basket_outlined,
                        onPressed: () => onPanelChanged(3),
                      ),
                      SizedBox(height: 10),
                      FormButton(
                        title: AppTexts.waitingList,
                        icon: Icons.list_alt_outlined,
                      ),
                      SizedBox(height: 10),
                      FormButton(
                        title: AppTexts.logout,
                        icon: Icons.logout,
                        onPressed: () async {
                          await logout(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: currentPanel,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Narrow extends StatelessWidget {
  const Narrow({
    super.key,
    required this.currentPanel,
    required this.onPanelChanged,
  });

  final Widget currentPanel;
  final Function(int) onPanelChanged;

  @override
  Widget build(BuildContext context) {
    final narrowTextStyle = TextStyle(
      color: Colors.blueGrey,
      fontSize: 13,
    );
    final Color iconColor = Colors.blueGrey;
    final double iconSize = 20.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: TextDirection.rtl,
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ExpansionTile(
              title: Text(AppTexts.controlPanel, style: TextStyle(fontSize: 15)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))
              ),
              children: [
                ListTile(
                  leading: Icon(Icons.person_outline, color: iconColor, size: iconSize,),
                  title: Text(AppTexts.userInfo, style: narrowTextStyle,),
                  onTap: () => onPanelChanged(0),
                ),
                ListTile(
                  leading: Icon(Icons.my_library_add_sharp, color: iconColor, size: iconSize,),
                  title: Text(AppTexts.myCourses, style: narrowTextStyle,),
                  onTap: () => onPanelChanged(1),
                ),
                ListTile(
                  leading: Icon(Icons.my_library_books_outlined, color: iconColor, size: iconSize,),
                  title: Text(AppTexts.registeredCourses, style: narrowTextStyle,),
                  onTap: () => onPanelChanged(2),
                ),
                ListTile(
                  leading: Icon(Icons.shopping_basket_outlined, color: iconColor, size: iconSize,),
                  title: Text(AppTexts.shoppingBasket, style: narrowTextStyle,),
                  onTap: () => onPanelChanged(3),
                ),
                ListTile(
                  leading: Icon(Icons.list_alt_outlined, color: iconColor, size: iconSize,),
                  title: Text(AppTexts.waitingList, style: narrowTextStyle,),
                  onTap: () => onPanelChanged(4),
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: iconColor, size: iconSize,),
                  title: Text(AppTexts.logout, style: narrowTextStyle,),
                  onTap: () async {
                    await logout(context);
                  },
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        Expanded(child: Center(child: currentPanel)),
      ],
    );
  }
}

class FormButton extends StatelessWidget {
  const FormButton({
    required this.title,
    required this.icon,
    this.onPressed,
    super.key,
  });

  final String title;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [Icon(icon, size: 23), SizedBox(width: 10), Text(title)],
      ),
    );
  }
}

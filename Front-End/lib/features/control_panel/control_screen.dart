import 'package:conference_system/features/control_panel/panels/profile_screen.dart';
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
    // TODO: implement initState
    super.initState();
    currentPanel = ProfileScreen();
  }

  void changePanel(int index) {
    setState(() {
      switch (index) {
        case 0:
          currentPanel = ProfileScreen();
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
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: [
                SizedBox(
                  width: 300,
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        FormButton(
                          title: AppTexts.userInfo,
                          icon: Icons.person_outline_outlined,
                          onPressed: () => onPanelChanged(0),
                        ),
                        SizedBox(height: 10),
                        FormButton(
                          title: AppTexts.orderHistory,
                          icon: Icons.history_edu_outlined,
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
                SizedBox(width: 20),
                Expanded(child: SizedBox(child: currentPanel)),
              ],
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
    return Column(
      children: [
        Column(children: [Text(AppTexts.userInfo)]),
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
        children: [Icon(icon, size: 27), SizedBox(width: 10), Text(title)],
      ),
    );
  }
}

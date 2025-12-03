import 'package:conference_system/utils/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/server/services/auth_service.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 700;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isDesktop ? Wide() : Narrow(),
    );
  }
}

class Wide extends StatelessWidget {
  const Wide({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.1,
                horizontal: MediaQuery.of(context).size.width * 0.05
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.grey, width: 0.5),
                  ),
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Column(
                    children: [
                      FormButton(
                        title: AppTexts.userInfo,
                        icon: Icons.person_outline_outlined,
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
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.grey, width: 0.5),
                  ),
                  width: MediaQuery.of(context).size.width * 0.55,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Column(
                    children: [

                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Narrow extends StatelessWidget {
  const Narrow({super.key});

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
    super.key
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
        children: [
          Icon(icon,size: 27),
          SizedBox(width: 10),
          Text(title),
        ],
      ),

    );
  }
}


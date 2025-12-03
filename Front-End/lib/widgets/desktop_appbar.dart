import 'package:conference_system/widgets/profile_control.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'dart:ui';


class DesktopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final String title;

  const DesktopAppBar({
    required this.title,
    required this.selectedIndex,
    required this.onItemSelected,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(200);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/hamayesh1.jpg'),
          fit: BoxFit.cover,
        ),
        color: Colors.blueAccent,
      ),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            children: [
              Text(AppTexts.siteName, style: TextStyle(fontSize: 20)),
              SizedBox(height: 30),
              Column(
                children: [
                  const ProfileControl(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    textDirection: TextDirection.rtl,
                    children: [
                      _buildMenuItem(
                        text: AppTexts.home,
                        index: 4,
                        selectedIndex: selectedIndex,
                        onTap: onItemSelected,
                      ),
                      const SizedBox(width: 30),
                      _buildMenuItem(
                        text: AppTexts.hall,
                        index: 3,
                        selectedIndex: selectedIndex,
                        onTap: onItemSelected,
                      ),
                      const SizedBox(width: 30),
                      _buildMenuItem(
                        text: AppTexts.courses,
                        index: 2,
                        selectedIndex: selectedIndex,
                        onTap: onItemSelected,
                      ),
                      const SizedBox(width: 30),
                      _buildMenuItem(
                        text: AppTexts.aboutUs,
                        index: 1,
                        selectedIndex: selectedIndex,
                        onTap: onItemSelected,
                      ),
                      const SizedBox(width: 30),
                      _buildMenuItem(
                        text: '',
                        index: 0,
                        selectedIndex: selectedIndex,
                        onTap: onItemSelected,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildMenuItem({
  required String text,
  required int index,
  required int selectedIndex,
  required ValueChanged<int> onTap,
}) {
  final bool isActive = selectedIndex == index;
  return GestureDetector(
    onTap: () => onTap(index),
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: TextStyle(
          fontSize: 16,
          color: isActive ? Colors.purpleAccent : Colors.white,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
        child: Text(text),
      ),
    ),
  );
}

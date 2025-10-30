import 'package:conference_system/utils/app_texts.dart';
import 'package:flutter/material.dart';

// فایل button_navigator.dart
class ButtonNavigator extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const ButtonNavigator({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      items: [
        BottomNavigationBarItem(
          label: AppTexts.home,
          icon: Icon(Icons.home_outlined),
        ),
        BottomNavigationBarItem(
          label: AppTexts.hall,
          icon: Icon(Icons.library_books_outlined),
        ),
      ],
      selectedItemColor: Colors.purple,
      unselectedItemColor: Colors.grey,
      onTap: onItemTapped,
    );
  }
}

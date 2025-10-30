import 'package:conference_system/widgets/profile_control.dart';
import 'package:flutter/material.dart';

class MobileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MobileAppBar({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/hamayesh1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      actions: [
        const ProfileControl()
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

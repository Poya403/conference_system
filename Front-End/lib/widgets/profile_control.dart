import 'package:flutter/material.dart';
import 'package:conference_system/server/services/auth_service.dart';

class ProfileControl extends StatelessWidget {
  const ProfileControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // عکس پروفایل
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: (){},
              child: CircleAvatar(
                radius: 18,
                backgroundImage: const AssetImage('assets/images/default_avatar.png') as ImageProvider,
              ),
            ),
          ),
          // دکمه خروج
          IconButton(
            onPressed: () async {
              await logout(context);
            },
            icon: const Icon(
                Icons.logout,
                color: Colors.white,
            ),
            tooltip: 'خروج',
          ),
        ],
      ),
    );
  }
}

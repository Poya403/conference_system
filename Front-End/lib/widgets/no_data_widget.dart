import 'package:flutter/material.dart';
import 'package:conference_system/utils/app_texts.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 12),
          Text(
            AppTexts.noData,
            style: TextStyle(color: Colors.grey,fontSize: 17),
          ),
        ],
      ),
    );
  }
}

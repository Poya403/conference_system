import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    super.key,
    required this.caption,
    required this.icon,
    this.width
  });

  final String caption;
  final IconData icon;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 150,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        textDirection: TextDirection.rtl,
        spacing: 3,
        children: <Widget>[
          Icon(
            icon,
            size: 25,
            color: Colors.deepPurple,
          ),
          SizedBox(width: 6),
          Text(
            caption,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }
}
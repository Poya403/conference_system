import 'package:flutter/material.dart';
import 'package:conference_system/utils/app_texts.dart';

class CommentTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextDirection? textDirection;
  final double? width;
  final double? height;
  final int? maxLines;
  final int? minLines;
  final VoidCallback? suffixOnPressed;
  final VoidCallback? prefixOnPressed;

  const CommentTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.textDirection = TextDirection.ltr,
    this.suffixOnPressed,
    this.prefixOnPressed,
    this.width,
    this.height,
    this.maxLines,
    this.minLines = 1,
  });

  @override
  State<CommentTextField> createState() => _CommentTextFieldState();
}

class _CommentTextFieldState extends State<CommentTextField> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: widget.width ?? 350,
        maxWidth: widget.width ?? 350,
        minHeight: 50,
        maxHeight: 200, // حداکثر ارتفاع برای چند خط
      ),
      child: Directionality(
        textDirection: widget.textDirection ?? TextDirection.rtl,
        child: TextField(
          controller: widget.controller,
          textAlign: TextAlign.right,
          textDirection: widget.textDirection ?? TextDirection.rtl,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.purple, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            suffixIcon: widget.suffixOnPressed != null
                ? Material(
              color: Colors.transparent,
              child: IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.deepPurple),
                onPressed: widget.suffixOnPressed,
                splashRadius: 22,
                tooltip: AppTexts.sendComment,
              ),
            )
                : null,
            prefixIcon: widget.prefixOnPressed != null
                ? Material(
              color: Colors.transparent,
              child: IconButton(
                icon: const Icon(Icons.cancel_outlined, color: Colors.grey),
                onPressed: widget.prefixOnPressed,
                splashRadius: 22,
                tooltip: AppTexts.cancel,
              ),
            )
                : null,
          ),
        ),
      ),
    );
  }
}
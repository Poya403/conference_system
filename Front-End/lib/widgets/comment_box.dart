import 'package:flutter/material.dart';

class CommentBox extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextDirection? textDirection;
  final double? width;
  final double? height;
  final int? maxLines;
  final int? minLines;
  final VoidCallback? suffixOnPressed;
  final VoidCallback? prefixOnPressed;

  const CommentBox({
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
  State<CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? 300,
      height: widget.height ?? 80,
      child: Directionality(
        textDirection: widget.textDirection ?? TextDirection.rtl,
        child: TextField(
          textAlign: TextAlign.right,
          controller: widget.controller,
          maxLines: widget.maxLines ?? 1,
          minLines: widget.minLines,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
            hintTextDirection: widget.textDirection ?? TextDirection.rtl,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                icon: const Icon(Icons.send_outlined, color: Colors.deepPurple),
                onPressed: widget.suffixOnPressed,
                splashRadius: 22,
                tooltip: "ارسال نظر",
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
                tooltip: "حذف متن",
              ),
            )
                : null,
          ),
        ),
      ),
    );
  }
}



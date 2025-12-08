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
      width: widget.width ?? 250,
      height: widget.height ?? 45,
      child: Directionality(
        textDirection: widget.textDirection ?? TextDirection.rtl,
        child: TextField(
          textAlign: TextAlign.right,
          controller: widget.controller,
          maxLines: widget.maxLines ?? 1,
          minLines: widget.minLines,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintTextDirection: widget.textDirection ?? TextDirection.rtl,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(color: Colors.grey, width: 1),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(
                color: Colors.purple,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            suffixIcon: widget.suffixOnPressed == null
                ? null
                : IconButton(
              icon: Icon(Icons.send_outlined),
              onPressed: widget.suffixOnPressed,
            ),
            prefixIcon: widget.prefixOnPressed == null
              ? null
              : IconButton(
                  icon: Icon(Icons.cancel_outlined),
                  onPressed: widget.prefixOnPressed,
                ),
          ),
        ),
      ),
    );
  }
}


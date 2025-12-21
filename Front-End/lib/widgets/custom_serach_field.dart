import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final TextDirection? textDirection;
  final double? width;
  final double? height;
  final int? maxLines;
  final int? minLines;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  const SearchTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.textDirection = TextDirection.rtl,
    this.width,
    this.height,
    this.maxLines,
    this.minLines = 1,
    this.suffixIcon,
    this.prefixIcon,
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? 300,
      height: widget.height ?? 43,
      child: TextField(
        textDirection: widget.textDirection,
        textAlign: widget.textDirection == TextDirection.rtl
            ? TextAlign.right
            : TextAlign.left,
        controller: widget.controller,
        maxLines: widget.maxLines ?? 1,
        minLines: widget.minLines,
        decoration: InputDecoration(
          label: Align(
            alignment: Alignment.centerRight,
            child: Text(widget.labelText, textDirection: TextDirection.rtl),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Colors.purple, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          suffixIcon: widget.suffixIcon,
          prefixIcon: widget.prefixIcon,
        ),
      ),
    );
  }
}

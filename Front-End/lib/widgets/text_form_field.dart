import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final TextDirection? textDirection;
  final double? width;
  final double? height; // controls vertical padding
  final int? maxLines;
  final int? minLines;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.textDirection = TextDirection.rtl,
    this.width,
    this.height,
    this.maxLines,
    this.minLines = 1,
    this.suffixIcon,
    this.prefixIcon
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.labelText} : '),
          SizedBox(height: 10),
          SizedBox(
            width: widget.width ?? 300,
            height: 43,
            child: TextFormField(
              textDirection: widget.textDirection,
              textAlign: widget.textDirection == TextDirection.rtl
                  ? TextAlign.right
                  : TextAlign.left,
              controller: widget.controller,
              maxLines: widget.maxLines ?? 1,
              minLines: widget.minLines,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: widget.height ?? 8, // height control here
                  horizontal: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                suffixIcon: widget.suffixIcon,
                prefixIcon: widget.prefixIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

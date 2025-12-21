import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final TextDirection? textDirection;
  final double? width;
  final double? height; // controls vertical padding
  final int? maxLines;
  final int? minLines;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.textDirection = TextDirection.rtl,
    this.keyboardType,
    this.inputFormatters,
    this.hintText,
    this.width,
    this.height,
    this.maxLines,
    this.minLines = 1,
    this.suffixIcon,
    this.prefixIcon,
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
            width: widget.width ?? 250,
            height: 43,
            child: TextFormField(
              textDirection: widget.textDirection,
              textAlign: widget.textDirection == TextDirection.rtl
                  ? TextAlign.right
                  : TextAlign.left,
              controller: widget.controller,
              maxLines: widget.maxLines ?? 1,
              minLines: widget.minLines,
              keyboardType: widget.keyboardType,
              inputFormatters: widget.inputFormatters ?? [],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: widget.height ?? 8, // height control here
                  horizontal: 12,
                ),
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 13
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
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

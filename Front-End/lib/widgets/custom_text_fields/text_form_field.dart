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
  final bool readOnly;

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
    this.readOnly = false,
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
              readOnly: widget.readOnly,
              keyboardType: widget.keyboardType,
              inputFormatters: widget.inputFormatters ?? [],
              style: TextStyle(
                fontSize: 14,
                color: widget.readOnly ? Colors.grey.shade700 : Colors.black,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: widget.readOnly
                    ? Colors.grey.shade100
                    : Colors.white,

                contentPadding: EdgeInsets.symmetric(
                  vertical: widget.height ?? 10,
                  horizontal: 12,
                ),

                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 13,
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(
                    color: widget.readOnly
                        ? Colors.grey.shade300
                        : Colors.grey.shade400,
                    width: 1,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(
                    color: widget.readOnly
                        ? Colors.grey.shade300
                        : Colors.purple,
                    width: 1.2,
                  ),
                ),

                suffixIcon: widget.readOnly
                    ? Icon(Icons.lock_outline, size: 18, color: Colors.grey)
                    : widget.suffixIcon,

                prefixIcon: widget.prefixIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

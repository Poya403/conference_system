import 'package:flutter/material.dart';
class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isPassword;
  final TextDirection? textDirection;

  const CustomTextField({
    required this.controller,
    required this.labelText,
    this.textDirection = TextDirection.ltr,
    this.isPassword = false,
    super.key,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isHidden = true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 43,
      child: TextField(
        textDirection: widget.textDirection,
        textAlign: widget.textDirection == TextDirection.rtl
            ? TextAlign.right
            : TextAlign.left,
        controller: widget.controller,
        obscureText: widget.isPassword ? _isHidden : false,
        decoration: InputDecoration(
          label: Align(
            alignment: Alignment.centerRight,
            child: Text(
              widget.labelText,
              textDirection: TextDirection.rtl,
            ),
          ),
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
          suffixIcon: widget.isPassword ? IconButton(
            icon: Icon(
              _isHidden ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _isHidden = !_isHidden; // 👈 تغییر وضعیت نمایش
              });
            },
          ) : null,
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'dart:ui' as ui;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

class CustomPersianDateField extends StatefulWidget {
  const CustomPersianDateField({
    super.key,
    required this.labelText,
    required this.controller,
    this.onDateSelected,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.prefixIcon,
    this.helpText,
    this.enabled = true,
  });

  final void Function(String)? onDateSelected;
  final String labelText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool enabled;
  final String? helpText;
  @override
  State<CustomPersianDateField> createState() => _CustomPersianDateFieldState();
}

class _CustomPersianDateFieldState extends State<CustomPersianDateField> {
  String? gregorianDate;

  Future<void> _selectDate(BuildContext context) async {
    if (!widget.enabled) return;

    final picked = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.now(),
      firstDate: Jalali(1370, 1),
      lastDate: Jalali(1450, 12),
      helpText: widget.helpText,
      builder: (context, child) {
        return Localizations.override(
          context: context,
          locale: const Locale('fa', 'IR'),
          delegates: const [
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            PersianMaterialLocalizations.delegate,
            PersianCupertinoLocalizations.delegate,
          ],
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(foregroundColor: Colors.deepPurple),
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (picked != null) {
      widget.controller.text = picked.formatFullDate();

      final gregorian = picked.toDateTime();
      gregorianDate = DateFormat('yyyy-MM-dd').format(gregorian);

      if (widget.onDateSelected != null) {
        widget.onDateSelected!(gregorianDate!);
      }
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Column(
        textDirection: ui.TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.labelText} : '),
          SizedBox(height: 10),
          InkWell(
            onTap: () => _selectDate(context),
            child: IgnorePointer(
              child: SizedBox(
                    width: 300,
                    height: 45,
                    child: TextFormField(
                      controller: widget.controller,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.calendar_month_outlined),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        hintText: 'انتخاب کنید',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      keyboardType: widget.keyboardType,
                      enabled: widget.enabled,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

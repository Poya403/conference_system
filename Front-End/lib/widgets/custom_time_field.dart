import 'package:conference_system/utils/app_texts.dart';
import 'package:flutter/material.dart';

class CustomTimeField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? helpText;
  final Function(TimeOfDay) onTimeSelected;

  const CustomTimeField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.onTimeSelected,
    this.helpText,
  });

  @override
  State<CustomTimeField> createState() => _CustomTimeFieldState();
}

class _CustomTimeFieldState extends State<CustomTimeField> {
  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: widget.helpText,
      confirmText: AppTexts.submit,
      cancelText: AppTexts.cancel,
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
    );

    if (picked != null) {
      final formatted =
          '${picked.hour.toString().padLeft(2, '0')}:'
          '${picked.minute.toString().padLeft(2, '0')}';

      widget.controller.text = formatted;
      widget.onTimeSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.labelText} : '),
          const SizedBox(height: 10),
          SizedBox(
            width: 300,
            height: 43,
            child: InkWell(
              onTap: _pickTime,
              child: IgnorePointer(
                child: TextFormField(
                  controller: widget.controller,
                  readOnly: true,
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: const Icon(Icons.access_time),
                    hintText: 'انتخاب کنید',
                    hintStyle: TextStyle(color: Colors.grey)
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

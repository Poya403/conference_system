import 'package:conference_system/widgets/drop_down_field.dart';
import 'package:conference_system/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../utils/app_texts.dart';
import 'package:conference_system/models/course_filter.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({super.key, required this.onSearch});

  final Function(CourseFilter filter) onSearch;

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final titleController = TextEditingController();
  final capacityController = TextEditingController();
  final maxPriceController = TextEditingController();
  final minPriceController = TextEditingController();
  List<Hall> halls = [];
  Hall? selectedHall;
  String? selectedDeliveryType;

  @override
  void initState() {
    super.initState();
    _loadHalls();
  }

  @override
  void dispose() {
    titleController.dispose();
    capacityController.dispose();
    minPriceController.dispose();
    maxPriceController.dispose();
    super.dispose();
  }

  Future<void> _loadHalls() async {
    final supabase = Supabase.instance.client;

    final data = await supabase
        .from('halls')
        .select('id, title')
        .order('id');

    setState(() {
      halls = data.map<Hall>((e) => Hall.fromMap(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            textDirection: TextDirection.rtl,
            spacing: 10,
            children: [
              SearchTextField(
                controller: titleController,
                labelText: 'جستجو نام دوره',
                prefixIcon: Icon(Icons.search_rounded),
              ),
              Divider(thickness: 0.75),
              Text('فیلتر ها'),
              CustomDropdownField(
                  labelText: AppTexts.deliveryType,
                  items: [AppTexts.inPerson, AppTexts.online],
                  value: selectedDeliveryType,
                  onChanged: (val) {
                    setState(() {
                      selectedDeliveryType = val;
                    });
                  }
              ),
              selectedDeliveryType == AppTexts.inPerson
                  ? CustomDropdownField(
                    labelText: AppTexts.hostHall,
                    value: selectedHall?.title,
                    items: halls.map((e) => e.title).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedHall = halls.firstWhere((e) => e.title == val);
                      });
                    },
                  ): SizedBox.shrink(),
              CustomTextFormField(
                  controller: capacityController,
                  labelText: AppTexts.capacity,
              ),
              Row(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextFormField(
                    controller: maxPriceController,
                    labelText: AppTexts.maxPrice,
                    width: 105,
                  ),
                  CustomTextFormField(
                    controller: minPriceController,
                    labelText: AppTexts.minPrice,
                    width: 105,
                  ),
                ],
              ),
              SearchButton(
                onPressed: () async {
                  final filter = CourseFilter(
                    search: titleController.text.trim(),
                    deliveryType: selectedDeliveryType,
                    minPrice: int.tryParse(minPriceController.text.trim()),
                    maxPrice: int.tryParse(maxPriceController.text.trim()),
                    hid: selectedHall?.id,
                  );
                  widget.onSearch(filter);
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.purple, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
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

class SearchButton extends StatelessWidget {
  const SearchButton({super.key, this.onPressed});
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        onPressed: onPressed,
        child: Text(AppTexts.search, style: TextStyle(color: Colors.white),)
    );
  }
}

class Hall {
  final int id;
  final String title;

  const Hall({
    required this.id,
    required this.title,
  });

  factory Hall.fromMap(Map<String, dynamic> map) {
    return Hall(
      id: map['id'],
      title: map['title'],
    );
  }
}

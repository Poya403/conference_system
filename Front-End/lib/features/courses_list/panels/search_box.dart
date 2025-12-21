import 'package:conference_system/widgets/drop_down_field.dart';
import 'package:conference_system/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../utils/app_texts.dart';
import 'package:conference_system/models/course_filter.dart';
import 'package:conference_system/widgets/custom_serach_field.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({super.key, required this.onSearch});

  final Function(CourseFilter filter) onSearch;

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final titleController = TextEditingController();
  final minCapacityController = TextEditingController();
  final maxCapacityController = TextEditingController();
  final maxPriceController = TextEditingController();
  final minPriceController = TextEditingController();
  List<Hall> halls = [];
  Hall? selectedHall;
  String? selectedDeliveryType;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadHalls();
  }

  @override
  void dispose() {
    titleController.dispose();
    minCapacityController.dispose();
    maxCapacityController.dispose();
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
    bool isMobile = MediaQuery.of(context).size.width < 200;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        color: Colors.white,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 20,
              runSpacing: 10,
              textDirection: TextDirection.rtl,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 2,
                  textDirection: TextDirection.rtl,
                  children: [
                    SearchTextField(
                      controller: titleController,
                      labelText: 'جستجو نام دوره',
                      prefixIcon: Icon(Icons.search_rounded),
                      width: isMobile ? 200 : 180,
                    ),
                    IconButton(
                      onPressed: () => setState(() {
                        isExpanded = !isExpanded;
                      }),
                      icon: Icon(
                          isExpanded
                            ? Icons.expand_more_outlined
                            : Icons.expand_less_outlined
                      ),
                    ),
                  ]
                ),

                if(isExpanded) ... [
                  Divider(thickness: 0.75),
                  Text(': فیلتر ها'),
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
                  if(selectedDeliveryType == AppTexts.inPerson)...[
                    CustomDropdownField(
                      labelText: AppTexts.hostHall,
                      value: selectedHall?.title,
                      items: halls.map((e) => e.title).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedHall = halls.firstWhere((e) => e.title == val);
                        });
                      },
                    ),
                    Row(
                      spacing: 20,
                      textDirection: TextDirection.rtl,
                      children: [
                        CustomTextFormField(
                          controller: minCapacityController,
                          labelText: AppTexts.minCapacity,
                          width: 105,
                        ),
                        CustomTextFormField(
                          controller: maxCapacityController,
                          labelText: AppTexts.maxCapacity,
                          width: 105,
                        ),
                      ],
                    ),
                  ],
                  Row(
                    spacing: 20,
                    textDirection: TextDirection.rtl,
                    children: [
                      CustomTextFormField(
                        controller: minPriceController,
                        labelText: AppTexts.minPrice,
                        width: 105,
                      ),
                      CustomTextFormField(
                        controller: maxPriceController,
                        labelText: AppTexts.maxPrice,
                        width: 105,
                      ),
                    ],
                  ),
                ],
                Center(
                  child: SearchButton(
                    onPressed: () async {
                      final filter = CourseFilter(
                        search: titleController.text.trim(),
                        deliveryType: selectedDeliveryType,
                        minPrice: int.tryParse(minPriceController.text.trim()),
                        maxPrice: int.tryParse(maxPriceController.text.trim()),
                        hid: selectedHall?.id,
                        minCapacity: int.tryParse(minCapacityController.text.trim()),
                        maxCapacity: int.tryParse(maxCapacityController.text.trim())
                      );
                      widget.onSearch(filter);
                    }
                  ),
                ),
              ],
            ),
          ),
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
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
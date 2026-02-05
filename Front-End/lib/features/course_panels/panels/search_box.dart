import 'package:conference_system/data/models/course_filter.dart';
import 'package:conference_system/enums/course_category.dart';
import 'package:conference_system/widgets/custom_text_fields/text_form_field.dart';
import 'package:conference_system/widgets/custom_text_fields/drop_down_field.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conference_system/bloc/courses/courses_bloc.dart';
import 'package:conference_system/bloc/courses/courses_event.dart';
import 'package:conference_system/bloc/auth/auth_bloc.dart';
import 'package:conference_system/bloc/auth/auth_state.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({super.key, required this.category});
  final CourseCategory category;
  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final titleController = TextEditingController();
  final phoneController = TextEditingController();
  final maxPriceController = TextEditingController();
  final minPriceController = TextEditingController();
  final List<CourseTypeItem> courseTypes = [
    CourseTypeItem(id: 1, title: 'علمی'),
    CourseTypeItem(id: 2, title: 'تخصصی'),
    CourseTypeItem(id: 3, title: 'کنفرانس'),
    CourseTypeItem(id: 4, title: 'سمینار'),
    CourseTypeItem(id: 5, title: 'کارگاه آموزشی'),
    CourseTypeItem(id: 6, title: 'وبینار'),
    CourseTypeItem(id: 7, title: 'گردهمایی'),
    CourseTypeItem(id: 8, title: 'نشست تخصصی'),
    CourseTypeItem(id: 9, title: 'ملی'),
    CourseTypeItem(id: 10, title: 'بین‌المللی'),
  ];

  String? selectedDeliveryType;
  int? selectedCrsType;
  bool isExpanded = false;
  int? userId;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      userId = authState.authResponse.userId;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    phoneController.dispose();
    minPriceController.dispose();
    maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    double width = MediaQuery.of(context).size.width * 0.85;
    return SizedBox(
      width: width,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        color: Colors.white,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Column(
                children: [
                  IconButton(
                    onPressed: () => setState(() {
                      isExpanded = !isExpanded;
                    }),
                    icon: Icon(
                      isExpanded
                          ? Icons.expand_more_outlined
                          : Icons.expand_less_outlined,
                    ),
                  ),
                  SizedBox(width: 8),
                  Row(
                    spacing: 10,
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextFormField(
                        controller: titleController,
                        labelText: AppTexts.search,
                        hintText: AppTexts.crsTitle,
                        prefixIcon: Icon(Icons.search_rounded),
                        width: isDesktop ? 350 : 200,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: SearchButton(
                          onPressed: () async {
                            context.read<CourseBloc>().add(
                              SearchCourses(
                                category: widget.category,
                                uid: userId!,
                                filterDTO: CourseFilterDTO(
                                  courseTitle: titleController.text.trim().isEmpty ? null
                                      : titleController.text.trim(),
                                  contactPhone: phoneController.text.trim().isEmpty ? null
                                      : phoneController.text.trim(),
                                  crsTypeId: selectedCrsType,
                                  deliveryType: selectedDeliveryType?.isEmpty ?? true ? null
                                      : selectedDeliveryType,
                                  minCost: minPriceController.text.trim().isEmpty ? null
                                      : double.tryParse(minPriceController.text.trim()),
                                  maxCost: maxPriceController.text.trim().isEmpty ? null
                                      : double.tryParse(maxPriceController.text.trim()),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,)
                ],
              ),

              AnimatedSize(
                duration: Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: isExpanded ? 200 : 0,
                  ),
                  child: isExpanded
                      ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      spacing: 10,
                      children: [
                        Divider(thickness: 0.5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          textDirection: TextDirection.rtl,
                          spacing: 10,
                          children: [
                            CustomDropdownField(
                              labelText: AppTexts.deliveryType,
                              items: [AppTexts.inPerson, AppTexts.online],
                              value: selectedDeliveryType,
                              onChanged: (val) {
                                setState(() {
                                  selectedDeliveryType = val;
                                });
                              },
                              onPressed: selectedDeliveryType != null
                                  ? () {
                                setState(() {
                                  selectedDeliveryType = null;
                                });
                              }
                                  : null,
                            ),
                            CustomDropdownField(
                              labelText: AppTexts.crsType,
                              items: courseTypes.map((e) => e.title).toList(),
                              value: selectedCrsType == null
                                  ? null
                                  : courseTypes
                                  .firstWhere((e) => e.id == selectedCrsType)
                                  .title,
                              onChanged: (val) {
                                setState(() {
                                  selectedCrsType = courseTypes
                                      .firstWhere((e) => e.title == val)
                                      .id;
                                });
                              },
                              onPressed: selectedCrsType != null
                                  ? () {
                                setState(() {
                                  selectedCrsType = null;
                                });
                              }
                                  : null,
                            ),
                            CustomTextFormField(
                              controller: phoneController,
                              labelText: AppTexts.phoneNumber,
                              width: isDesktop ? 200 : 100,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          textDirection: TextDirection.rtl,
                          spacing: 10,
                          children: [
                            CustomTextFormField(
                              controller: minPriceController,
                              labelText: AppTexts.minPrice,
                              width: isDesktop ? 200 : 100,
                            ),
                            CustomTextFormField(
                              controller: maxPriceController,
                              labelText: AppTexts.maxPrice,
                              width: isDesktop ? 200 : 100,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                      : SizedBox.shrink(),
                ),
              ),
            ],
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

class CourseTypeItem {
  final int id;
  final String title;
  CourseTypeItem({required this.id, required this.title});
}

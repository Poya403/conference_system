import 'package:conference_system/server/services/amenities_service.dart';
import 'package:conference_system/utils/format_price.dart';
import 'package:conference_system/widgets/custom_time_field.dart';
import 'package:conference_system/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/server/services/courses_service.dart';
import 'package:conference_system/server/services/hall_events_service.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:conference_system/utils/date_converter.dart';
import 'package:conference_system/widgets/drop_down_field.dart';
import 'package:conference_system/widgets/custom_persian_date_picked.dart';
import 'package:flutter/services.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  final coursesService = CoursesService();
  final hallEventsService = HallEventsService();
  final amenitiesService = AmenitiesService();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final deliveryTypeController = TextEditingController();
  final costController = TextEditingController();
  final holdingDateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final capacityController = TextEditingController();
  final budgetController = TextEditingController();
  bool isEditing = false;
  bool showHalls = false;
  String? selectedType;
  String? selectedDeliveryType;
  String? selectedAmenity;
  List<String> requiredAmenities = [];
  Future<List<Map<String, dynamic>>>? bestHallsFuture;

  Future<List<String>> _loadEvents() async {
    final events = await hallEventsService.getEventsName();
    return events.map<String>((e) => e['name'].toString()).toList();
  }

  Future<List<String>> _loadAmenities() async {
    final amenities = await amenitiesService.getAmenities();
    return amenities.map<String>((a) => a['name'].toString()).toList();
  }

  // UI
  final TextStyle detailStyle = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Colors.deepPurple,
  );
  final TextStyle hallDetailStyle = const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: Colors.blueGrey,
  );
  //load best halls
  void loadBestHalls() {
    final budget = budgetController.text.trim();
    final capacity = capacityController.text.trim();

    if (budget.isEmpty || capacity.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('لطفا مقدار ظرفیت و بودجه را وارد کنید'))
      );
      return;
    }

    setState(() {
      bestHallsFuture = coursesService.getBestHalls(
          eventType: selectedType ?? 'سمینار',
          expectedCapacity: int.parse(capacity),
          budget: double.parse(budget),
          requiredAmenities: requiredAmenities
      );
      showHalls = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    deliveryTypeController.dispose();
    costController.dispose();
    holdingDateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    phoneNumberController.dispose();
    capacityController.dispose();
    budgetController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery
        .of(context)
        .size
        .width > 800;

    final coursesList = SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width * 0.7,
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: coursesService.myCoursesList('own courses'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text(AppTexts.noData);
          } else {
            final myCourses = snapshot.data!;

            return LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 1;
                if (constraints.maxWidth > 1200) {
                  crossAxisCount = 4;
                } else if (constraints.maxWidth > 800) {
                  crossAxisCount = 3;
                } else if (constraints.maxWidth > 500) {
                  crossAxisCount = 2;
                } else {
                  crossAxisCount = 1;
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      children: [
                        Text(
                          AppTexts.myCourses,
                          style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.w600,
                            fontSize: 30,
                          ),
                        ),
                        SizedBox(height: 10,),
                        SizedBox(
                          height: 600,
                          child: GridView.builder(
                            itemCount: myCourses.length,
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: isDesktop ? 1 : 0.8,
                            ),
                            itemBuilder: (context, index) {
                              final singleCourse = myCourses[index];
                              final startTime = singleCourse['start_time'];
                              final endTime = singleCourse['end_time'];
                              final imgUrl = singleCourse['img_url'];

                              return Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(15),
                                      ),
                                      child: imgUrl == null || imgUrl.isEmpty
                                          ? const Icon(
                                        Icons.image_not_supported,
                                      )
                                          : Image.network(
                                        imgUrl,
                                        height: 120,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context,
                                            error,
                                            stackTrace,) =>
                                        const Icon(
                                          Icons.image_not_supported,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      singleCourse['title'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        textDirection: TextDirection.rtl,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${AppTexts
                                                .registrants} : ${singleCourse['registrants'] ??
                                                ''}',
                                            style: detailStyle,
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            '${AppTexts
                                                .crsType}: ${singleCourse['delivery_type'] ??
                                                ''}',
                                            style: detailStyle,
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            '${AppTexts.holdingDate} : '
                                                '${AppTexts
                                                .day} ${getPersianWeekday(
                                                startTime ?? '')} - '
                                                '${getPersianDate(
                                                startTime ?? '')}',
                                            style: detailStyle,
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            '${AppTexts.startTime} : '
                                                '${getPersianTime(
                                                startTime ?? '')}',
                                            style: detailStyle,
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            '${AppTexts.endTime} : '
                                                '${getPersianTime(
                                                endTime ?? '')}',
                                            style: detailStyle,
                                          ),
                                          const SizedBox(height: 15),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );

    final formFields = [
      Text(
        AppTexts.completeCourseForm,
        textDirection: TextDirection.rtl,
        style: TextStyle(color: Colors.deepPurple, fontSize: 20),
      ),
      CustomTextFormField(
        controller: titleController,
        labelText: AppTexts.crsTitle,
      ),
      FutureBuilder<List<String>>(
        future: _loadEvents(),
        builder: (context, snapshot) {
          final items = snapshot.data ?? [AppTexts.loading];

          return CustomDropdownField(
            labelText: AppTexts.crsType,
            value: selectedType,
            items: items,
            onChanged: snapshot.hasData
                ? (val) {
              setState(() {
                selectedType = val;
              });
            }
                : (_) {},
          );
        },
      ),
      CustomDropdownField(
        labelText: AppTexts.deliveryType,
        items: [AppTexts.inPerson, AppTexts.online],
        value: selectedDeliveryType,
        onChanged: (val) {
          setState(() {
            selectedDeliveryType = val;
          });
        },
      ),
      CustomPersianDateField(
        controller: holdingDateController,
        labelText: AppTexts.holdingDate,
        helpText: AppTexts.holdingDate,
        onDateSelected: (gregorianDate) {},
      ),
      CustomTimeField(
        controller: startTimeController,
        labelText: AppTexts.startTime,
        helpText: AppTexts.startTime,
        onTimeSelected: (time) {},
      ),
      CustomTimeField(
        controller: endTimeController,
        labelText: AppTexts.endTime,
        helpText: AppTexts.endTime,
        onTimeSelected: (time) {},
      ),
      CustomTextFormField(
        controller: phoneNumberController,
        labelText: AppTexts.phoneNumber,
        keyboardType: TextInputType.phone,
        hintText: '021xxxxxxx',
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
      CustomTextFormField(
        controller: costController,
        labelText: AppTexts.registrationFee,
        keyboardType: TextInputType.number,
        hintText: 'تومان',
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
      CustomTextFormField(
        controller: descriptionController,
        labelText: AppTexts.description,
        hintText: AppTexts.optional,
        maxLines: 5,
        width: 500,
      ),
      CustomTextFormField(
        controller: budgetController,
        labelText: AppTexts.budget,
        hintText: 'حداکثر میزان بودجه شما(تومان)',
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
      CustomTextFormField(
        controller: capacityController,
        labelText: AppTexts.crsCapacity,
        hintText: 'بین 1 تا 3000 نفر',
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
      FutureBuilder<List<String>>(
        future: _loadAmenities(),
        builder: (context, snapshot) {
          final items = snapshot.data ?? [AppTexts.loading];

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomDropdownField(
                labelText: AppTexts.amenities,
                value: selectedAmenity,
                items: items,
                onChanged: snapshot.hasData
                    ? (val) {
                  setState(() {
                    selectedAmenity = val;
                  });
                }
                    : (_) {},
              ),
              SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (selectedAmenity != null &&
                          !requiredAmenities.contains(selectedAmenity)) {
                        requiredAmenities.add(selectedAmenity ?? 'unknown');
                      }
                    });
                  },
                  child: Text('انتخاب')
              ),
              SizedBox(height: 10),
              for(String amenity in requiredAmenities)...[
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 150,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            requiredAmenities.remove(amenity);
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(amenity, style: TextStyle(fontSize: 12),),
                            Icon(Icons.remove_circle_outline)
                          ],
                        )
                    ),
                  ),

                )
              ],
              SizedBox(height: 10),
            ],
          );
        },
      ),
    ];

    final fieldsGroupsDesktop = [
      [formFields[1], formFields[2], formFields[3]],
      [formFields[4], formFields[5], formFields[6]],
      [formFields[7], formFields[8], formFields[9]],
    ];

    final inPersonFields = [
      [formFields[10], formFields[11], formFields[12]],
    ];

    // build a group of fields
    Widget buildFieldGroup(List<Widget> fields) {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Wrap(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: WrapCrossAlignment.start,
          spacing: 20,
          runSpacing: 10,
          children: fields,
        ),
      );
    }

    final courseCreationForm = SizedBox(
      width: isDesktop ? MediaQuery
          .of(context)
          .size
          .width * 0.6 : double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(isDesktop ? 30.0 : 1.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            textDirection: TextDirection.rtl,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: formFields[0],
                  ),
                  SizedBox(height: 10),
                  ...fieldsGroupsDesktop.map(buildFieldGroup),
                  SizedBox(height: 20),

                  if (selectedDeliveryType == AppTexts.inPerson) ...[
                    Divider(thickness: 0.75),
                    Text(
                      AppTexts.completeIfInPrson,
                      style: TextStyle(color: Colors.deepPurple, fontSize: 13),
                    ),
                    SizedBox(height: 10),
                    ...inPersonFields.map(buildFieldGroup),
                    SizedBox(height: 10),
                  ],
                ],
              ),
              if (selectedDeliveryType == AppTexts.inPerson) ... [
                HallSelectButton(
                    isEditing: isEditing,
                    showHalls: showHalls,
                    onPressed: loadBestHalls
                ),
              ]
            ],
          ),
        ),
      ),
    );

    final bestHallsList = SizedBox(
      height: 500,
      child: bestHallsFuture != null
          ? FutureBuilder<List<Map<String,dynamic>>>(
        future: bestHallsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text(AppTexts.noData);
          } else {
            final halls = snapshot.data!;

            return LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 1;
                if (constraints.maxWidth > 1200) {
                  crossAxisCount = 4;
                } else if (constraints.maxWidth > 800) {
                  crossAxisCount = 3;
                } else if (constraints.maxWidth > 500) {
                  crossAxisCount = 2;
                } else {
                  crossAxisCount = 1;
                }

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: halls.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: isDesktop ? 0.83 : 0.8,
                        ),
                        itemBuilder: (context, index) {
                          final hall = halls[index];
                          final imgUrl = hall['img_url'];

                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(15),
                                  ),
                                  child: imgUrl == null || imgUrl.isEmpty
                                      ? const Icon(Icons.image_not_supported)
                                      : Image.network(
                                    imgUrl,
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                    const Icon(
                                      Icons.image_not_supported,
                                    ),
                                  ),
                                ),
                                Text(
                                  hall['title'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                DefaultTextStyle(
                                  style: TextStyle(
                                    fontFamily: 'Farsi',
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          '${AppTexts
                                              .capacity} : ${hall['capacity'] ??
                                              ''} نفر ',
                                          style: hallDetailStyle
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '${AppTexts.area} : ${hall['area'] ??
                                              ''}',
                                          style:hallDetailStyle
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                            '${AppTexts.price} : ${formatPrice(hall['price'] ?? '0')}',
                                            style:hallDetailStyle
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                            '${AppTexts.amenities} : ${hall['amenities']}',
                                            style:hallDetailStyle
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                            '${AppTexts.supportedEvents} : ${hall['events']}',
                                            style:hallDetailStyle
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ) : SizedBox.shrink(),
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          if (isEditing) ...[courseCreationForm] else
            coursesList,
          SizedBox(height: 10),
          PanelButton(
            isEditing: isEditing,
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
          ),
          SizedBox(height: 10,),
          bestHallsList
        ],
      ),
    );
  }
}

class PanelButton extends StatelessWidget {
  const PanelButton({this.onPressed, required this.isEditing, super.key});

  final VoidCallback? onPressed;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.purple,
        shape: const CircleBorder(),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(
              isEditing ? Icons.cancel_outlined : Icons.add_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}

class HallSelectButton extends StatelessWidget {
  const HallSelectButton({
    this.onPressed,
    required this.isEditing,
    super.key,
    required this.showHalls
  });

  final VoidCallback? onPressed;
  final bool isEditing;
  final bool showHalls;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.purple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      child: Column(
        children: [
          Text(
            AppTexts.getBestHalls,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
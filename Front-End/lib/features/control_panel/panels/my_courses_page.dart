import 'package:conference_system/bloc/auth/auth_bloc.dart';
import 'package:conference_system/bloc/courses/courses_bloc.dart';
import 'package:conference_system/bloc/courses/courses_event.dart';
import 'package:conference_system/bloc/courses/courses_state.dart';
import 'package:conference_system/enums/course_category.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conference_system/bloc/auth/auth_state.dart';
import 'package:conference_system/widgets/no_data_widget.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  bool isEditing = false;
  bool showHalls = false;
  String? selectedType;
  String? selectedDeliveryType;
  String? selectedAmenity;
  late int selectedHid;
  late String selectedGregorianDate;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final costController = TextEditingController();
  final holdingDateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final capacityController = TextEditingController();
  final budgetController = TextEditingController();

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

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    costController.dispose();
    holdingDateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    phoneNumberController.dispose();
    capacityController.dispose();
    budgetController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      context.read<CourseBloc>().add(
          GetCoursesList(
              authState.authResponse.userId ?? 0,
              CourseCategory.myCourses
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery
        .of(context)
        .size
        .width > 800;

    return Scaffold(
      body: BlocConsumer<CourseBloc, CoursesState>(
          listener: (context, state) {
            if (state is CoursesError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message))
              );
            }
          },
          builder: (context, state) {
            if (state is CourseLoading) {
              return Center(child: const CircularProgressIndicator());
            } else if (state is CoursesLoaded) {
              final myCourses = state.courses;
              if(myCourses.isEmpty){
                return NoDataWidget(title: 'دوره ای جهت نمایش وجود ندارد.');
              }
              return SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.7,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    elevation: 4,
                    color: Colors.white,
                    child: LayoutBuilder(
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
                                SizedBox(height: 10),
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
                
                                      return Card(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              15),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          spacing: 6,
                                          children: [
                                            Text(
                                              singleCourse.title,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.deepPurpleAccent,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                textDirection: TextDirection.rtl,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                spacing: 10,
                                                children: [
                                                  Text(
                                                    '${AppTexts.crsType}: '
                                                        '${singleCourse.courseType.title}',
                                                    style: detailStyle,
                                                  ),
                                                  Text(
                                                    '${AppTexts.deliveryType}: '
                                                        '${singleCourse.deliveryType}',
                                                    style: detailStyle,
                                                  ),
                                                  Text(
                                                    '${AppTexts.phoneNumber}: '
                                                        '${singleCourse.contactPhone}',
                                                    style: detailStyle,
                                                  )
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
                    ),
                  ),
                ),
              );
            }
            return Center(child: Text(AppTexts.loading));
          }
      ),
    );
  }
}



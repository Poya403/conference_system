import 'package:conference_system/features/course_panels/panels/search_box.dart';
import 'package:conference_system/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:conference_system/bloc/auth/auth_bloc.dart';
import 'package:conference_system/bloc/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conference_system/bloc/courses/courses_bloc.dart';
import 'package:conference_system/bloc/courses/courses_event.dart';
import 'package:conference_system/bloc/courses/courses_state.dart';
import 'package:conference_system/enums/course_category.dart';
import 'dart:math' as math;

class CoursesListScreen extends StatefulWidget {
  const CoursesListScreen({super.key, required this.category});

  final CourseCategory category;
  @override
  State<CoursesListScreen> createState() => _CoursesListScreenState();
}

class _CoursesListScreenState extends State<CoursesListScreen> {
  late int userId;

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthBloc>().state;

    if (authState is AuthSuccess) {
      userId = authState.authResponse.userId ?? 0;

      context.read<CourseBloc>().add(
        GetCoursesList(
          userId,
          widget.category,
        )
      );
    }
  }
  // UI
  final TextStyle detailStyle = const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: Colors.deepPurple,
  );

  @override
  Widget build(BuildContext context) {
    final _ = MediaQuery
        .of(context)
        .size
        .width > 900;

    return Center(
        child: Column(
          spacing: 20,
      children: [
        SearchBox(category: widget.category),
        Expanded(child: CoursesList(userId: userId, category: widget.category)),
      ],
    ));
  }
}

class CoursesList extends StatefulWidget {
  const CoursesList({
    super.key,
    required this.userId,
    required this.category,
    this.limit,
  });
  final int userId;
  final CourseCategory category;
  final int? limit;

  @override
  State<CoursesList> createState() => _CoursesListState();
}

class _CoursesListState extends State<CoursesList> {
  final TextStyle detailStyle = const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: Colors.deepPurple,
  );

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      body: BlocConsumer<CourseBloc, CoursesState>(
          listener: (context, state) {
            if (state is CoursesError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message))
              );
            }
            if (state is CoursesActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is CourseLoading) {
              return Center(child: const CircularProgressIndicator());
            } else if (state is CoursesLoaded) {
              final availableCourses = state.courses;
              if(availableCourses.isEmpty){
                return Center(
                    child: NoDataWidget()
                );
              }
              return Center(
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
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
                                    widget.category.title,
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
                                      itemCount: widget.limit != null
                                          ? math.min(widget.limit ?? 0,availableCourses.length)
                                          : availableCourses.length,
                                      gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16,
                                        childAspectRatio: isDesktop ? 1 : 0.8,
                                      ),
                                      itemBuilder: (context, index) {
                                        final singleCourse = availableCourses[index];
                                        final isInBasket = (singleCourse.paymentStatus) == 1;

                                        return Card(
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            spacing: 6,
                                            children: [
                                              SizedBox(height: 15,),
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
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              RegisterButton(
                                                isInBasket: isInBasket,
                                                onPressed:() {
                                                  context.read<CourseBloc>().add(
                                                    ToggleBasket(
                                                        uid: widget.userId,
                                                        category: widget.category,
                                                        cid: singleCourse.id,
                                                    ),
                                                  );
                                                }
                                              )
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
                ),
              );
            }
            return Center(child: Text(AppTexts.loading));
          }
      ),
    );
  }
}

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    super.key,
    this.onPressed,
    required this.isInBasket,
  });

  final VoidCallback? onPressed;
  final bool isInBasket;

  String get buttonText {
    switch (isInBasket) {
      case true: return 'حذف از سبد خرید';
      case false: return 'افزودن به سبد خرید';
    }
  }

  Color get buttonColor {
    switch (isInBasket) {
      case true: return Colors.redAccent;
      case false: return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 32),
      child: SizedBox(
        width: 150,
        height: 35,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                buttonText,
                style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.white
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


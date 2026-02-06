import 'package:conference_system/enums/course_category.dart';
import 'package:conference_system/features/course_panel/panels/enrollment_list.dart';
import 'package:conference_system/utils/format_price.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/bloc/courses/courses_bloc.dart';
import 'package:conference_system/bloc/courses/courses_state.dart';
import 'package:conference_system/bloc/courses/courses_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:conference_system/data/models/courses.dart';
import 'package:conference_system/widgets/no_data_widget.dart';
import 'package:conference_system/bloc/users/users_bloc.dart';
import 'package:conference_system/bloc/users/users_state.dart';
import 'edit_form.dart';

class CourseInfoScreen extends StatefulWidget {
  const CourseInfoScreen({
    super.key,
    required this.cid,
    required this.category,
  });

  @override
  State<CourseInfoScreen> createState() => _CourseInfoScreenState();
  final int cid;
  final CourseCategory category;
}

class _CourseInfoScreenState extends State<CourseInfoScreen> {
  late final String userRole;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();

    final userState = context.read<UsersBloc>().state;

    if (userState is UserLoaded) {
      userRole = userState.user.role;
    } else {
      userRole = 'User';
    }

    context.read<CourseBloc>().add(GetSingleCourse(cid: widget.cid));
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery
        .of(context)
        .size
        .width > 1500;
    return BlocConsumer<CourseBloc, CoursesState>(
      listener: (context, state) {
        if (state is CoursesError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is CourseInitial) {
          return Center(child: Text(AppTexts.initialize));
        } else if (state is CourseLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is SingleCourseLoaded) {
          final course = state.course;
          return SingleChildScrollView(
            child: Column(
              children: [
                isDesktop
                    ? SingleChildScrollView(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    textDirection: TextDirection.rtl,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        textDirection: TextDirection.rtl,
                        children: [
                          if(userRole == 'Admin')...[
                            IconButton(
                              onPressed: () =>
                                  setState(() {
                                    isEditing = !isEditing;
                                  }),
                              icon: Icon(
                                isEditing ? Icons.cancel_outlined : Icons.edit_outlined,
                                color: isEditing
                                    ? Colors.deepPurpleAccent
                                    : Colors.blueGrey,
                              ),
                            ),
                          ],
                          if(isEditing && userRole == "Admin")...[
                            Center(child: EditCrsForm(course: course))
                          ] else ...[
                            Center(child: CourseInfoBox(course: course))
                          ],
                        ],
                      ),
                    ],
                  ),
                )
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.rtl,
                  children: [
                    if(userRole == "Admin")...[
                      IconButton(
                        onPressed: () =>
                            setState(() {
                              isEditing = !isEditing;
                            }),
                        icon: Icon(
                          isEditing ? Icons.cancel_outlined : Icons.edit_outlined,
                          color: isEditing ? Colors.blueGrey : Colors
                              .deepPurpleAccent,
                        ),
                      ),
                    ],
                    if(isEditing && userRole == "Admin")...[
                      Center(child: EditCrsForm(course: course))
                    ] else ...[
                      Center(child: CourseInfoBox(course: course))
                    ],
                  ],
                ),
                if (widget.category == CourseCategory.myCourses) ...[
                  EnrollmentList(courseId: course.id),
                ],
              ],
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}

class CourseInfoBox extends StatefulWidget {
  const CourseInfoBox({super.key, required this.course});

  final Course course;

  @override
  State<CourseInfoBox> createState() => _CourseInfoBoxState();
}

class _CourseInfoBoxState extends State<CourseInfoBox> {
  final TextStyle detailStyle = const TextStyle(
    fontSize: 16,
    color: Colors.deepPurple,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width * 0.76,
          height: 400,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.white,
            child: Column(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SelectableText(
                    textAlign: TextAlign.center,
                    widget.course.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Farsi',
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                ),
                Divider(thickness: 0.75),
                DefaultTextStyle(
                  style: TextStyle(
                    fontFamily: 'Farsi',
                    color: Colors.deepPurpleAccent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        SelectableText(
                          '${AppTexts.deliveryType} : ${widget.course
                              .deliveryType}',
                          style: detailStyle,
                        ),
                        SelectableText(
                          '${AppTexts.crsType} : ${widget.course.courseType
                              ?.title}',
                          style: detailStyle,
                        ),
                        SelectableText(
                          '${AppTexts.phoneNumber} : \u200E${widget.course
                              .contactPhone}',
                          style: detailStyle,
                        ),
                        SelectableText(
                          '${AppTexts.price} : \u200E${formatPrice(
                              widget.course.cost)}',
                          style: detailStyle,
                        ),
                        Divider(thickness: 0.35),
                        (widget.course.description != null &&
                            widget.course.description!.isNotEmpty)
                            ? Column(
                          textDirection: TextDirection.rtl,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppTexts.details,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 20),
                            SelectableText(
                              widget.course.description ?? '',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        )
                            : NoDataWidget(
                          title: 'جزئیاتی جهت نمایش وجود ندارد.',
                        ),
                      ],
                    ),
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


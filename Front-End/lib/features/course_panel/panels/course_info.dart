import 'package:conference_system/utils/format_price.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/bloc/courses/courses_bloc.dart';
import 'package:conference_system/bloc/courses/courses_state.dart';
import 'package:conference_system/bloc/courses/courses_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:conference_system/data/models/courses.dart';
import 'package:conference_system/widgets/no_data_widget.dart';

class CourseInfoScreen extends StatefulWidget {
  const CourseInfoScreen({super.key, required this.cid});

  @override
  State<CourseInfoScreen> createState() => _CourseInfoScreenState();
  final int cid;
}

class _CourseInfoScreenState extends State<CourseInfoScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CourseBloc>().add(GetSingleCourse(cid: widget.cid));
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    return BlocConsumer<CourseBloc, CoursesState>(
      listener: (context, state) {
        if (state is CoursesError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if(state is CourseInitial){
          return Center(child: Text(AppTexts.initialize));
        } else if (state is CourseLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is SingleCourseLoaded) {
          final course = state.course;
          return Container(
            child: isDesktop
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
                      CourseInfoBox(course: course),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.rtl,
                    children: [
                      MainContent(course: course),
                    ],
                  ),
                ],
              ),
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: [
                CourseInfoBox(course: course),
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
    fontSize: 14,
    color: Colors.blueGrey,
  );

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: isDesktop ? 300 : 800,
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
                      spacing: 6,
                      children: [
                        SelectableText(
                            '${AppTexts.deliveryType} : ${widget.course.deliveryType}',
                            style: detailStyle
                        ),
                        SelectableText(
                            '${AppTexts.crsType} : ${widget.course.courseType.title}',
                            style: detailStyle
                        ),
                        SelectableText(
                            '${AppTexts.phoneNumber} : \u200E${widget.course.contactPhone}',
                            style: detailStyle
                        ),
                        SelectableText(
                            '${AppTexts.price} : \u200E${formatPrice(widget.course.cost)}',
                            style: detailStyle
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

class MainContent extends StatelessWidget {
  const MainContent({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: isDesktop
              ? MediaQuery.of(context).size.width * 0.55
              : double.infinity,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          course.title,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      Divider(thickness: 0.35),
                      (course.description != null && course.description!.isNotEmpty)
                          ? Column(
                        children: [
                          SizedBox(height: 20),
                          SelectableText(
                            course.description ?? '',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      )
                          : Center(
                        child: NoDataWidget(
                          title: 'اطلاعاتی جهت نمایش یا چاپ وجود ندارد.',
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
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
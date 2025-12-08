import 'package:flutter/material.dart';
import 'package:conference_system/server/services/courses_service.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'dart:math' as math;

class CoursesListScreen extends StatefulWidget {
  const CoursesListScreen({super.key});

  @override
  State<CoursesListScreen> createState() => _CoursesListScreenState();
}

class _CoursesListScreenState extends State<CoursesListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 50),
              CoursesList(),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class CoursesList extends StatefulWidget {
  final int? limit;

  const CoursesList({super.key, this.limit});

  @override
  State<CoursesList> createState() => _CoursesListState();
}

class _CoursesListState extends State<CoursesList> {
  void _refreshPage(){
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery
        .of(context)
        .size
        .width > 800;
    final coursesService = CoursesService();
    final TextStyle detailStyle = TextStyle(
        color: Colors.blueGrey,
        fontSize: 14
    );
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: coursesService.getCoursesList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text(AppTexts.noData);
        } else {
          final courses = snapshot.data!;
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
                      itemCount: widget.limit == null
                          ? courses.length
                          : math.min(widget.limit ?? 0, courses.length),

                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: isDesktop ? 1 : 0.8,
                      ),
                      itemBuilder: (context, index) {
                        final singleCourse = courses[index];
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
                                child: Image.network(
                                  singleCourse['img_url'] ?? '',
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image_not_supported),
                                ),
                              ),
                              Text(
                                singleCourse['title'] ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 30,),
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 6),
                                      Text(
                                          '${AppTexts.registrants}: ${singleCourse['registrants'] ?? ''} نفر',
                                          style: detailStyle
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                          '${AppTexts.crsType}: ${singleCourse['type'] ?? ''}',
                                          style: detailStyle
                                      ),
                                      const SizedBox(height: 6),
                                      SizedBox(
                                        height: 22,
                                        child:
                                        singleCourse['hall_title'] == null
                                            ? const SizedBox.shrink()
                                            : Text(
                                          '${AppTexts.hostHall}: ${singleCourse['hall_title']}',
                                          style: detailStyle,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      SizedBox(
                                        height: 22,
                                        child:
                                        singleCourse['halls'] == null
                                            ? const SizedBox.shrink()
                                            : Text(
                                            '${AppTexts.capacity}: ${singleCourse['halls']?['capacity'] ?? ''} نفر',
                                            style: detailStyle
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '${AppTexts.registrationFee}: ${singleCourse['cost'] ?? 0}',
                                        style: detailStyle,
                                      ),
                                    ],
                                  ),
                                ),

                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: SizedBox(
                                  width: 160,
                                  height: 40,
                                  child: Center(
                                    child: RegisterButton(
                                      courseId: singleCourse['id'],
                                      onRefresh: _refreshPage,
                                      isInBasket: singleCourse['status'] == 'in_basket',
                                    ),
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
    );
  }
}

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    super.key,
    required this.courseId,
    required this.isInBasket,
    required this.onRefresh,
  });

  final int courseId;
  final bool isInBasket;
  final VoidCallback onRefresh;
  @override
  Widget build(BuildContext context) {
    final coursesService = CoursesService();
    return ElevatedButton(
      onPressed: () async {
        isInBasket
            ? await coursesService.deleteCourseFromBasket(context, courseId)
            : await coursesService.addShoppingBasket(context, courseId)
        ;
        onRefresh();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isInBasket ?  Colors.redAccent : Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isInBasket ? AppTexts.removeFromBasket
                : AppTexts.addingToBasket,
            style: TextStyle(color: Colors.white)
          ),
          // Icon(Icons.add_circle, color: Colors.white),
        ],
      ),
    );
  }
}

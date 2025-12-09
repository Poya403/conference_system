import 'package:flutter/material.dart';
import 'package:conference_system/server/services/courses_service.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:conference_system/utils/date_converter.dart';
class RegisteredCourses extends StatefulWidget {
  const RegisteredCourses({super.key});

  @override
  State<RegisteredCourses> createState() => _RegisteredCoursesState();
}

class _RegisteredCoursesState extends State<RegisteredCourses> {
  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    final coursesService = CoursesService();
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: coursesService.myCoursesList('registered'),
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
                      Expanded(
                        child: GridView.builder(
                          itemCount: myCourses.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: isDesktop ? 1 : 0.8,
                          ),
                          itemBuilder: (context, index) {
                            final singleCourse = myCourses[index];
                            final startTime = singleCourse['courses']['start_time'];
                            final endTime = singleCourse['courses']['end_time'];
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
                                      singleCourse['courses']['img_url'] ?? '',
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
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          singleCourse['courses']['title'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepPurpleAccent,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '${AppTexts.registrants} : ${singleCourse['courses']['registrants'] ?? ''}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '${AppTexts.holdingDate} : '
                                              '${AppTexts.day} ${getPersianWeekday(startTime ?? '')} - '
                                              '${getPersianDate(startTime ?? '')}',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepPurple
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '${AppTexts.startTime} : '
                                              '${getPersianTime(startTime ?? '')}',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepPurple
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '${AppTexts.endTime} : '
                                              '${getPersianTime(endTime ?? '')}',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepPurple
                                          ),
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
    );
  }
}

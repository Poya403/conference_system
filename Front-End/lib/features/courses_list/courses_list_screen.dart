import 'package:conference_system/features/courses_list/panels/course_info.dart';
import 'package:conference_system/utils/format_price.dart';
import 'package:conference_system/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/server/services/courses_service.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:conference_system/features/courses_list/panels/search_box.dart';
import 'package:conference_system/models/course_filter.dart';

enum CrsPageType {
  coursesList,
  courseInfo,
}

class CoursesListScreen extends StatefulWidget {
  const CoursesListScreen({super.key});

  @override
  State<CoursesListScreen> createState() => _CoursesListScreenState();
}

class _CoursesListScreenState extends State<CoursesListScreen> {
  final coursesService = CoursesService();
  final ValueNotifier<List<Map<String, dynamic>>> coursesNotifier = ValueNotifier([]);
  final ValueNotifier<bool> loadingNotifier = ValueNotifier(false);
  late Widget coursesListPage;
  CrsPageType _currentPageType = CrsPageType.coursesList;
  int? _selectedCourseId;

  @override
  void initState() {
    super.initState();
    _loadAllCourses();

    coursesListPage = ValueListenableBuilder<bool>(
      valueListenable: loadingNotifier,
      builder: (context, loading, _) {
        if (loading) {
          return const Center(child: CircularProgressIndicator());
        }
        return ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: coursesNotifier,
          builder: (context, courses, _) {
            if (courses.isEmpty) {
              return NoDataWidget();
            }
            return CoursesList(
              courses: courses,
              onRefresh: _loadAllCourses,
              onChangedPage: onChangedPage,
            );
          },
        );
      },
    );
  }

  void onChangedPage(CrsPageType page, {int? cid}) {
    setState(() {
      _currentPageType = page;
      _selectedCourseId = cid;
    });
  }

  bool get showSearchBox => _currentPageType == CrsPageType.coursesList;

  Widget get currentPage {
    switch (_currentPageType) {
      case CrsPageType.coursesList:
        return coursesListPage;

      case CrsPageType.courseInfo:
        return CourseInfoScreen(
          cid: _selectedCourseId!,
        );
    }
  }

  Future<void> _onSearch(CourseFilter filter) async {
    loadingNotifier.value = true;
    final result = await coursesService.searchCourse(filter);
    coursesNotifier.value = result;
    loadingNotifier.value = false;
  }

  Future<void> _loadAllCourses() async {
    loadingNotifier.value = true;
    final result = await coursesService.getCoursesList();
    coursesNotifier.value = result;
    loadingNotifier.value = false;
  }

  @override
  void dispose() {
    coursesNotifier.dispose();
    loadingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    Widget searchBox = SearchBox(onSearch: _onSearch);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isDesktop
            ? SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(showSearchBox)...[
                      SizedBox(width: 280, child: searchBox),
                      const SizedBox(width: 16)
                    ],
                    Expanded(child: currentPage),
                  ],
                ),
              )
            : SingleChildScrollView(
              child: Column(
                  children: [
                    if(showSearchBox)...[
                      searchBox,
                      const SizedBox(height: 16)
                    ],
                    currentPage,
                  ],
                ),
            ),
      ),
    );
  }
}

class CoursesList extends StatefulWidget {
  final List<Map<String, dynamic>> courses;
  final int? limit;
  final VoidCallback? onRefresh;
  final Function(CrsPageType page, {int? cid})? onChangedPage;

  const CoursesList({
    super.key,
    required this.courses,
    this.limit,
    this.onRefresh,
    this.onChangedPage,
  });

  @override
  State<CoursesList> createState() => _CoursesListState();
}

class _CoursesListState extends State<CoursesList> {
  @override
  Widget build(BuildContext context) {
    final displayCourses = widget.courses
        .take(widget.limit ?? widget.courses.length)
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1;
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth > 800) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth > 500) {
          crossAxisCount = 2;
        }

        double cardWidth =
            (constraints.maxWidth - 16 * (crossAxisCount - 1)) / crossAxisCount;
        double estimatedCardHeight = 450;
        double childAspectRatio = cardWidth / estimatedCardHeight;

        return SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayCourses.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: childAspectRatio,
              ),
              itemBuilder: (context, index) {
                return CourseCard(
                  singleCourse: displayCourses[index],
                  onRefresh: widget.onRefresh,
                  onChangedPage: widget.onChangedPage,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.singleCourse,
    this.onRefresh,
    this.onChangedPage,
  });

  final Function(CrsPageType, {int? cid})? onChangedPage;
  final Map<String, dynamic> singleCourse;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final TextStyle detailStyle = TextStyle(
      color: Colors.blueGrey,
      fontSize: 14,
    );
    final imgUrl = singleCourse['img_url'];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              child: imgUrl == null || imgUrl.isEmpty
                  ? const Icon(Icons.image_not_supported, size: 120)
                  : Image.network(
                      imgUrl,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported),
                    ),
            ),
            Text(
              singleCourse['title'] ?? '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Column(
                spacing: 6,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppTexts.registrants}: ${singleCourse['registrants'] ?? ''} نفر',
                    style: detailStyle,
                  ),
                  Text(
                    '${AppTexts.registrationFee}: '
                        '${formatPrice(singleCourse['cost'] ?? 0)}',
                    style: detailStyle,
                  ),
                  Text(
                    '${AppTexts.crsType}: ${singleCourse['delivery_type'] ?? ''}',
                    style: detailStyle,
                  ),
                  SizedBox(
                    height: 22,
                    child: singleCourse['hall_title'] == null
                        ? const SizedBox.shrink()
                        : Text(
                            '${AppTexts.hostHall}: ${singleCourse['hall_title']}',
                            style: detailStyle,
                          ),
                  ),
                  SizedBox(
                    height: 22,
                    child: singleCourse['capacity'] == null
                        ? const SizedBox.shrink()
                        : Text(
                            '${AppTexts.capacity}: ${singleCourse['capacity'] ?? ''} نفر',
                            style: detailStyle,
                          ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: SizedBox(
                width: 160,
                height: 70,
                child: Center(
                  child: Column(
                    children: [
                      RegisterButton(
                        courseId: singleCourse['id'],
                        onRefresh: onRefresh ?? () {},
                        isInBasket: singleCourse['status'] == 'in_basket',
                      ),
                      DetailButton(
                          cid: singleCourse['id'],
                          onChangedPage: onChangedPage,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailButton extends StatelessWidget {
  const DetailButton({this.onChangedPage, required this.cid, super.key});

  final Function(CrsPageType, {int? cid})? onChangedPage;
  final int cid;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onChangedPage?.call(CrsPageType.courseInfo, cid: cid),
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      child: Text(AppTexts.moreDetails),
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
            : await coursesService.addShoppingBasket(context, courseId);
        onRefresh();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isInBasket ? Colors.redAccent : Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isInBasket ? AppTexts.removeFromBasket : AppTexts.addingToBasket,
            style: TextStyle(color: Colors.white),
          ),
          // Icon(Icons.add_circle, color: Colors.white),
        ],
      ),
    );
  }
}
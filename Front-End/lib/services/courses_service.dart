import 'package:conference_system/data/DTOs/course_filter.dart';
import 'package:conference_system/data/models/courses.dart';
import 'package:conference_system/data/repositories/courses_repository.dart';

class CourseService {
  final CoursesRepository coursesRepository = CoursesRepository();

  Future<List<Course>> getCoursesList({
    required int uid,
    required String category,
    CourseFilterDTO? filter
  }) {
    return coursesRepository.getCoursesList(
      uid: uid,
      category: category,
      filter: filter
    );
  }

  Future<Course> getSingleCourse(int cid) async {
    return await coursesRepository.getSingleCourse(cid);
  }
}



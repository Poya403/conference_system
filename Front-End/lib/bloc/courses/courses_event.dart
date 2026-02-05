import 'package:conference_system/data/models/course_filter.dart';
import 'package:conference_system/enums/course_category.dart';
import 'package:equatable/equatable.dart';

abstract class CoursesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCoursesList extends CoursesEvent {
  final int uid;
  final CourseCategory category;

  GetCoursesList(this.uid, this.category);

  @override
  List<Object?> get props => [uid, category];
}

class ToggleBasket extends CoursesEvent {
  final int uid;
  final int cid;
  final CourseCategory category;

  ToggleBasket({
    required this.uid,
    required this.cid,
    required this.category
  });

  @override
  List<Object?> get props => [uid, cid, category];
}

class SearchCourses extends CoursesEvent {
  final int uid;
  final CourseCategory category;
  final CourseFilterDTO? filterDTO;

  SearchCourses({
    required this.uid,
    required this.category,
    this.filterDTO
  });

  @override
  List<Object?> get props => [uid, category, filterDTO ?? null];
}

// class GetSingleCourse extends CoursesEvent {
//   final int cid;
//
//   GetSingleCourse(
//     this.cid
//   );
//   @override
//   List<Object?> get props => [cid];
// }

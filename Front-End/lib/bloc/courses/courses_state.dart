import 'package:conference_system/data/models/courses.dart';
import 'package:equatable/equatable.dart';

abstract class CoursesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CourseInitial extends CoursesState {}
class CourseLoading extends CoursesState {}

class CoursesLoaded extends CoursesState {
  final List<Course> courses;

  CoursesLoaded(this.courses);

  @override
  List<Object?> get props => [courses];
}

class CoursesActionSuccess extends CoursesState {
  final String message;
  CoursesActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class CoursesError extends CoursesState {
  final String message;
  CoursesError(this.message);

  @override
  List<Object?> get props => [message];
}

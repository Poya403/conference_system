import 'package:equatable/equatable.dart';

abstract class EnrollmentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchEnrollments extends EnrollmentEvent {
  final int uid;

  FetchEnrollments({required this.uid});

  @override
  List<Object?> get props => [uid];
}

class FetchEnrollmentsByCourse extends EnrollmentEvent {
  final int courseId;
  FetchEnrollmentsByCourse({required this.courseId});

  @override
  List<Object?> get props => [courseId];
}

class FinalizeSingleEnrollment extends EnrollmentEvent {
  final int userId;
  final int courseId;

  FinalizeSingleEnrollment({
    required this.userId,
    required this.courseId,
  });
}
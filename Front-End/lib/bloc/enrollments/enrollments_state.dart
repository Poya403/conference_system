import 'package:equatable/equatable.dart';
import 'package:conference_system/data/DTOs/enrollment_dto.dart';

abstract class EnrollmentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EnrollmentInitial extends EnrollmentState {}

class EnrollmentLoading extends EnrollmentState {}

class EnrollmentsLoaded extends EnrollmentState {
  final List<EnrollmentDto> enrollments;

  EnrollmentsLoaded(this.enrollments);

  @override
  List<Object?> get props => [enrollments];
}

class EnrollmentError extends EnrollmentState {
  final String message;

  EnrollmentError(this.message);

  @override
  List<Object?> get props => [message];
}

class EnrollmentActionSuccess extends EnrollmentState {
  final String message;

  EnrollmentActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

import 'package:equatable/equatable.dart';
import 'package:conference_system/data/models/enrollments.dart';

abstract class EnrollmentsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EnrollmentsInitial extends EnrollmentsState {}

class EnrollmentsLoading extends EnrollmentsState {}

class EnrollmentsLoaded extends EnrollmentsState {
  final List<Enrollment> enrollments;

  EnrollmentsLoaded({required this.enrollments});

  @override
  List<Object?> get props => [enrollments];
}

class EnrollmentsError extends EnrollmentsState {
  final String message;

  EnrollmentsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class EnrollmentActionSuccess extends EnrollmentsState {
  final String message;

  EnrollmentActionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

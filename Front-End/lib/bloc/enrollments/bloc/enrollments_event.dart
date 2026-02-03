import 'package:equatable/equatable.dart';

abstract class EnrollmentsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchEnrollments extends EnrollmentsEvent {
  final int uid;

  FetchEnrollments({required this.uid});

  @override
  List<Object?> get props => [uid];
}

// class HandleEnrollmentCapacity extends EnrollmentsEvent {
//   final int uid;
//   final int cid;
//
//   HandleEnrollmentCapacity({required this.uid, required this.cid});
//
//   @override
//   List<Object?> get props => [uid, cid];
// }

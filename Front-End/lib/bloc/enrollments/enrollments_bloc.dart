import 'package:conference_system/data/repositories/enrollments_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'enrollments_event.dart';
import 'enrollments_state.dart';

class EnrollmentsBloc extends Bloc<EnrollmentEvent, EnrollmentState> {
  final EnrollmentsRepository repository;

  EnrollmentsBloc({required this.repository}) : super(EnrollmentInitial()) {
    on<FetchEnrollmentsByCourse>((event, emit) async {
      emit(EnrollmentLoading());
      try {
        final enrollments = await repository.getEnrollmentsByCourse(
            event.courseId);
        emit(EnrollmentsLoaded(enrollments));
      } catch (e) {
        emit(EnrollmentError(e.toString()));
      }
    });

    on<FinalizeSingleEnrollment>((event, emit) async {
      emit(EnrollmentLoading());

      try {
        final success = await repository.finalizeSingleEnrollment(
          uid: event.userId,
          cid: event.courseId,
        );

        if (success) {
          emit(EnrollmentActionSuccess('ثبت‌نام نهایی با موفقیت انجام شد'));
        } else {
          emit(EnrollmentError('ثبت‌نام نهایی انجام نشد'));
        }
      } catch (e) {
        emit(EnrollmentError('خطای غیرمنتظره رخ داد'));
      }
    });
  }
}

import 'package:conference_system/data/repositories/enrollments_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'enrollments_event.dart';
import 'enrollments_state.dart';

class EnrollmentsBloc extends Bloc<EnrollmentsEvent, EnrollmentsState> {
  final EnrollmentsRepository repository;

  EnrollmentsBloc({required this.repository}) : super(EnrollmentsInitial()) {
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'reservation_event.dart';
import 'reservation_state.dart';
import 'package:conference_system/data/models/reservations.dart';
import 'package:conference_system/data/repositories/reservations_repository.dart';

class ReservationBloc extends Bloc<ReservationEvent, ReservationState> {
  final ReservationRepository repository;

  ReservationBloc({required this.repository}) : super(ReservationInitial()) {
    on<FetchReservationsByHall>(_onFetchReservationsByHall);
  }

  Future<void> _onFetchReservationsByHall(
      FetchReservationsByHall event, Emitter<ReservationState> emit) async {
    emit(ReservationLoading());
    try {
      final List<Reservation> reservations =
          await repository.fetchReservationsByHall(event.hallId);
      emit(ReservationLoaded(reservations));
    } catch (e) {
      emit(ReservationError(e.toString()));
    }
  }
}

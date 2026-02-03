import 'package:equatable/equatable.dart';
import 'package:conference_system/data/models/reservations.dart';

abstract class ReservationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReservationInitial extends ReservationState {}

class ReservationLoading extends ReservationState {}

class ReservationLoaded extends ReservationState {
  final List<Reservation> reservations;
  ReservationLoaded(this.reservations);

  @override
  List<Object?> get props => [reservations];
}

class ReservationError extends ReservationState {
  final String message;
  ReservationError(this.message);

  @override
  List<Object?> get props => [message];
}

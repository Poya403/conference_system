import 'package:equatable/equatable.dart';

abstract class ReservationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchReservationsByHall extends ReservationEvent {
  final int hallId;
  FetchReservationsByHall(this.hallId);

  @override
  List<Object?> get props => [hallId];
}
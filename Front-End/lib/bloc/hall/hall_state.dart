import 'package:equatable/equatable.dart';
import 'package:conference_system/data/models/halls.dart';

abstract class HallState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HallInitial extends HallState {}

class HallLoading extends HallState {}

class HallListSuccess extends HallState {
  final List<Hall> halls;

  HallListSuccess(this.halls);

  @override
  List<Object?> get props => [halls];
}

class SingleHallSuccess extends HallState {
  final Hall hall;

  SingleHallSuccess(this.hall);

  @override
  List<Object?> get props => [hall];
}

class SingleHallFailure extends HallState {
  final String message;

  SingleHallFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class HallListFailure extends HallState {
  final String message;

  HallListFailure(this.message);

  @override
  List<Object?> get props => [message];
}
import 'package:equatable/equatable.dart';

abstract class HallEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetHallsList extends HallEvent {
  @override
  List<Object?> get props => [];
}

class GetSingleHall extends HallEvent {
  final int hid;

  GetSingleHall(this.hid);

  @override
  List<Object?> get props => [hid];
}
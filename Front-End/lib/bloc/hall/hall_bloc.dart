import 'package:conference_system/services/hall_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'hall_event.dart';
import 'hall_state.dart';
import 'dart:async';

class HallBloc extends Bloc<HallEvent, HallState> {
  final HallService _hallService;

  HallBloc({required HallService hallService})
      : _hallService = hallService,
        super(HallInitial()) {
    on<GetHallsList>(_onGetHallsList);
    on<GetSingleHall>(_onGetSingleHall);
  }

  Future<void> _onGetHallsList(
      GetHallsList event,
      Emitter<HallState> emit,
      ) async {
    emit(HallLoading());

    try {
      final halls = await _hallService.getAllHalls();

      if (halls.isEmpty) {
        emit(HallListSuccess(halls));
      } else {
        emit(HallListSuccess(halls));
      }
    } catch (e) {
      emit(HallListFailure(
        e is Exception ? e.toString() : 'خطای ناشناخته در دریافت لیست سالن‌ها',
      ));
    }
  }

  Future<void> _onGetSingleHall(GetSingleHall event, Emitter<HallState> emit) async {
    emit(HallLoading());
    try {
      final hall = await _hallService.getSingleHall(event.hid);

      emit(SingleHallSuccess(hall));

    } catch (e) {
      emit(SingleHallFailure(
        e is Exception ? e.toString() : 'خطای ناشناخته در دریافت اطلاعات سالن',
      ));
    }
  }
  void refreshHalls() {
    add(GetHallsList());
  }
}
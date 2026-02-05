import 'package:conference_system/data/repositories/hall_repository.dart';
import 'package:conference_system/data/models/halls.dart';

class HallService{
  final HallRepository hallRepository = HallRepository();

  Future<List<Hall>> getAllHalls() async{
    return await hallRepository.getHallLists();
  }

  Future<Hall> getSingleHall(int hid) async {
    return await hallRepository.getSingleHall(hid);
  }
}
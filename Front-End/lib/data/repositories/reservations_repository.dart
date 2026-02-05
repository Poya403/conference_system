import 'package:conference_system/data/models/reservations.dart';
import 'package:conference_system/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReservationRepository {
  Future<List<Reservation>> fetchReservationsByHall(int hid) async {
      final response = await http.get(GetUri.reservationOfHalls(hid));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((e) => Reservation.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load reservations');
      }
  }
}


import 'package:conference_system/data/models/halls.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:conference_system/config/api_config.dart';

class HallRepository{
  Future<List<Hall>> getHallLists() async {
    try {
      final url = GetUri.halls;
      final response = await http.get(
        url,
        headers: {"Content-Type" : "application/json"},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => Hall.fromJson(e)).toList();
      } else {
        throw Exception('خطا در دریافت لیست سالن‌ها');
      }
    } catch (e) {
      return [];
    }
  }

  Future<Hall> getSingleHall(int hid) async {
    try{
      final url = GetUri.singleHall(hid);
      final response = await http.get(url);

      if(response.statusCode == 200){
        final data = json.decode(response.body);
        return Hall.fromJson(data);
      } else {
        throw Exception('خطا در دریافت اطلاعات سالن');
      }
    } catch(e){
      throw Exception('$e خطا در دریافت اطلاعات : ');
    }
  }
}
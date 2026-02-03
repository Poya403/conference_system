import 'package:flutter/material.dart';

class Reservation {
  final int id;
  final int cid;
  final int hid;
  final DateTime holdingDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String status;
  final String courseTitle;
  Reservation({
    required this.id,
    required this.cid,
    required this.hid,
    required this.holdingDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.courseTitle
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      cid: json['cid'],
      hid: json['hid'],
      holdingDate: DateTime.parse(json['holdingDate']),
      startTime: TimeOfDay(
          hour: int.parse(json['startTime'].split(':')[0]),
          minute: int.parse(json['startTime'].split(':')[1])),
      endTime: TimeOfDay(
          hour: int.parse(json['endTime'].split(':')[0]),
          minute: int.parse(json['endTime'].split(':')[1])),
      status: json['statusType'],
      courseTitle: json['courseName']
    );
  }
}

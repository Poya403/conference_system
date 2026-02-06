import 'course_types.dart';

class Course {
  final int id;
  final String title;
  final int crsTypeId;
  final String deliveryType;
  final double cost;
  final String? description;
  final DateTime createdAt;
  final String contactPhone;
  final int uid;
  final CourseType? courseType;
  int paymentStatus;

  Course({
    required this.id,
    required this.title,
    required this.crsTypeId,
    required this.deliveryType,
    required this.cost,
    this.description,
    DateTime? createdAt,
    required this.contactPhone,
    int? uid,
    this.courseType,
    required this.paymentStatus,
  })  : createdAt = createdAt ?? DateTime.now(),
        uid = uid ?? 0;

  bool get isInBasket => paymentStatus == 1;

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      crsTypeId: json['courseTypeId'] as int? ?? 0,
      deliveryType: json['deliveryType'] as String? ?? '',
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String?,
      contactPhone: json['contactPhone'] as String? ?? '',
      courseType: CourseType(
        id: json['courseType']?['id'] as int? ?? 0,
        title: json['courseType']?['title'] as String? ?? '',
      ),
      paymentStatus: _mapUserStatus(json['userStatus'] as String? ?? 'Available'),
    );
  }

  static int _mapUserStatus(String status) {
    switch (status) {
      case 'InBasket':
        return 1;
      case 'Registered':
        return 2;
      case 'InWaiting':
        return 3;
      case 'Cancelled':
        return 4;
      default:
        return 0;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'courseTypeId': crsTypeId,
      'deliveryType': deliveryType,
      'cost': cost,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'contactPhone': contactPhone,
      'uid': uid,
      'courseType': courseType?.toJson(),
      'paymentStatus': paymentStatus,
    };
  }
}

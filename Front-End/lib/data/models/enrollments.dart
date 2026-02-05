import 'package:conference_system/enums/payment_status_enum.dart';

class Enrollment {
  final int id;
  final int userId;
  final int courseId;
  final DateTime enrollDate;
  final PaymentStatusEnum paymentStatus;
  final double paymentAmount;

  Enrollment({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.enrollDate,
    required this.paymentStatus,
    required this.paymentAmount,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      id: json['id'],
      userId: json['user_id'],
      courseId: json['course_id'],
      enrollDate: DateTime.parse(json['enroll_date']),
      paymentStatus: paymentStatusFromInt(json['payment_status']),
      paymentAmount: (json['payment_amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'course_id': courseId,
      'payment_status': paymentStatusToInt(paymentStatus),
      'payment_amount': paymentAmount,
    };
  }
}

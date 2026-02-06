class EnrollmentDto {
  final int id;
  final DateTime enrollDate;
  final String paymentStatus;
  final int courseId;
  final String courseTitle;
  final String deliveryType;
  final double cost;
  final String? courseDescription;
  final String contactPhone;
  final int userId;
  final String userFullName;
  final String? userPhoneNumber;

  EnrollmentDto({
    required this.id,
    required this.enrollDate,
    required this.paymentStatus,
    required this.courseId,
    required this.courseTitle,
    required this.deliveryType,
    required this.cost,
    this.courseDescription,
    required this.contactPhone,
    required this.userId,
    required this.userFullName,
    this.userPhoneNumber
  });

  factory EnrollmentDto.fromJson(Map<String, dynamic> json) {
    return EnrollmentDto(
      id: json['id'] as int,
      enrollDate: DateTime.parse(json['enrollDate'] as String),
      paymentStatus: json['paymentStatus'] as String,
      courseId: json['courseId'] as int,
      courseTitle: json['courseTitle'] as String,
      deliveryType: json['deliveryType'] as String,
      cost: (json['cost'] as num).toDouble(),
      courseDescription: json['courseDescription'] as String?,
      contactPhone: json['contactPhone'] as String,
      userId: json['userId'] as int,
      userFullName: json['userFullName'] as String,
      userPhoneNumber: json['userPhoneNumber'] as String?,
    );
  }
}

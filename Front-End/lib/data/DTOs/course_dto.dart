class CourseDto {
  final int id;
  final String title;
  final double cost;
  final String deliveryType;
  final String? description;
  final String courseTypeTitle;
  final int ownerId;
  final String ownerFullName;
  final String contactPhone;
  final int? hallId;
  final String? hallName;
  final String? hallCity;
  final String? hallAddress;

  CourseDto({
    required this.id,
    required this.title,
    required this.cost,
    required this.deliveryType,
    this.description,
    required this.courseTypeTitle,
    required this.ownerId,
    required this.ownerFullName,
    required this.contactPhone,
    this.hallId,
    this.hallName,
    this.hallCity,
    this.hallAddress,
  });

  factory CourseDto.fromJson(Map<String, dynamic> json) {
    return CourseDto(
      id: json['id'] as int,
      title: json['title'] as String,
      cost: (json['cost'] as num).toDouble(),
      deliveryType: json['deliveryType'] as String,
      description: json['description'] as String?,
      courseTypeTitle: json['courseTypeTitle'] as String,
      ownerId: json['ownerId'] as int,
      ownerFullName: json['ownerFullName'] as String,
      contactPhone: json['contactPhone'] as String,
      hallId: json['hallId'] as int?,
      hallName: json['hallName'] as String?,
      hallCity: json['hallCity'] as String?,
      hallAddress: json['hallAddress'] as String?
    );
  }
}

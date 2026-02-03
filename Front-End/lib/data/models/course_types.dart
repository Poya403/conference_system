class CourseType {
  final int id;
  final String title;

  CourseType({
    required this.id,
    required this.title,
  });

  factory CourseType.fromJson(Map<String, dynamic> json) {
    return CourseType(
      id: json['courseTypeId'] as int? ?? 0,
      title: json['courseTypeTitle'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseTypeId': id,
      'courseTypeTitle': title,
    };
  }
}

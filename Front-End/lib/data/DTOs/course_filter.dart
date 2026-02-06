class CourseFilterDTO {
  final int? crsTypeId;
  final String? deliveryType;
  final double? minCost;
  final double? maxCost;
  final String? contactPhone;
  final String? courseTitle;

  CourseFilterDTO({
    this.crsTypeId,
    this.deliveryType,
    this.minCost,
    this.maxCost,
    this.contactPhone,
    this.courseTitle,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (crsTypeId != null) data['courseTypeId'] = crsTypeId;
    if (deliveryType != null) data['deliveryType'] = deliveryType;
    if (minCost != null) data['minCost'] = minCost;
    if (maxCost != null) data['maxCost'] = maxCost;
    if (contactPhone != null && contactPhone!.isNotEmpty) data['contactPhone'] = contactPhone;
    if (courseTitle != null && courseTitle!.isNotEmpty) data['courseTitle'] = courseTitle;
    return data;
  }
}

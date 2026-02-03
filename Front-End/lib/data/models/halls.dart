class Hall {
  final int id;
  final String title;
  final String? description;
  final int capacity;
  final String? city;
  final String? phone;
  final String? area;
  final String? address;
  final String? imageUrl;
  final DateTime? createdAt;

  Hall({
    required this.id,
    required this.title,
    required this.description,
    required this.capacity,
    this.phone,
    this.city,
    this.area,
    this.address,
    this.imageUrl,
    required this.createdAt,
  });

  factory Hall.fromJson(Map<String, dynamic> json) {
    return Hall(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      capacity: json['capacity'] as int,
      phone: json['phoneNumber'] as String?,
      city: json['city'] as String?,
      area: json['area'] as String?,
      imageUrl: json['imageUrl'] as String?,
      address: json['address'] as String?,
      createdAt:  json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }
}
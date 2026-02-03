class Amenities{
  final int id;
  final String title;

  Amenities({
    required this.id,
    required this.title
  });

  factory Amenities.fromJson(Map<String, dynamic> json){
    return Amenities(
      id: json['id'] as int,
      title: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'name': title,
    };
  }
}
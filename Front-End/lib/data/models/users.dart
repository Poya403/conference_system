class User {
  final int id;
  final String fullName;
  final String? phone;
  final String email;
  final String role;
  final String? bio;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? lastLogin;

  User({
    required this.id,
    required this.fullName,
    this.phone,
    required this.email,
    required this.role,
    this.bio,
    this.isActive = true,
    this.createdAt,
    this.lastLogin,
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'] as int,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String,
      role: json['role'] as String,
      bio: json['bio'] as String?,
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'])
          : null,
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'email': email,
      'role': role,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
    };
  }
}

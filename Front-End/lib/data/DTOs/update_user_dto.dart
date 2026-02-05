class UpdateUserDto {
  final String? fullName;
  final String? phone;
  final String? bio;
  final String? newPassword;
  final String? oldPassword;

  UpdateUserDto({
    this.fullName,
    this.phone,
    this.bio,
    this.newPassword,
    this.oldPassword
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (fullName != null) data['fullName'] = fullName;
    if (phone != null) data['phone'] = phone;
    if (bio != null) data['bio'] = bio;

    if (newPassword != null || oldPassword != null){
      data['oldPassword'] = oldPassword;
      data['newPassword'] = newPassword;
    }

    return data;
  }
}

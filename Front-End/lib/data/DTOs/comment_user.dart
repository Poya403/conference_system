class CommentUser {
  final int id;
  final String fullName;

  CommentUser({required this.id, required this.fullName});

  factory CommentUser.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return CommentUser(id: 0, fullName: 'Unknown');
    }
    return CommentUser(
      id: json['id'] as int,
      fullName: json['fullName'] as String,
    );
  }
}


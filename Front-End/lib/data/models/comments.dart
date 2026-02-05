import 'package:conference_system/enums/target_type.dart';
import 'comment_user.dart';

class Comment {
  final int id;
  final int targetId;
  final int? parentId;
  final CommentTargetType targetType;
  final String text;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<Comment> replies;
  final CommentUser user;
  final int? score;
  Comment({
    required this.id,
    required this.targetId,
    this.parentId,
    required this.targetType,
    required this.text,
    required this.createdAt,
    this.score,
    this.updatedAt,
    this.replies = const [],
    required this.user
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as int,
      targetId: json['targetId'] as int,
      targetType: CommentTargetType.values.firstWhere(
        (e) =>
            e.name.toLowerCase() ==
            (json['targetType'] as String).toLowerCase(),
      ),
      parentId: json['parentId'] as int?,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      replies: json['replies'] != null
          ? (json['replies'] as List)
          .map((r) => Comment.fromJson(r))
          .toList()
          : [],
      score: json['score'] as int?,
      user: CommentUser.fromJson(json['user'] as Map<String, dynamic>?),
    );
  }
}

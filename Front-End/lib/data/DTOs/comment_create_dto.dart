import 'package:conference_system/enums/target_type.dart';

class CommentCreateDto {
  final CommentTargetType targetType;
  final int targetId;
  final int? parentId;
  final String text;
  final int? score;

  CommentCreateDto({
    required this.targetType,
    required this.targetId,
    this.parentId,
    required this.text,
    this.score,
  });

  Map<String, dynamic> toJson() {
    final map = {
      'targetType': targetType.title,
      'targetId': targetId,
      'text': text,
    };

    if (parentId != null) map['parentId'] = parentId ?? 0;
    if (score != null) map['score'] = score ?? 0;

    return map;
  }
}

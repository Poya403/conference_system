import 'package:conference_system/enums/target_type.dart';
import 'package:equatable/equatable.dart';
import 'package:conference_system/data/DTOs/comment_create_dto.dart';

abstract class CommentEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class GetComments extends CommentEvent{
  final CommentTargetType targetType;
  final int targetId;

  GetComments({
    required this.targetType,
    required this.targetId
  });

  @override
  List<Object?> get props => [targetType, targetId];
}

class PostComment extends CommentEvent{
  final CommentCreateDto newComment;

  PostComment({
    required this.newComment
  });

  @override
  List<Object?> get props => [newComment];
}

class UpdateComment extends CommentEvent{
  final int commentId;
  final CommentCreateDto newComment;

  UpdateComment({
    required this.commentId,
    required this.newComment
  });

  @override
  List<Object?> get props => [commentId, newComment];
}

class DeleteComment extends CommentEvent {
  final int commentId;

  DeleteComment({
    required this.commentId
  });

  @override
  List<Object?> get props => [commentId];
}
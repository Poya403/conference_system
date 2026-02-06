import 'package:equatable/equatable.dart';
import 'package:conference_system/data/models/comments.dart';

abstract class CommentState extends Equatable{
  @override
  List<Object?> get props => [];
}

class CommentInitial extends CommentState {}
class CommentLoading extends CommentState {}
class CommentListSuccess extends CommentState{
  final List<Comment> comments;

  CommentListSuccess(this.comments);
}
class CommentActionSuccess extends CommentState{
  final String message;

  CommentActionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}
class CommentError extends CommentState {
  final String message;

  CommentError({required this.message});

  @override
  List<Object?> get props => [message];
}
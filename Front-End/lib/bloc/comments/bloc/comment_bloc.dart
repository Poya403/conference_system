import 'package:conference_system/bloc/comments/bloc/comment_event.dart';
import 'package:conference_system/data/repositories/comment_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository repository;

  CommentBloc({required this.repository}) : super(CommentInitial()) {
    on<GetComments>((event, emit) async {
      emit(CommentLoading());
      try {
        final comments =
        await repository.getComments(event.targetType, event.targetId);
        emit(CommentListSuccess(comments));
      } catch (e) {
        emit(CommentError(message: e.toString()));
      }
    });

    on<PostComment>((event, emit) async {
      emit(CommentLoading());
      try {
        await repository.createComment(event.newComment);
        emit(CommentActionSuccess(message: 'کامنت با موفقیت ایجاد شد.'));
      } catch (e) {
        emit(CommentError(message: e.toString()));
      }
    });

    on<UpdateComment>((event, emit) async {
      emit(CommentLoading());
      try {
        await repository.updateComment(event.commentId, event.newComment);
        emit(CommentActionSuccess(message: 'کامنت با موفقیت بروزرسانی شد.'));
      } catch (e) {
        emit(CommentError(message: e.toString()));
      }
    });

    on<DeleteComment>((event, emit) async {
      emit(CommentLoading());
      try {
        await repository.deleteComment(event.commentId);
        emit(CommentActionSuccess(message: 'کامنت با موفقیت حذف شد.'));
      } catch (e) {
        emit(CommentError(message: e.toString()));
      }
    });
  }
}

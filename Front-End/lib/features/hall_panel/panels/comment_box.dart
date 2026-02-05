import 'package:conference_system/utils/date_converter.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/widgets/custom_text_fields/comment_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conference_system/bloc/comments/bloc/comment_bloc.dart';
import 'package:conference_system/bloc/comments/bloc/comment_state.dart';
import 'package:conference_system/bloc/comments/bloc/comment_event.dart';
import 'package:conference_system/enums/target_type.dart';
import 'package:conference_system/data/DTOs/comment_create_dto.dart';
import 'package:conference_system/bloc/auth/auth_bloc.dart';
import 'package:conference_system/bloc/auth/auth_state.dart';
import '../../../widgets/title_widgets/title_widget.dart';
import 'package:conference_system/utils/app_texts.dart';

class HComments extends StatefulWidget {
  const HComments({super.key, required this.hid});

  final int hid;

  @override
  State<HComments> createState() => _HCommentsState();
}

class _HCommentsState extends State<HComments> {
  final textController = TextEditingController();
  final textEditController = TextEditingController();
  int? editingCommentId;
  int? userId;

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthBloc>().state;

    if (authState is AuthSuccess) {
      userId = authState.authResponse.userId ?? 0;
    }

    context.read<CommentBloc>().add(
      GetComments(
        targetType: CommentTargetType.hall,
        targetId: widget.hid,
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    textEditController.dispose();
    super.dispose();
  }

  String getDateFormat(DateTime dateServer) {
    final strDate = dateServer.toString();
    return '${getPersianWeekday(strDate)} - '
        '${getPersianDate(strDate)} - '
        '${getPersianTime(strDate)}';
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: isDesktop
            ? MediaQuery.of(context).size.width * 0.55
            : double.infinity,
        child: BlocConsumer<CommentBloc, CommentState>(
          listener: (context, state) {
            if (state is CommentError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is CommentActionSuccess) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
              // Refresh comments after any action
              context.read<CommentBloc>().add(
                GetComments(
                  targetType: CommentTargetType.hall,
                  targetId: widget.hid,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is CommentLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CommentListSuccess) {
              final comments = state.comments;
              return Column(
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: CommentTextField(
                      controller: textController,
                      hintText: AppTexts.yourComment,
                      maxLines: 10,
                      minLines: 3,
                      width: isDesktop
                          ? MediaQuery.of(context).size.width * 0.5
                          : double.infinity,
                      textDirection: TextDirection.rtl,
                      suffixOnPressed: () {
                        if (textController.text.trim().isEmpty) return;

                        final newComment = CommentCreateDto(
                          targetType: CommentTargetType.hall,
                          targetId: widget.hid,
                          parentId: null,
                          text: textController.text.trim(),
                          score: 5,
                        );

                        context.read<CommentBloc>().add(
                          PostComment(newComment: newComment),
                        );
                        textController.clear();
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  TitleWidget(caption: AppTexts.comments, icon: Icons.comment_rounded),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 350,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        final isOwner = comment.user.id == userId;
                        final isEditing = editingCommentId == comment.id;

                        /// Avatar widget
                        final avatar = SizedBox(
                          width: 50,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/default_avatar.png',
                            ),
                          ),
                        );

                        /// Profile info widget
                        final profileInfo = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          textDirection: TextDirection.rtl,
                          children: [
                            Text(
                              comment.user.fullName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: isDesktop ? 16 : 14,
                              ),
                            ),
                            const SizedBox(height: 10),
                            isEditing ? CommentTextField(
                              controller: textEditController,
                              hintText: AppTexts.editComment,
                              textDirection: TextDirection.rtl,
                              prefixOnPressed: () {
                                setState(() => editingCommentId = null);
                              },
                              suffixOnPressed: () {
                                final newComment = CommentCreateDto(
                                  targetType: CommentTargetType.hall,
                                  targetId: widget.hid,
                                  parentId: comment.parentId,
                                  text: textEditController.text.trim(),
                                  score: comment.parentId == null ? 5 : null,
                                );
                                context.read<CommentBloc>().add(
                                  UpdateComment(
                                    commentId: comment.id,
                                    newComment: newComment,
                                  ),
                                );
                                setState(() => editingCommentId = null);
                              },
                            )
                            : Text(
                              textDirection: TextDirection.rtl,
                              comment.text,
                              style: TextStyle(
                                fontSize: isDesktop ? 14 : 12,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              comment.updatedAt == null
                                  ? getDateFormat(comment.createdAt)
                                  : ' ویرایش شده: ${getDateFormat(comment.updatedAt!)}',
                              style: TextStyle(
                                fontSize: isDesktop ? 12 : 10,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        );


                        /// Action Buttons
                        Widget actionButtons = isEditing
                            ? SizedBox.shrink()
                            : Row(
                          children: [
                            DeleteButton(
                              onDeleted: () {
                                context
                                    .read<CommentBloc>()
                                    .add(DeleteComment(commentId: comment.id));
                              },
                            ),
                            const SizedBox(width: 6),
                            EditButton(
                              onPressed: () {
                                textEditController.text = comment.text;
                                setState(() => editingCommentId = comment.id);
                              },
                            ),
                          ],
                        );

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: isDesktop
                                ? Row(
                              textDirection: TextDirection.rtl,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                avatar,
                                const SizedBox(width: 10),
                                Expanded(child: profileInfo),
                                if (isOwner) ...[
                                  const SizedBox(width: 10),
                                  actionButtons,
                                ]
                              ],
                            )
                                : Column(
                              textDirection: TextDirection.rtl,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                avatar,
                                const SizedBox(height: 10),
                                profileInfo,
                                if (isOwner) ...[
                                  const SizedBox(height: 10),
                                  actionButtons,
                                ]
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}


class DeleteButton extends StatelessWidget {
  const DeleteButton({this.onDeleted, super.key});

  final VoidCallback? onDeleted;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onDeleted,
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      child: Icon(Icons.delete_outline_outlined, color: Colors.redAccent),
    );
  }
}

class EditButton extends StatelessWidget {
  const EditButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      child: Icon(Icons.edit_outlined, color: Colors.blueAccent),
    );
  }
}



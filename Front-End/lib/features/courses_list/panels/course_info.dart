import 'package:conference_system/utils/date_converter.dart';
import 'package:conference_system/widgets/comment_box.dart';
import 'package:conference_system/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/server/services/courses_service.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:conference_system/server/services/comments_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CourseInfoScreen extends StatefulWidget {
  const CourseInfoScreen({super.key, required this.cid});

  @override
  State<CourseInfoScreen> createState() => _CourseInfoScreenState();
  final int cid;
}

class _CourseInfoScreenState extends State<CourseInfoScreen> {
  final courseService = CoursesService();
  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery
        .of(context)
        .size
        .width > 800;
    return FutureBuilder<Map<String, dynamic>?>(
      future: courseService.getSingleCourse(widget.cid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return NoDataWidget();
        } else {
          final course = snapshot.data!;

          return Container(
            child: isDesktop
                ? SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection: TextDirection.rtl,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.rtl,
                    children: [
                      CourseInfoBox(course: course),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.rtl,
                    children: [
                      MainContent(course: course),
                      CComments(cid: course['id']),
                    ],
                  ),
                ],
              ),
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: [
                CourseInfoBox(course: course),
                MainContent(course: course),
                CComments(cid: course['id']),
              ],
            ),
          );
        }
      },
    );
  }
}

class CourseInfoBox extends StatefulWidget {
  const CourseInfoBox({super.key, required this.course});

  final Map<String, dynamic> course;

  @override
  State<CourseInfoBox> createState() => _CourseInfoBoxState();
}

class _CourseInfoBoxState extends State<CourseInfoBox> {
  final detailStyle = const TextStyle(
    fontSize: 14,
    color: Colors.blueGrey,
    fontFamily: 'Farsi',
  );

  @override
  Widget build(BuildContext context) {
    final imgUrl = widget.course['img_url'];
    final startTime = widget.course['start_time'];
    final endTime = widget.course['end_time'];
    bool isDesktop = MediaQuery
        .of(context)
        .size
        .width > 800;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: isDesktop ? 300 : 800,
          height: 400,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.white,
            child: Column(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: imgUrl == null || imgUrl.isEmpty
                      ? Center(child: const Icon(Icons.image_not_supported))
                      : Image.network(
                          imgUrl,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) =>
                          Center(
                            child: const Icon(
                              Icons.image_not_supported,
                            ),
                          ),
                        ),
                ),
                SizedBox(height: 10),
                Center(
                  child: SelectableText(
                    textAlign: TextAlign.center,
                    widget.course['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Farsi',
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                ),
                Divider(thickness: 0.75),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    spacing: 6,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        '${AppTexts.price} : ${widget.course['cost'] ?? 'رایگان'} تومان ',
                        style: detailStyle
                      ),
                      SelectableText(
                        '${AppTexts.deliveryType} : ${widget.course['delivery_type'] ?? ''}',
                        style: detailStyle
                      ),
                      SelectableText(
                        '${AppTexts.registrants} : ${widget.course['registrants'] ?? ''}',
                        style: detailStyle
                      ),
                      SelectableText(
                        textDirection: TextDirection.ltr,
                        '${AppTexts.phoneNumber} '
                            ': \u200E${widget.course['phone_number'] ??
                            'ٍثبت نشده'}',
                        style: detailStyle
                      ),
                      Text(
                        '${AppTexts.startTime} : '
                            '${getPersianTime(startTime ?? '')}',
                        style: detailStyle,
                      ),
                      Text(
                        '${AppTexts.endTime} : '
                            '${getPersianTime(endTime ?? '')}',
                        style: detailStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  const MainContent({super.key, required this.course});

  final Map<String, dynamic> course;

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery
        .of(context)
        .size
        .width > 800;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: isDesktop
              ? MediaQuery
              .of(context)
              .size
              .width * 0.55
              : double.infinity,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.white,
            child: Column(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          course['title'],
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      Divider(thickness: 0.75),
                      SelectableText(
                        course['description'] ?? '',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CComments extends StatefulWidget {
  const CComments({super.key, required this.cid});
  final int cid;

  @override
  State<CComments> createState() => _CCommentsState();
}

class _CCommentsState extends State<CComments> {
  final commentsService = CommentsService();
  final textController = TextEditingController();
  final textEditController = TextEditingController();

  late Future<List<Map<String, dynamic>>> futureComments;
  int? editingCommentId;

  SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    futureComments = commentsService.getComments(cid: widget.cid);
  }

  @override
  void dispose() {
    textController.dispose();
    textEditController.dispose();
    super.dispose();
  }

  void reloadComments() {
    setState(() {
      futureComments = commentsService.getComments(cid: widget.cid);
    });
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
        child: Card(
          elevation: 4,
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CommentBox(
                  controller: textController,
                  hintText: 'نظر شما',
                  maxLines: 5,
                  minLines: 3,
                  width: isDesktop
                      ? MediaQuery.of(context).size.width * 0.5
                      : double.infinity,
                  textDirection: TextDirection.rtl,
                  suffixOnPressed: () async {
                    if (textController.text.trim().isEmpty) return;

                    await commentsService.sendComment(
                      context,
                      cid: widget.cid,
                      text: textController.text.trim(),
                    );

                    textController.clear();
                    reloadComments();
                  },
                ),
              ),
              const SizedBox(height: 10),

              SizedBox(
                height: 350,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: futureComments,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return NoDataWidget(
                        title: AppTexts.noComments,
                        icon: Icons.comment_bank_outlined,
                      );
                    }

                    final comments = snapshot.data!;

                    return ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        final isOwner =
                            comment['uid'] == supabase.auth.currentUser!.id;

                        final isEditing =
                            editingCommentId == comment['id'];

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
                              comment['profiles']['fullname'] ??
                                  AppTexts.unKnownUser,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: isDesktop ? 16 : 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              comment['text'] ?? '',
                              style: TextStyle(
                                fontSize: isDesktop ? 14 : 12,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              formatToJalali(comment['created_at'] ?? ''),
                              style: TextStyle(
                                fontSize: isDesktop ? 12 : 10,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        );

                        /// Action Buttons
                        Widget actionButtons = isEditing
                            ? CommentBox(
                          controller: textEditController,
                          hintText: AppTexts.edit,
                          textDirection: TextDirection.rtl,
                          prefixOnPressed: () {
                            setState(() => editingCommentId = null);
                          },
                          suffixOnPressed: () async {
                            await commentsService.updateComment(
                              context,
                              commentId: comment['id'],
                              text: textEditController.text.trim(),
                            );

                            setState(() => editingCommentId = null);
                            reloadComments();
                          },
                        )
                            : Row(
                          children: [
                            DeleteButton(
                              onDeleted: () async {
                                await commentsService.deleteComment(
                                  context,
                                  comment['id'],
                                );
                                reloadComments();
                              },
                            ),
                            const SizedBox(width: 6),
                            EditButton(
                              onPressed: () {
                                textEditController.text =
                                    comment['text'] ?? '';
                                setState(() =>
                                editingCommentId = comment['id']);
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
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
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
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
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
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
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

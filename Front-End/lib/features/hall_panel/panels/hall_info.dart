import 'package:conference_system/utils/date_converter.dart';
import 'package:conference_system/widgets/comment_box.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/server/services/hall_service.dart';
import 'package:conference_system/server/services/amenities_service.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:conference_system/server/services/comments_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HallInfoScreen extends StatefulWidget {
  const HallInfoScreen({super.key, required this.hid});

  @override
  State<HallInfoScreen> createState() => _HallInfoScreenState();
  final int hid;
}

class _HallInfoScreenState extends State<HallInfoScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery
        .of(context)
        .size
        .width > 800;
    final hallService = HallService();
    return FutureBuilder<Map<String, dynamic>?>(
      future: hallService.getSingleHall(widget.hid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text(AppTexts.noData);
        } else {
          final hall = snapshot.data!;

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
                      HallInfoBox(hall: hall),
                      Amenities(hid: hall['id']),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.rtl,
                    children: [
                      MainContent(hall: hall),
                      HComments(hid: hall['id']),
                    ],
                  ),
                ],
              ),
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: [
                HallInfoBox(hall: hall),
                Amenities(hid: hall['id']),
                MainContent(hall: hall),
                HComments(hid: hall['id']),
              ],
            ),
          );
        }
      },
    );
  }
}

class HallInfoBox extends StatefulWidget {
  const HallInfoBox({super.key, required this.hall});

  final Map<String, dynamic> hall;

  @override
  State<HallInfoBox> createState() => _HallInfoBoxState();
}

class _HallInfoBoxState extends State<HallInfoBox> {
  @override
  Widget build(BuildContext context) {
    final imgUrl = widget.hall['img_url'];
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
                      ? const Icon(Icons.image_not_supported)
                      : Image.network(
                          imgUrl,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) =>
                          const Icon(
                            Icons.image_not_supported,
                          ),
                        ),
                ),
                SizedBox(height: 10),
                Center(
                  child: SelectableText(
                    textAlign: TextAlign.center,
                    widget.hall['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Farsi',
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                ),
                Divider(thickness: 0.75),
                DefaultTextStyle(
                  style: TextStyle(
                    fontFamily: 'Farsi',
                    color: Colors.deepPurpleAccent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(
                          '${AppTexts.capacity} : ${widget.hall['capacity'] ??
                              ''} نفر ',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        SelectableText(
                          '${AppTexts.city} : ${widget.hall['city'] ?? ''}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        SelectableText(
                          '${AppTexts.area} : ${widget.hall['area'] ?? ''}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        SelectableText(
                          '${AppTexts.address} : ${widget.hall['address'] ?? ''}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        SelectableText(
                          textDirection: TextDirection.ltr,
                          '${AppTexts
                              .phoneNumber} : \u200E${widget.hall['phone_number'] ??
                              'ٍثبت نشده'}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
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
  const MainContent({super.key, required this.hall});

  final Map<String, dynamic> hall;

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
                          '${AppTexts.description} :',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      Divider(thickness: 0.75),
                      SelectableText(
                        hall['description'] ?? '',
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

class Amenities extends StatelessWidget {
  const Amenities({super.key, required this.hid});

  final int hid;

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery
        .of(context)
        .size
        .width > 800;
    final amenitiesService = AmenitiesService();
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: amenitiesService.getAmenities(hid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text(AppTexts.noData);
        } else {
          final amenities = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: SizedBox(
                width: isDesktop ? 300 : 800,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppTexts.amenities,
                          style: const TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: amenities.map((amenity) {
                            final name = amenity['amenities']['name'] ?? '';
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                name,
                                style: const TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class HComments extends StatefulWidget {
  const HComments({super.key, required this.hid});

  final int hid;

  @override
  State<HComments> createState() => _HCommentsState();
}

class _HCommentsState extends State<HComments> {
  final commentsService = CommentsService();
  final textController = TextEditingController();
  final textEditController = TextEditingController();

  late Future<List<Map<String, dynamic>>> futureComments;
  int? editingCommentId;

  SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    futureComments = commentsService.getHallComments(widget.hid);
  }

  @override
  void dispose() {
    textController.dispose();
    textEditController.dispose();
    super.dispose();
  }

  void reloadComments() {
    setState(() {
      futureComments = commentsService.getHallComments(widget.hid);
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
          child: Column(
            children: [
              const SizedBox(height: 10),

              /// ------------------ INPUT BOX ------------------
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
                      widget.hid,
                      textController.text.trim(),
                    );

                    textController.clear();
                    reloadComments();
                  },
                ),
              ),
              const SizedBox(height: 10),

              /// ------------------ COMMENTS LIST ------------------
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
                      return Center(child: Text(AppTexts.noComments));
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
                              comment['id'],
                              textEditController.text.trim(),
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

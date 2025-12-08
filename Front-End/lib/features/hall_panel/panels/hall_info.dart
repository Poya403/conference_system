import 'package:conference_system/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/server/services/hall_service.dart';
import 'package:conference_system/server/services/amenities_service.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:conference_system/server/services/comments_service.dart';

class HallInfoScreen extends StatefulWidget {
  const HallInfoScreen({super.key, required this.hid});

  @override
  State<HallInfoScreen> createState() => _HallInfoScreenState();
  final int hid;
}

class _HallInfoScreenState extends State<HallInfoScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
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

class HallInfoBox extends StatelessWidget {
  const HallInfoBox({super.key, required this.hall});

  final Map<String, dynamic> hall;

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
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
                  child: Image.network(
                    hall['img_url'],
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: SelectableText(
                    textAlign: TextAlign.center,
                    hall['title'],
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
                          '${AppTexts.capacity} : ${hall['capacity'] ?? ''} نفر ',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        SelectableText(
                          '${AppTexts.city} : ${hall['city'] ?? ''}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        SelectableText(
                          '${AppTexts.area} : ${hall['area'] ?? ''}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        SelectableText(
                          '${AppTexts.address} : ${hall['address'] ?? ''}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        SelectableText(
                          textDirection: TextDirection.ltr,
                          '${AppTexts.phoneNumber} : \u200E${hall['phone_number'] ?? 'ٍثبت نشده'}',
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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: 800,
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
    bool isDesktop = MediaQuery.of(context).size.width > 800;
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

class HComments extends StatelessWidget {
  const HComments({super.key, required this.hid});

  final int hid;

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    final commentsService = CommentsService();
    final textController = TextEditingController();

    return SizedBox(
      width: 800,
      child: Card(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Text(
              AppTexts.comments,
              style: TextStyle(color: Colors.deepPurple, fontSize: 20),
            ),
            Divider(thickness: 0.75),
            SizedBox(height: 10,),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: commentsService.getHallComments(hid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text(AppTexts.noComments));
                } else {
                  final comments = snapshot.data!;
                  return Column(
                    children: [
                      ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      'assets/images/default_avatar.png',
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          comment['userName'] ??
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
                                          comment['created_at'] ?? '',
                                          style: TextStyle(
                                            fontSize: isDesktop ? 12 : 10,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }
              },
            ),
            SizedBox(height: 30,),
            CustomTextField(
              controller: textController,
              labelText: 'نظر شما',
              maxLines: 5,
              minLines: 3,
              width: 750,
            ),
            SizedBox(height: 10,),
            SubmitButton(),
          ],
        ),
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: null,
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.deepPurpleAccent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      child: Text(AppTexts.submit),
    );
  }
}

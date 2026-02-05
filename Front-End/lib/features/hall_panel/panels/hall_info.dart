import 'package:conference_system/widgets/no_data_widget.dart';
import 'package:conference_system/bloc/hall/hall_event.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/bloc/hall/hall_bloc.dart';
import 'package:conference_system/bloc/hall/hall_state.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conference_system/features/hall_panel/panels/comment_box.dart';
import '../../../data/models/halls.dart';


class HallInfoScreen extends StatefulWidget {
  const HallInfoScreen({super.key, required this.hid});

  @override
  State<HallInfoScreen> createState() => _HallInfoScreenState();
  final int hid;
}

class _HallInfoScreenState extends State<HallInfoScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HallBloc>().add(GetSingleHall(widget.hid));
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    return BlocConsumer<HallBloc, HallState>(
      listener: (context, state) {
        if (state is SingleHallFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is HallLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is SingleHallSuccess) {
          final hall = state.hall;
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
                            // Amenities(hid: hall['id']),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          textDirection: TextDirection.rtl,
                          children: [
                            MainContent(hall: hall),
                            HComments(hid: hall.id),
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
                      // Amenities(hid: hall['id']),
                      MainContent(hall: hall),
                      HComments(hid: hall.id),
                    ],
                  ),
          );
        }
        return Center(child: Text(AppTexts.loading));
      },
    );
  }
}

class HallInfoBox extends StatefulWidget {
  const HallInfoBox({super.key, required this.hall});

  final Hall hall;

  @override
  State<HallInfoBox> createState() => _HallInfoBoxState();
}

class _HallInfoBoxState extends State<HallInfoBox> {
  final TextStyle detailStyle = const TextStyle(
    fontSize: 14,
    color: Colors.blueGrey,
  );

  @override
  Widget build(BuildContext context) {
    final imgUrl = widget.hall.imageUrl;
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
                      ? const Icon(Icons.image_not_supported)
                      : Image.network(
                          imgUrl,
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
                    widget.hall.title,
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
                      spacing: 6,
                      children: [
                        SelectableText(
                          '${AppTexts.capacity} : ${widget.hall.capacity} نفر ',
                          style: detailStyle
                        ),
                        SelectableText(
                          '${AppTexts.city} : ${widget.hall.city ?? ''}',
                          style: detailStyle
                        ),
                        SelectableText(
                          '${AppTexts.area} : ${widget.hall.area ?? ''}',
                          style: detailStyle
                        ),
                        SelectableText(
                          '${AppTexts.address} : ${widget.hall.address ?? ''}',
                          style: detailStyle
                        ),
                        SelectableText(
                          textDirection: TextDirection.ltr,
                          '${AppTexts.phoneNumber} : \u200E${widget.hall.phone ?? 'ٍثبت نشده'}',
                          style: detailStyle
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

  final Hall hall;

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: isDesktop
              ? MediaQuery.of(context).size.width * 0.55
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
                          hall.title,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      Divider(thickness: 0.35),
                      (hall.description != null && hall.description!.isNotEmpty)
                          ? Column(
                              children: [
                                SizedBox(height: 20),
                                SelectableText(
                                  hall.description ?? '',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            )
                          : Center(
                              child: NoDataWidget(
                                title: 'اطلاعاتی جهت نمایش یا چاپ وجود ندارد.',
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

// class Amenities extends StatelessWidget {
//   const Amenities({super.key, required this.hid});
//
//   final int hid;
//
//   @override
//   Widget build(BuildContext context) {
//     bool isDesktop = MediaQuery
//         .of(context)
//         .size
//         .width > 800;
//     final amenitiesService = AmenitiesService();
//     return FutureBuilder<List<Map<String, dynamic>>>(
//       future: amenitiesService.getHallAmenities(hid),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Text(AppTexts.noData);
//         } else {
//           final amenities = snapshot.data!;
//
//           return Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Directionality(
//               textDirection: TextDirection.rtl,
//               child: SizedBox(
//                 width: isDesktop ? 300 : 800,
//                 child: Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   color: Colors.white,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           AppTexts.amenities,
//                           style: const TextStyle(
//                             color: Colors.deepPurple,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         Wrap(
//                           spacing: 8,
//                           runSpacing: 8,
//                           children: amenities.map((amenity) {
//                             final name = amenity['amenities']['name'] ?? '';
//                             return Container(
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: 6,
//                                 horizontal: 12,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.deepPurple.shade50,
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Text(
//                                 name,
//                                 style: const TextStyle(
//                                   color: Colors.deepPurple,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }
//       },
//     );
//   }
// }

import 'package:conference_system/features/hall_panel/panels/hall_info.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/server/services/hall_service.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'dart:math' as math;

class HallScreen extends StatefulWidget {
  const HallScreen({super.key});

  @override
  State<HallScreen> createState() => _HallScreenState();
}

class _HallScreenState extends State<HallScreen> {
  late Widget currentPage;

  @override
  void initState() {
    super.initState();
    currentPage = HallList(onChangedPage: onChangedPage);
  }

  void onChangedPage(int index, {int? hid}) {
    setState(() {
      switch (index) {
        case 0:
          currentPage = HallList(onChangedPage: onChangedPage);
          break;
        case 1:
          currentPage = HallInfoScreen(hid: hid ?? 0);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 50),
              currentPage,
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class HallList extends StatelessWidget {
  final int? limit;
  final Function(int, {int? hid})? onChangedPage;

  const HallList({super.key, this.limit, this.onChangedPage});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    final hallService = HallService();
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: hallService.getHallLists(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text(AppTexts.noData);
        } else {
          final halls = snapshot.data!;

          return LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 1;
              if (constraints.maxWidth > 1200) {
                crossAxisCount = 4;
              } else if (constraints.maxWidth > 800) {
                crossAxisCount = 3;
              } else if (constraints.maxWidth > 500) {
                crossAxisCount = 2;
              } else {
                crossAxisCount = 1;
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: math.min(limit ?? halls.length, halls.length),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: isDesktop ? 0.83 : 0.8,
                      ),
                      itemBuilder: (context, index) {
                        final hall = halls[index];
                        final imgUrl = hall['img_url'];

                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(15),
                                ),
                                child:  imgUrl == null || imgUrl.isEmpty
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
                              DefaultTextStyle(
                                style: TextStyle(
                                  fontFamily: 'Farsi',
                                  color: Colors.deepPurpleAccent,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        hall['title'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '${AppTexts.capacity} : ${hall['capacity'] ?? ''} نفر ',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '${AppTexts.area} : ${hall['area'] ?? ''}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      DetailButton(
                                        hid: hall['id'],
                                        onChangedPage: onChangedPage,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

class DetailButton extends StatelessWidget {
  const DetailButton({this.onChangedPage, required this.hid, super.key});

  final Function(int, {int? hid})? onChangedPage;
  final int hid;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onChangedPage?.call(1, hid: hid),
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      child: Text(AppTexts.moreDetails),
    );
  }
}

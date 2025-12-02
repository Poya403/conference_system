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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 50),
              HallList(),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
      floatingActionButton: AddButton(),
    );
  }
}

class HallList extends StatelessWidget {
  final int? limit;
  const HallList({super.key, this.limit});

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
              //  تعیین تعداد ستون‌ها بر اساس عرض صفحه
              int crossAxisCount = 1;
              if (constraints.maxWidth > 1200) {
                crossAxisCount = 4; // لپ‌تاپ و مانیتور بزرگ
              } else if (constraints.maxWidth > 800) {
                crossAxisCount = 3; // تبلت یا لپ‌تاپ کوچک
              } else if (constraints.maxWidth > 500) {
                crossAxisCount = 2; // موبایل افقی یا تبلت کوچک
              } else {
                crossAxisCount = 1; // موبایل عمودی
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
                        childAspectRatio: isDesktop ? 1 : 0.8,
                      ),
                      itemBuilder: (context, index) {
                        final hall = halls[index];
                        return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                  child: Image.network(
                                    hall['img_url'] ?? '',
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.image_not_supported),
                                  ),
                                ),
                                Padding(
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
                                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                      Text(
                                        '${AppTexts.area} : ${hall['area'] ?? ''}',
                                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
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


class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        shape: CircleBorder(),
      ),
      child: SizedBox(
        width: 60,
        height: 60,
        child: Icon(Icons.add, color: Colors.white, size: 25),
      ),
    );
  }
}

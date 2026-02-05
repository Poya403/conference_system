import 'package:conference_system/bloc/hall/hall_event.dart';
import 'package:conference_system/features/hall_panel/panels/hall_info.dart';
import 'package:conference_system/bloc/hall/hall_bloc.dart';
import 'package:conference_system/bloc/hall/hall_state.dart';
import 'package:conference_system/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';

class HallListScreen extends StatefulWidget {
  const HallListScreen({super.key});

  @override
  State<HallListScreen> createState() => _HallListScreenState();
}

class _HallListScreenState extends State<HallListScreen> {
  late Widget currentPage;

  @override
  void initState() {
    super.initState();
    context.read<HallBloc>().add(GetHallsList());
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
    return LayoutBuilder(
      builder: (context, constraints){
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 30),
                IconButton(
                    onPressed: () {
                      onChangedPage.call(0);
                      context.read<HallBloc>().add(GetHallsList());
                    },
                    icon: Icon(Icons.arrow_back)
                ),
                currentPage,
                SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}

class HallList extends StatelessWidget {
  final int? limit;
  final Function(int, {int? hid})? onChangedPage;

  const HallList({super.key, this.limit, this.onChangedPage});
  final responseStyle = const TextStyle(
    fontSize: 14,
    color: Colors.blueGrey,
  );

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;

    return BlocConsumer<HallBloc, HallState>(
      listener: (context, state) {
        if (state is HallListFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if(state is HallInitial){
          return Center(child: Text(AppTexts.initialize));
        } else if (state is HallLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is HallListSuccess) {
          final halls = state.halls;
          if (halls.isEmpty) {
            return Center(child: NoDataWidget(title: 'سالنی جهت نمایش وجود ندارد',));
          }
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

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: math.min(limit ?? halls.length, halls.length),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: isDesktop ? 0.83 : 0.8,
                    ),
                    itemBuilder: (context, index) {
                      final hall = halls[index];
                      final imgUrl = hall.imageUrl;

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
                            DefaultTextStyle(
                              style: TextStyle(
                                fontFamily: 'Farsi',
                                color: Colors.deepPurpleAccent,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  spacing: 6,
                                  children: [
                                    Text(
                                      hall.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${AppTexts.capacity} : ${hall.capacity} نفر ',
                                      style: responseStyle
                                    ),
                                    Text(
                                      '${AppTexts.city} : ${hall.city ?? ''}',
                                      style: responseStyle
                                    ),
                                    Text(
                                      '${AppTexts.area} : ${hall.area ?? ''}',
                                      style: responseStyle
                                    ),
                                    DetailButton(
                                      hid: hall.id,
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
              );
            },
          );
        }
        return SizedBox.shrink();
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

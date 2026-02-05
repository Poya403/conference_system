import 'package:conference_system/bloc/reservations/reservation_bloc.dart';
import 'package:conference_system/bloc/reservations/reservation_event.dart';
import 'package:conference_system/bloc/reservations/reservation_state.dart';
import 'package:conference_system/utils/date_converter.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/widgets/table_config.dart';
import 'package:conference_system/data/models/reservations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:conference_system/widgets/no_data_widget.dart';

class ReservationList extends StatefulWidget {
  const ReservationList({super.key, required this.hallId});

  final int hallId;

  @override
  State<ReservationList> createState() => _ReservationListState();
}

class _ReservationListState extends State<ReservationList> {
  @override
  void initState() {
    super.initState();
    context.read<ReservationBloc>().add(FetchReservationsByHall(widget.hallId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReservationBloc, ReservationState>(
      listener: (context, state) {
        if (state is ReservationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${AppTexts.error} : ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        if (state is ReservationLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ReservationLoaded) {
          final reservations = state.reservations;

          if (reservations.isEmpty) {
            return Center(child: NoDataWidget());
          }

          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 450,
              child: Card(
                elevation: 4,
                shadowColor: Colors.deepPurpleAccent,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 15,
                  children: [
                    TableConfig<Reservation>(
                      title: AppTexts.reservations,
                      data: reservations, // List<Reservation>
                      columns: const [
                        AppTexts.crsTitle,
                        AppTexts.holdingDate,
                        AppTexts.day,
                        AppTexts.startTime,
                        AppTexts.endTime,
                        AppTexts.status,
                        AppTexts.operation,
                      ],
                      rowBuilder: [
                        (r) => Text(r.courseTitle),
                        (r) => DateTimeStyle(
                          dateInput: getPersianDate(r.holdingDate.toString()),
                        ),
                        (r) => Text(
                          getPersianWeekday(r.holdingDate.toString()),
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.blueGrey,
                          ),
                        ),
                        // Start Time
                        (r) => Text(formatTime24(r.startTime)),
                        // End Time
                        (r) => Text(formatTime24(r.endTime)),
                        (r) => StatusLabelStyle(status: r.status),
                        (r) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blueAccent,
                                size: 20,
                              ),
                              onPressed: () {
                                //editReservation(r);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                              onPressed: () {
                                // deleteReservation(r);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: 150, child: AddButton(onPressed: () {})),
                  ],
                ),
              ),
            ),
          );
        }
        return Center(child: Text(AppTexts.loading));
      },
    );
  }
}

class AddButton extends StatelessWidget {
  const AddButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.greenAccent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        spacing: 6,
        children: [
          Icon(Icons.add_circle, color: Colors.white, size: 18),
          Text(
            AppTexts.newReserve,
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

import 'package:conference_system/utils/date_converter.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/widgets/table_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:conference_system/widgets/no_data_widget.dart';
import 'package:conference_system/bloc/enrollments/enrollments_bloc.dart';
import 'package:conference_system/bloc/enrollments/enrollments_state.dart';
import 'package:conference_system/bloc/enrollments/enrollments_event.dart';

import '../../../data/DTOs/enrollment_dto.dart';
import '../../../utils/format_price.dart';

class EnrollmentList extends StatefulWidget {
  const EnrollmentList({super.key, required this.courseId});

  final int courseId;

  @override
  State<EnrollmentList> createState() => _EnrollmentListState();
}

class _EnrollmentListState extends State<EnrollmentList> {
  @override
  void initState() {
    super.initState();
    context.read<EnrollmentsBloc>().add(
      FetchEnrollmentsByCourse(courseId: widget.courseId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EnrollmentsBloc, EnrollmentState>(
      listener: (context, state) {
        if (state is EnrollmentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${AppTexts.error} : ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        if (state is EnrollmentInitial) {
          return Center(child: Text(AppTexts.initialize));
        } else if (state is EnrollmentLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is EnrollmentsLoaded) {
          final enrollments = state.enrollments;

          if (enrollments.isEmpty) {
            return Center(child: NoDataWidget());
          }

          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.77,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 15,
                  children: [
                    TableConfig<EnrollmentDto>(
                      title: AppTexts.enrollments,
                      data: enrollments,
                      columns: [
                        AppTexts.fullName,
                        AppTexts.phoneNumber,
                        AppTexts.deliveryType,
                        AppTexts.crsCost,
                        AppTexts.enrollDate,
                        AppTexts.enrollTime,
                        AppTexts.status,
                        AppTexts.operation,
                      ],
                      rowBuilder: [
                        (r) => Text(r.userFullName),
                        (r) => Text(r.userPhoneNumber.toString()),
                        (r) => Text(r.deliveryType),
                        (r) => Text(formatPrice(r.cost)),
                        (r) => DateTimeStyle(
                          dateInput: getPersianDate(r.enrollDate.toString()),
                        ),
                        (r) => DateTimeStyle(
                          dateInput: getPersianTime(r.enrollDate.toString()),
                        ),
                        (r) => StatusLabelStyle(status: r.paymentStatus),
                        (r) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

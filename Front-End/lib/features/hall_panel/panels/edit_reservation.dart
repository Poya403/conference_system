import 'package:flutter/material.dart';
import 'package:conference_system/widgets/title_widgets/title_widget.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:conference_system/widgets/custom_text_fields/text_form_field.dart';
import 'package:conference_system/widgets/custom_text_fields/drop_down_field.dart';
import 'package:conference_system/widgets/custom_text_fields/custom_persian_date_picked.dart';
import 'package:conference_system/widgets/custom_text_fields/custom_time_field.dart';
import 'package:flutter/services.dart';

class EditReservation extends StatefulWidget {
  const EditReservation({super.key,required this.title, required this.icon});
  final String title;
  final IconData icon;

  @override
  State<EditReservation> createState() => _EditReservationState();
}

class _EditReservationState extends State<EditReservation> {
  final costController = TextEditingController();
  final holdingDateController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  String? selectedType;
  String? selectedDeliveryType;
  late String selectedGregorianDate;

  void fetch(){
  }

  @override
  void initState(){
    super.initState();
    fetch();
  }
  @override
  void dispose(){
    super.dispose();
    costController.dispose();
    holdingDateController.dispose();
    phoneNumberController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
  }
  @override
  Widget build(BuildContext context) {

    bool isDesktop = MediaQuery.of(context).size.width > 800;
    return SizedBox(
      width: isDesktop ? MediaQuery
          .of(context)
          .size
          .width * 0.6 : double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        elevation: 4,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(isDesktop ? 30.0 : 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            textDirection: TextDirection.rtl,
            spacing: 20,
            children: [
              TitleWidget(
                caption: widget.title,
                icon: widget.icon,
                width: 230,
              ),
              Wrap(
                textDirection: TextDirection.rtl,
                spacing: 20,
                runSpacing: 20,
                children: <Widget>[
                  CustomPersianDateField(
                    controller: holdingDateController,
                    labelText: AppTexts.holdingDate,
                    helpText: AppTexts.holdingDate,
                    onDateSelected: (gregorianDate) {
                      selectedGregorianDate = gregorianDate;
                    },
                  ),
                  CustomTimeField(
                    controller: startTimeController,
                    labelText: AppTexts.startTime,
                    helpText: AppTexts.startTime,
                    onTimeSelected: (time) {},
                  ),
                  CustomTimeField(
                    controller: endTimeController,
                    labelText: AppTexts.endTime,
                    helpText: AppTexts.endTime,
                    onTimeSelected: (time) {},
                  ),
                ],
              ),
              SizedBox(height: 10),
              SubmitButton(onPressed: () {}),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    this.onPressed,
    super.key,
  });

  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      child: Column(
        children: [
          Text(
            AppTexts.submit,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
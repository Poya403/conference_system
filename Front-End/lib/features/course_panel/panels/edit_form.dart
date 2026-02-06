import 'package:conference_system/utils/date_converter.dart';
import 'package:conference_system/widgets/title_widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:conference_system/widgets/custom_text_fields/text_form_field.dart';
import 'package:conference_system/widgets/custom_text_fields/drop_down_field.dart';
import 'package:conference_system/widgets/custom_text_fields/custom_persian_date_picked.dart';
import 'package:conference_system/widgets/custom_text_fields/custom_time_field.dart';
import 'package:flutter/services.dart';
import 'package:conference_system/data/models/courses.dart';

class EditCrsForm extends StatefulWidget {
  const EditCrsForm({super.key, required this.course});
  final Course course;

  @override
  State<EditCrsForm> createState() => _EditCrsFormState();
}

class _EditCrsFormState extends State<EditCrsForm> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final costController = TextEditingController();
  final holdingDateController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final capacityController = TextEditingController();
  final budgetController = TextEditingController();
  String? selectedType;
  String? selectedDeliveryType;
  late String selectedGregorianDate;

  void fetch(){
    titleController.text = widget.course.title;
    descriptionController.text = widget.course.description ?? '';
    costController.text = widget.course.cost.toString();
    phoneNumberController.text = widget.course.contactPhone ?? '';
  }

  @override
  void initState(){
    super.initState();
    fetch();
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
                caption: AppTexts.editInfo,
                icon: Icons.edit_outlined,
                width: 230,
              ),
              Wrap(
                textDirection: TextDirection.rtl,
                spacing: 20,
                runSpacing: 20,
                children: <Widget>[
                  CustomTextFormField(
                    controller: titleController,
                    labelText: AppTexts.crsTitle,
                    keyboardType: TextInputType.text,
                  ),
                  CustomDropdownField(
                    labelText: AppTexts.deliveryType,
                    items: [AppTexts.inPerson, AppTexts.online],
                    value: selectedDeliveryType,
                    onChanged: (val) {
                      setState(() {
                        selectedDeliveryType = val;
                      });
                    },
                  ),
                  CustomTextFormField(
                    controller: phoneNumberController,
                    labelText: AppTexts.phoneNumber,
                    keyboardType: TextInputType.phone,
                    hintText: '021xxxxxxx',
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  CustomTextFormField(
                    controller: descriptionController,
                    labelText: AppTexts.description,
                    hintText: AppTexts.optional,
                    maxLines: 5,
                    width: 790,
                  ),
                  CustomTextFormField(
                    controller: costController,
                    labelText: AppTexts.registrationFee,
                    keyboardType: TextInputType.number,
                    hintText: 'تومان',
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  CustomTextFormField(
                    controller: budgetController,
                    labelText: AppTexts.budget,
                    hintText: 'حداکثر میزان بودجه شما(تومان)',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  CustomTextFormField(
                    controller: capacityController,
                    labelText: AppTexts.crsCapacity,
                    hintText: 'بین 1 تا 3000 نفر',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
import 'package:shamsi_date/shamsi_date.dart';

String formatToJalali(String serverDate) {
  final dateTime = DateTime.parse(serverDate).toLocal();

  final jalali = Jalali.fromDateTime(dateTime);

  return "${jalali.year}/${jalali.month.toString().padLeft(2, '0')}/${jalali.day.toString().padLeft(2, '0')}"
      "-${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
}

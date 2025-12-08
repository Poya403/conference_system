import 'package:shamsi_date/shamsi_date.dart';

String formatToJalali(String serverDate) {
  final dateTime = DateTime.parse(serverDate).toLocal();

  final jalali = Jalali.fromDateTime(dateTime);

  return "${jalali.year}/${jalali.month.toString().padLeft(2, '0')}/${jalali.day.toString().padLeft(2, '0')}"
      "-${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
}

String getPersianWeekday(String dateServer) {
  final dateTime = DateTime.parse(dateServer).toLocal();
  final jalali = Jalali.fromDateTime(dateTime);
  final weekday = jalali.weekDay;

  const days = {
    1: 'شنبه',
    2: 'یکشنبه',
    3: 'دوشنبه',
    4: 'سه‌شنبه',
    5: 'چهارشنبه',
    6: 'پنجشنبه',
    7: 'جمعه',
  };

  return days[weekday] ?? '';
}

String getPersianDate(String dateServer) {
  final dateTime = DateTime.parse(dateServer).toLocal();
  final jalali = Jalali.fromDateTime(dateTime);
  return "${jalali.year}/${jalali.month.toString().padLeft(2, '0')}/${jalali.day.toString().padLeft(2, '0')}";
}

String getPersianTime(String dateServer) {
  final dateTime = DateTime.parse(dateServer).toLocal();
  return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
}

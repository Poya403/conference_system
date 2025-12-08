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
    0: 'شنبه',
    1: 'یکشنبه',
    2: 'دوشنبه',
    3: 'سه‌شنبه',
    4: 'چهارشنبه',
    5: 'پنجشنبه',
    6: 'جمعه',
  };

  return days[weekday] ?? '';
}

import 'package:intl/intl.dart';

String formatPrice(dynamic value) {
  try {
    final number = value is num ? value : num.parse(value.toString());
    return '${NumberFormat('#,###').format(number)} تومان ';
  } catch (_) {
    return value.toString();
  }
}
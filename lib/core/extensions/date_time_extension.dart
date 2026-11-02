import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toFormattedDateTime() {
    return DateFormat('dd/MM/yyyy HH:mm').format(this);
  }
}

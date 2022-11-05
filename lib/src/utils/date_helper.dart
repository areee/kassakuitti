import 'package:intl/intl.dart';

/// Formatted date time for file name.
String formattedDateTime() {
  return DateFormat('yyyyMMddHHmmss').format(DateTime.now().toUtc());
}

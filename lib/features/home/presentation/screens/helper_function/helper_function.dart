import 'package:intl/intl.dart';

String formatDate(String date) {
  try {
    DateTime parsedDate = DateTime.parse(date); // Parse the date
    return DateFormat('MMM dd').format(parsedDate); // Format as May 20
  } catch (e) {
    return date; // Return the original if parsing fails
  }
}

String getDayRange(String startTime, String endTime) {
  return '$startTime to $endTime';
}
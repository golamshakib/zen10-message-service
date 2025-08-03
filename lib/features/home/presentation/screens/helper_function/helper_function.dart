import 'package:intl/intl.dart';

String formatDate(String startDate, String endDate) {
  try {
    // Remove the day of the week and year from the start and end dates
    DateTime parsedStartDate = DateFormat('EEE, dd MMM yyyy').parse(startDate);
    DateTime parsedEndDate = DateFormat('EEE, dd MMM yyyy').parse(endDate);

    // Format the start and end dates as "31 Jul to 05 Aug"
    String startFormatted = DateFormat('dd MMM').format(parsedStartDate); // e.g., "31 Jul"
    String endFormatted = DateFormat('dd MMM').format(parsedEndDate); // e.g., "05 Aug"

    return '$startFormatted to $endFormatted'; // Combine both formatted dates
  } catch (e) {
    return '$startDate to $endDate'; // Return original if parsing fails
  }
}

String getDayRange(String startTime, String endTime) {
  return '$startTime to $endTime';
}

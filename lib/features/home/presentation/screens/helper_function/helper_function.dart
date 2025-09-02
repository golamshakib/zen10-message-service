import 'dart:math';
import 'package:intl/intl.dart';

String formatDate(String startDate, String endDate) {
  try {
    // Remove the time part from the start and end dates (if present)
    startDate = startDate.split(' at')[0].trim();
    endDate = endDate.split(' at')[0].trim();

    print("Cleaned Start Date: $startDate");
    print("Cleaned End Date: $endDate");

    // Try multiple date formats to handle different API response formats
    DateTime? parsedStartDate;
    DateTime? parsedEndDate;

    // List of possible date formats from your API
    List<DateFormat> dateFormats = [
      DateFormat('EEE, dd MMM yyyy'), // Wed, 07 May 2025
      DateFormat('E, dd MMM yyyy'),   // Alternative format
      DateFormat('EEE, d MMM yyyy'),  // Single digit day
      DateFormat('E, d MMM yyyy'),    // Alternative with single digit
    ];

    // Try parsing with different formats
    for (DateFormat format in dateFormats) {
      try {
        parsedStartDate = format.parse(startDate);
        parsedEndDate = format.parse(endDate);
        break; // If successful, break out of the loop
      } catch (e) {
        continue; // Try next format
      }
    }

    // If parsing failed with all formats, throw an error
    if (parsedStartDate == null || parsedEndDate == null) {
      throw FormatException('Unable to parse dates with any known format');
    }

    // Format the start and end dates as "02 Sept to 30 Sept"
    String startFormatted = DateFormat('dd MMM').format(parsedStartDate);
    String endFormatted = DateFormat('dd MMM').format(parsedEndDate);

    print("Start Formatted Date: $startFormatted");
    print("End Formatted Date: $endFormatted");

    return '$startFormatted to $endFormatted';
  } catch (e) {
    print("Error formatting date: $e");
    print("Start Date: $startDate");
    print("End Date: $endDate");

    try {
      // Extract date parts manually as fallback
      RegExp dateRegex = RegExp(r'(\d{1,2})\s+(\w+)\s+(\d{4})');

      Match? startMatch = dateRegex.firstMatch(startDate);
      Match? endMatch = dateRegex.firstMatch(endDate);

      if (startMatch != null && endMatch != null) {
        String startDay = startMatch.group(1)!.padLeft(2, '0');
        String startMonth = startMatch.group(2)!;
        String endDay = endMatch.group(1)!.padLeft(2, '0');
        String endMonth = endMatch.group(2)!;

        return '$startDay $startMonth to $endDay $endMonth';
      }
    } catch (fallbackError) {
      print("Fallback parsing also failed: $fallbackError");
    }

    return '$startDate to $endDate'; // Return original if all parsing fails
  }
}

String getDayRange(String startTime, String endTime) {
  return '$startTime to $endTime';
}

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const radius = 6371; // Radius of the Earth in kilometers
  final dLat = (lat2 - lat1) * pi / 180;
  final dLon = (lon2 - lon1) * pi / 180;
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
          sin(dLon / 2) * sin(dLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return radius * c; // Distance in kilometers
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormatUtils {
  /// Converts a date string in the format "dd-MM-yyyy" to an ISO 8601 date string.
  /// Input: "28-04-2024"
  /// Output: "2024-04-28T00:00:00Z"
  static String? formatToIsoDate(String? dateStr) {
    if (dateStr == null) return null;
    try {
      DateTime date = DateFormat('dd-MM-yyyy').parseLoose(dateStr);
      return '${DateFormat("yyyy-MM-dd'T'00:00:00Z").format(date)}Z';
    } catch (error) {
      return null;
    }
  }

  /// Converts a DateTime object to an ISO 8601 date-time string in UTC format.
  /// Input: DateTime(2024, 4, 28, 15, 30)
  /// Output: "2024-04-28T15:30:00Z"
  static String? formatToIsoDateTime(DateTime? dateTime) {
    if (dateTime == null) return null;

    // Convert the `DateTime` object to UTC before formatting.
    DateTime utcDateTime = dateTime.toUtc();

    return '${utcDateTime.toIso8601String()}';
  }

  /// Combines a date and time into a single DateTime object and formats it as an ISO 8601 string.
  /// Input: DateTime(2024, 4, 28), TimeOfDay(15, 30)
  /// Output: "2024-04-28T15:30:00Z"
  static String? combineDateWithTime(DateTime? date, TimeOfDay? time) {
    if (date == null || time == null) return null;
    DateTime combinedDateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return '${DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(combinedDateTime)}Z';
  }

  /// Converts an ISO 8601 date string to a human-readable format.
  /// Input: "2024-04-28T15:30:00Z"
  /// Output: "Sunday, April 28 2024"
  static String? formatDateToReadable(String isoDate) {
    try {
      DateTime dateTime = DateTime.parse(isoDate);
      DateFormat formatter = DateFormat('EEEE, MMMM d yyyy', 'en_US');
      return formatter.format(dateTime);
    } catch (error) {
      return '';
    }
  }

  /// Formats a duration in minutes into a string representing hours and minutes.
  /// Input: 125
  /// Output: "2h 5m"
  static String formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      return '${hours}h ${remainingMinutes}m';
    }
  }

  /// Converts a map containing a time key or a StartTime key to a readable time format.
  /// Input: {"Time": "2024-04-28T15:30:00Z"}
  /// Output: "15:30"
  static String formatTime(Map<String, dynamic> data) {
    DateTime time;
    if (data.containsKey('Time')) {
      time = DateTime.parse(data['Time']);
    } else {
      time = DateTime.parse(data['StartTime']);
    }
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Converts an ISO 8601 date-time string into a double representing the time of day.
  /// Input: "2024-04-28T15:30:00Z"
  /// Output: 15.30
  static double formatTimeAsDouble(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate);
    double timeAsDouble = dateTime.hour + (dateTime.minute / 60.0);
    return timeAsDouble;
  }
}

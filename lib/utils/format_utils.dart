import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormatUtils {
  static String? formatToIsoDate(String? dateStr) {
    if (dateStr == null) return null;
    try {
      DateTime date = DateFormat('dd-MM-yyyy').parseLoose(dateStr);
      return '${DateFormat("yyyy-MM-dd'T'00:00:00Z").format(date)}Z';
    } catch (error) {
      return null;
    }
  }

  static String? formatToIsoDateTime(DateTime? dateTime) {
    return dateTime?.toIso8601String();
  }

  static String? combineDateWithTime(DateTime? date, TimeOfDay? time) {
    if (date == null || time == null) return null;
    DateTime combinedDateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return '${DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(combinedDateTime)}Z';
  }

  static String? formatDateToReadable(String isoDate) {
    try {
      DateTime dateTime = DateTime.parse(isoDate);
      DateFormat formatter = DateFormat('EEEE, MMMM d yyyy', 'en_US');
      return formatter.format(dateTime);
    } catch (error) {
      return '';
    }
  }

  static String formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      return '${hours}h ${remainingMinutes}m';
    }
  }
}

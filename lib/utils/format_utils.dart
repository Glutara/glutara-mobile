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
}

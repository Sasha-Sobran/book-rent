class AppDateUtils {
  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  static String formatDateNullable(DateTime? date) {
    return date == null ? '-' : formatDate(date);
  }

  static DateTime dateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static int daysBetween(DateTime start, DateTime end) {
    final startDate = dateOnly(start);
    final endDate = dateOnly(end);
    return endDate.difference(startDate).inDays;
  }

  static bool isDateAfter(DateTime date1, DateTime date2) {
    final d1 = dateOnly(date1);
    final d2 = dateOnly(date2);
    return d1.isAfter(d2);
  }

  static String formatDateTime(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString);
      return '${formatDate(dateTime)} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return isoString;
    }
  }
}


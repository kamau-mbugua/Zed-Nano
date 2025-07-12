import 'package:intl/intl.dart';

/// Utility for generating ISO8601 date ranges for dashboard and reporting
class DateRangeUtil {
  /// Returns a map with 'startDate' and 'endDate' in ISO8601 format with timezone offset (+03:00)
  /// [label] can be: 'today', 'this_week', 'this_month', 'this_year', 'custom'
  /// If 'custom', provide [customStart] and [customEnd]
  static Map<String, String> getDateRange(
    String label, {
    DateTime? customStart,
    DateTime? customEnd,
  }) {
    // Use the actual current local time
    final now = DateTime.now();
    late DateTime start;
    late DateTime end;

    switch (label) {
      case 'today':
        start = DateTime(now.year, now.month, now.day, 0, 0, 0, 0, now.timeZoneOffset.inMilliseconds ~/ 1000 ~/ 60);
        end = now;
        break;
      case 'this_week':
        final weekday = now.weekday;
        start = DateTime(now.year, now.month, now.day - (weekday - 1), 0, 0, 0, 0, now.timeZoneOffset.inMilliseconds ~/ 1000 ~/ 60);
        end = now;
        break;
      case 'this_month':
        start = DateTime(now.year, now.month, 1, 0, 0, 0, 0, now.timeZoneOffset.inMilliseconds ~/ 1000 ~/ 60);
        end = now;
        break;
      case 'this_year':
        start = DateTime(now.year, 1, 1, 0, 0, 0, 0, now.timeZoneOffset.inMilliseconds ~/ 1000 ~/ 60);
        end = now;
        break;
      case 'custom':
        if (customStart == null || customEnd == null) {
          throw ArgumentError('For custom range, provide customStart and customEnd');
        }
        start = customStart;
        end = customEnd;
        break;
      default:
        throw ArgumentError('Unsupported label: $label');
    }

    return {
      'startDate': _formatDateWithOffset(start),
      'endDate': _formatDateWithOffset(end),
    };
  }

  /// Formats a DateTime to 'yyyy-MM-ddTHH:mm:ss+03:00' (ISO8601 with offset)
  static String _formatDateWithOffset(DateTime dt) {
    final String ymd = DateFormat('yyyy-MM-dd').format(dt);
    final String hms = DateFormat('HH:mm:ss').format(dt);
    final String offset = _formatOffset(dt.timeZoneOffset);
    return '$ymd' 'T' '$hms$offset';
  }

  static String _formatOffset(Duration offset) {
    final sign = offset.isNegative ? '-' : '+';
    final absOffset = offset.abs();
    final hours = absOffset.inHours.toString().padLeft(2, '0');
    final minutes = (absOffset.inMinutes % 60).toString().padLeft(2, '0');
    return '$sign$hours:$minutes';
  }
}

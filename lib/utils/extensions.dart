import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

extension StringValidationExtensions on String {
  /// Check if the string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(r"^[\w\.\-]+(\+[\w]+)?@[\w\.-]+\.\w+$");
    return emailRegex.hasMatch(this);
  }

  /// Check if the string is a valid phone number (9 or 10 digits only)
  bool get isValidPhoneNumber {
    final phoneRegex = RegExp(r'^\+?\d{9,10}$');
    return phoneRegex.hasMatch(this);
  }

  bool get isValidPin {
    final pinRegex = RegExp(r'^\d{4}$');
    return pinRegex.hasMatch(this);
  }

  bool get isValidInput {
    return this.trim().isNotEmpty;
  }

  String get firstName {
    if (trim().isEmpty) return '';
    return trim().split(' ').first;
  }
  bool get isValidFullName {
    var fullName = this.trim();
    return fullName.split(' ').length >= 2 && fullName.replaceAll(' ', '').isAlpha();
  }

  bool get isValidIdNumber {
    // Example: Kenyan ID number validation (can be adjusted for other formats)
    final idRegex = RegExp(r'^\d{8}$'); // 8 digits
    return idRegex.hasMatch(this);
  }

  bool get isValidPassword {
    // Example: Password must be at least 8 characters, contain uppercase, lowercase, digit, and special character
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return passwordRegex.hasMatch(this);
  }

  /// Check if the string is a valid date (ISO format: yyyy-MM-dd or other common format)
  bool get isValidDate {
    try {
      final parsedDate = DateTime.tryParse(this);
      return parsedDate != null;
    } catch (_) {
      return false;
    }
  }

  /// Check if the string is a valid number (int or double)
  bool get isValidNumber {
    return num.tryParse(this) != null;
  }

  String toTitleCaseFromCamel() {
    final spaced = replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
          (match) => '${match.group(1)} ${match.group(2)}',
    );
    return spaced[0].toUpperCase() + spaced.substring(1);
  }

  String get toShortDateTime {
    try {
      final dt = DateTime.parse(this).toLocal();
      return DateFormat('yyyy-MM-dd HH:mm').format(dt);
    } catch (e) {
      return this;
    }
  }
  
  /// Removes timezone offset from ISO 8601 date string
  /// Example: 2025-07-12T15:14:50+03:00 -> 2025-07-12T15:14:50
  String get removeTimezoneOffset {
    try {
      if (this.contains('+') || this.contains('-', this.indexOf('T'))) {
        // Find the last occurrence of + or - after the T
        int tIndex = this.indexOf('T');
        int plusIndex = this.indexOf('+', tIndex);
        int minusIndex = this.indexOf('-', tIndex);
        
        // Use the earlier of the two that exists
        int offsetIndex = -1;
        if (plusIndex != -1 && minusIndex != -1) {
          offsetIndex = plusIndex < minusIndex ? plusIndex : minusIndex;
        } else if (plusIndex != -1) {
          offsetIndex = plusIndex;
        } else if (minusIndex != -1) {
          offsetIndex = minusIndex;
        }
        
        if (offsetIndex != -1) {
          return this.substring(0, offsetIndex);
        }
      }
      return this;
    } catch (e) {
      return this;
    }
  }

  //remove time from date time
  String get removeTime {
    return this.split('T')[0];
  }

  //remove + from phone number
  String get removePlus {
    return this.replaceAll('+', '');
  }

  //check if phonenumber starts with a 0, remove it
  String get removeZero {
    return this.startsWith('0') ? this.substring(1) : this;
  }

  //formatCurrency extension
  String formatCurrency({String locale = 'en_KE'}) {
    final formatter = NumberFormat("#,##0", locale);
    return formatter.format(this);
  }
}


extension GreetingExtension on DateTime {
  String get greeting {
    int hour = this.hour;
    if (hour >= 5 && hour < 12) {
      return "Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Afternoon";
    } else if (hour >= 17 && hour < 21) {
      return "Evening";
    } else {
      return "Hello"; // Late Night fallback
    }
  }
}

extension DateTimeFormatExtension on String {
  String toDisplayDateTime() {
    try {
      final dateTime = DateTime.parse(this);
      final day = dateTime.day.toString().padLeft(2, '0');
      final month = dateTime.month.toString().padLeft(2, '0');
      final year = dateTime.year.toString();
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');
      return '$day-$month-$year $hour:$minute';
    } catch (e) {
      return this; // fallback to original if parsing fails
    }
  }

  /// Converts ISO date string (2025-07-05T13:16:48.063Z) to formatted date (05 July 2025)
  String toFormattedDate() {
    try {
      final dateTime = DateTime.parse(this);
      final formatter = DateFormat('dd MMMM yyyy');
      return formatter.format(dateTime);
    } catch (e) {
      // Return original string if parsing fails
      return this;
    }
  }

  /// Converts ISO date string (2025-07-05T13:16:48.063Z) to formatted date (05 July 2025 13:16)
  String toFormattedDateTime() {
    try {
      final dateTime = DateTime.parse(this);
      final formatter = DateFormat('dd MMMM yyyy HH:mm');
      return formatter.format(dateTime);
    } catch (e) {
      // Return original string if parsing fails
      return this;
    }
  }

  /// Converts ISO date string (2025-07-05T13:16:48.063Z) to formatted date with custom format
  String toCustomFormattedDate(String format) {
    try {
      final dateTime = DateTime.parse(this);
      final formatter = DateFormat(format);
      return formatter.format(dateTime);
    } catch (e) {
      return this;
    }
  }
}

/// Utility class for date formatting
class DateFormatter {
  /// Returns current date in format "05 July 2025"
  static String getCurrentFormattedDate() {
    final now = DateTime.now();
    final formatter = DateFormat('dd MMMM yyyy');
    return formatter.format(now);
  }

  /// Formats any DateTime to "05 July 2025" format
  static String formatDate(DateTime date) {
    final formatter = DateFormat('dd MMMM yyyy');
    return formatter.format(date);
  }

  /// Formats any DateTime to "05 July 2025 13:16" format
  static String formatDateTime(DateTime date) {
    final formatter = DateFormat('dd MMMM yyyy HH:mm');
    return formatter.format(date);
  }

  /// Returns current date and time in format "30/07/25 11:49 AM"
  static String getCurrentShortDateTime() {
    final now = DateTime.now();
    final formatter = DateFormat('dd/MM/yy hh:mm a');
    return formatter.format(now);
  }
}

/// Extension for DateTime formatting
extension DateTimeExtensions on DateTime {
  /// Formats DateTime to "05 July 2025" format
  String toFormattedDate() {
    final formatter = DateFormat('dd MMMM yyyy');
    return formatter.format(this);
  }

  /// Formats DateTime to "05 July 2025 13:16" format
  String toFormattedDateTime() {
    final formatter = DateFormat('dd MMMM yyyy HH:mm');
    return formatter.format(this);
  }
}

extension CurrencyFormatter on num {
  String formatCurrency({String locale = 'en_KE'}) {
    final formatter = NumberFormat("#,##0", locale);
    return formatter.format(this);
  }
}

extension DoubleCurrencyFormatter on double {
  String formatCurrency({String locale = 'en_KE'}) {
    final formatter = NumberFormat.currency(locale: locale, symbol: '');
    return formatter.format(this);
  }
}

extension DateRangeLabelExtension on String {
  /// Converts snake_case date range labels to human-readable format
  /// Example: "this_month" -> "This Month", "last_week" -> "Last Week"
  String get toDisplayLabel {
    if (isEmpty) return this;
    
    // Split by underscore and capitalize each word
    return split('_')
        .map((word) => word.isNotEmpty 
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : word)
        .join(' ');
  }
}

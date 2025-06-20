import 'package:nb_utils/nb_utils.dart';

extension StringValidationExtensions on String {
  /// Check if the string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(r"^[\w\.\-\+]+@[\w\.-]+\.\w+$");
    return emailRegex.hasMatch(this);
  }

  /// Check if the string is a valid phone number (digits only, length 7–15)
  bool get isValidPhoneNumber {
    final phoneRegex = RegExp(r'^\+?\d{7,15}$');
    return phoneRegex.hasMatch(this);
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
}

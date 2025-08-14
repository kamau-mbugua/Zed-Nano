import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/utils/Common.dart';

/// Model for saved login credentials
class SavedCredential {
  final String identifier; // email or phone
  final String type; // 'email' or 'phone'
  final DateTime lastUsed;
  final String? displayName; // Optional display name

  SavedCredential({
    required this.identifier,
    required this.type,
    required this.lastUsed,
    this.displayName,
  });

  Map<String, dynamic> toJson() => {
    'identifier': identifier,
    'type': type,
    'lastUsed': lastUsed.toIso8601String(),
    'displayName': displayName,
  };

  factory SavedCredential.fromJson(Map<String, dynamic> json) => SavedCredential(
    identifier: json['identifier'] as String,
    type: json['type'] as String,
    lastUsed: DateTime.parse(json['lastUsed'] as String),
    displayName: json['displayName'] as String?,
  );

  /// Get display text for the credential
  String get displayText {
    if (displayName != null && displayName!.isNotEmpty) {
      return '$displayName ($identifier)';
    }
    return identifier;
  }

  /// Get masked identifier for display
  String get maskedIdentifier {
    if (type == 'email') {
      final parts = identifier.split('@');
      if (parts.length == 2) {
        final username = parts[0];
        final domain = parts[1];
        if (username.length > 2) {
          return '${username.substring(0, 2)}***@$domain';
        }
      }
    } else if (type == 'phone') {
      if (identifier.length > 4) {
        return '***${identifier.substring(identifier.length - 4)}';
      }
    }
    return identifier;
  }
}

/// Service to manage saved login credentials
class SavedCredentialsService {
  static const String _savedCredentialsKey = 'saved_credentials';
  static const int _maxSavedCredentials = 5; // Limit to 5 saved credentials

  /// Save a new credential after successful login
  static Future<void> saveCredential({
    required String identifier,
    required String type,
    String? displayName,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final credentials = await getSavedCredentials();
      
      // Remove existing credential with same identifier
      credentials.removeWhere((cred) => cred.identifier == identifier);
      
      // Add new credential at the beginning
      credentials.insert(0, SavedCredential(
        identifier: identifier,
        type: type,
        lastUsed: DateTime.now(),
        displayName: displayName,
      ));
      
      // Keep only the most recent credentials
      if (credentials.length > _maxSavedCredentials) {
        credentials.removeRange(_maxSavedCredentials, credentials.length);
      }
      
      // Save to preferences
      final jsonList = credentials.map((cred) => cred.toJson()).toList();
      await prefs.setString(_savedCredentialsKey, jsonEncode(jsonList));
      
      logger.d('SavedCredentialsService: Saved credential for $identifier');
    } catch (e) {
      logger.e('SavedCredentialsService: Failed to save credential: $e');
    }
  }

  /// Get all saved credentials
  static Future<List<SavedCredential>> getSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_savedCredentialsKey);
      
      if (jsonString == null) return [];
      
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => SavedCredential.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      logger.e('SavedCredentialsService: Failed to load credentials: $e');
      return [];
    }
  }

  /// Get saved credentials by type (email or phone)
  static Future<List<SavedCredential>> getSavedCredentialsByType(String type) async {
    final credentials = await getSavedCredentials();
    return credentials.where((cred) => cred.type == type).toList();
  }

  /// Remove a specific credential
  static Future<void> removeCredential(String identifier) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final credentials = await getSavedCredentials();
      
      credentials.removeWhere((cred) => cred.identifier == identifier);
      
      final jsonList = credentials.map((cred) => cred.toJson()).toList();
      await prefs.setString(_savedCredentialsKey, jsonEncode(jsonList));
      
      logger.d('SavedCredentialsService: Removed credential for $identifier');
    } catch (e) {
      logger.e('SavedCredentialsService: Failed to remove credential: $e');
    }
  }

  /// Clear all saved credentials
  static Future<void> clearAllCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_savedCredentialsKey);
      logger.d('SavedCredentialsService: Cleared all credentials');
    } catch (e) {
      logger.e('SavedCredentialsService: Failed to clear credentials: $e');
    }
  }

  /// Update the last used time for a credential
  static Future<void> updateLastUsed(String identifier) async {
    try {
      final credentials = await getSavedCredentials();
      final index = credentials.indexWhere((cred) => cred.identifier == identifier);
      
      if (index != -1) {
        // Update last used time and move to front
        final credential = credentials.removeAt(index);
        credentials.insert(0, SavedCredential(
          identifier: credential.identifier,
          type: credential.type,
          lastUsed: DateTime.now(),
          displayName: credential.displayName,
        ));
        
        // Save updated list
        final prefs = await SharedPreferences.getInstance();
        final jsonList = credentials.map((cred) => cred.toJson()).toList();
        await prefs.setString(_savedCredentialsKey, jsonEncode(jsonList));
      }
    } catch (e) {
      logger.e('SavedCredentialsService: Failed to update last used: $e');
    }
  }
}

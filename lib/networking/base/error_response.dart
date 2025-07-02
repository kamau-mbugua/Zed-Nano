import 'package:flutter/foundation.dart';
import 'package:zed_nano/app/app_initializer.dart';

import 'api_response.dart';

/// Error types for categorizing errors
enum ErrorType {
  authentication, // Auth related errors (401)
  authorization,  // Permission errors (403)
  network,        // Network connectivity issues
  timeout,        // Request timeouts
  server,         // Server errors (500s)
  validation,     // Input validation errors
  business,       // Business logic errors from API
  parsing,        // JSON parsing errors
  security,       // Security-related errors (certificates, etc.)
  unknown         // Uncategorized errors
}

class ErrorResponse {
  int? code;            // result.code
  String? message;      // result.message
  dynamic data;         // result.data
  int? statusCode;      // top level
  String? statusMessage;
  ErrorType errorType;
  Map<String, dynamic>? extraData; // For additional error data like attempts remaining

  ErrorResponse({
    this.code,
    this.message,
    this.data,
    this.statusCode,
    this.statusMessage,
    this.errorType = ErrorType.unknown,
    this.extraData,
  });

  factory ErrorResponse.fromJson(dynamic json) {
    Map<String, dynamic>? map;
    final errorResponse = ErrorResponse(
      extraData: {},
    );

    try {
      if (json is Map<String, dynamic>) {
        map = json;
      } else if (json is ApiResponse) {
        if (json.response?.data is Map<String, dynamic>) {
          map = json.response!.data as Map<String, dynamic>;
          errorResponse.statusCode = json.response?.statusCode;
        } else if (json.response?.data is String) {
          // If the API returns an error string, not JSON
          map = {
            'statusMessage': json.response?.statusMessage ?? 'An error occurred. Please try again.',
            'statusCode': json.response?.statusCode ?? 5555,
          };
          errorResponse.statusCode = json.response?.statusCode;
        }
      }
    } catch (e) {
      logger.e('Error parsing response in ErrorResponse.fromJson: $e');
      return ErrorResponse(
        message: 'Failed to parse error response',
        statusMessage: 'An error occurred while processing the response',
        errorType: ErrorType.parsing,
      );
    }

    if (map == null) {
      // No valid map, fallback
      return ErrorResponse(
        code: null,
        message: 'An error occurred',
        data: null,
        statusCode: 0,
        statusMessage: 'An error occurred',
        errorType: ErrorType.unknown,
      );
    }

    // Handle regular result structure
    final result = map['result'];
    if (result is Map<String, dynamic>) {
      errorResponse.code = result['code'] as int?;
      errorResponse.message = result['message'] as String?;
      errorResponse.data = result['data'];
    }

    // Handle login error format
    // {"status": "01", "Status": "FAILED", "message": "Invalid Pin You Have 8 Retries Remaining", "attempts": 8}
    if (map.containsKey('status') || map.containsKey('Status')) {
      String status = (map['status'] as String?) ?? (map['Status'] as String?) ?? '';
      errorResponse.statusMessage = map['message'] as String?;
      errorResponse.code = int.tryParse(status) ?? 1;
      
      // Store attempts if available
      if (map.containsKey('attempts')) {
        errorResponse.extraData?['attempts'] = map['attempts'];
      }
      
      errorResponse.errorType = ErrorType.business;
    }

    // Handle simple error message format
    // {"error": "business Id missing in token ..."}
    if (map.containsKey('error')) {
      errorResponse.statusMessage = map['error'] as String?;
      errorResponse.errorType = ErrorType.business;
    }

    // Handle response codes appropriately
    if (errorResponse.statusCode != null) {
      if (errorResponse.statusCode == 401) {
        errorResponse.errorType = ErrorType.authentication;
      } else if (errorResponse.statusCode == 403) {
        errorResponse.errorType = ErrorType.authorization;
      } else if (errorResponse.statusCode != null && errorResponse.statusCode! >= 500) {
        errorResponse.errorType = ErrorType.server;
      }
    }

    // Ensure we have some status message
    if (errorResponse.statusMessage == null) {
      errorResponse.statusMessage = errorResponse.message ?? 'An error occurred';
    }
    
    // Ensure we have some message
    if (errorResponse.message == null) {
      errorResponse.message = errorResponse.statusMessage;
    }

    // Debug logging
    if (kDebugMode) {
      logger.d('Parsed error response: ${errorResponse.toJson()}');
    }

    return errorResponse;
  }

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "message": message,
      "data": data,
      "statusCode": statusCode,
      "statusMessage": statusMessage,
      "errorType": errorType.toString(),
      "extraData": extraData,
    };
  }

  bool get isSuccess => statusCode == 5000; // Success if 5000
  
  /// Get user-friendly error message
  String get userMessage {
    switch (errorType) {
      case ErrorType.authentication:
        return 'Authentication failed. Please log in again.';
      case ErrorType.authorization:
        return 'You don\'t have permission to access this feature.';
      case ErrorType.network:
        return 'Network connection issue. Please check your internet.';
      case ErrorType.timeout:
        return 'Request timed out. Please try again.';
      case ErrorType.server:
        return 'Server error. Our team has been notified.';
      case ErrorType.business:
        return statusMessage ?? 'A business logic error occurred.';
      default:
        return statusMessage ?? 'An unexpected error occurred.';
    }
  }

  /// Get remaining attempts if available (for login)
  int? get remainingAttempts => extraData?['attempts'] as int?;
}

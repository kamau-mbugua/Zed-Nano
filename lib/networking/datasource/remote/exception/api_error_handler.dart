import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/networking/base/error_response.dart';

/// Handles API errors and converts them to standardized ErrorResponse objects
class ApiErrorHandler {
  /// Processes errors from API calls and returns a standardized ErrorResponse
  static ErrorResponse handleError(dynamic error) {
    // Create an initial error response
    var errorResponse = ErrorResponse(
      statusCode: 0,
      statusMessage: 'An unexpected error occurred',
    );
    
    if (error is DioException) {
      errorResponse = _handleDioError(error);
    } else if (error is SocketException) {
      errorResponse.errorType = ErrorType.network;
      errorResponse.statusMessage = 'No internet connection. Please check your network.';
    } else if (error is FormatException) {
      errorResponse.errorType = ErrorType.parsing;
      errorResponse.statusMessage = 'Data format error. Please try again later.';
    } else {
      // Generic error handling
      errorResponse.statusMessage = error.toString();
    }
    
    // Log the error details
    logger.e(
      'API Error (${errorResponse.errorType}): ${errorResponse.statusMessage}',
      error: error,
    );
    
    return errorResponse;
  }
  
  /// Handle Dio-specific errors
  static ErrorResponse _handleDioError(DioException error) {
    // Create a new error response
    final errorResponse = ErrorResponse();
    
    // Set the status code if available
    errorResponse.statusCode = error.response?.statusCode;
    
    // Handle different error types
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorResponse.errorType = ErrorType.timeout;
        errorResponse.statusMessage = 'Connection timed out. Please try again.';
      case DioExceptionType.badCertificate:
        errorResponse.errorType = ErrorType.security;
        errorResponse.statusMessage = 'Security certificate issue. Please contact support.';
      case DioExceptionType.connectionError:
        errorResponse.errorType = ErrorType.network;
        errorResponse.statusMessage = 'Connection error. Please check your internet.';
      case DioExceptionType.badResponse:
        // Process the response error
        return _handleResponseError(error);
      case DioExceptionType.cancel:
        errorResponse.errorType = ErrorType.unknown;
        errorResponse.statusMessage = 'Request was cancelled';
      case DioExceptionType.unknown:
      default:
        errorResponse.errorType = ErrorType.unknown;
        errorResponse.statusMessage = 'An unknown error occurred';
        
        // Log unknown errors with more details for debugging
        if (kDebugMode) {
          logger.e(
            'Unknown DioError: $error',
            error: error,
            stackTrace: StackTrace.current,
          );
        }
    }
    
    return errorResponse;
  }
  
  /// Handle HTTP response errors
  static ErrorResponse _handleResponseError(DioException error) {
    final response = error.response;
    // Create a new error response
    final errorResponse = ErrorResponse();
    
    // Set status code
    errorResponse.statusCode = response?.statusCode;
    
    // Handle common status codes
    switch (response?.statusCode) {
      case 401:
        errorResponse.errorType = ErrorType.authentication;
        errorResponse.statusMessage = 'Your session has expired. Please log in again.';
      case 403:
        errorResponse.errorType = ErrorType.authorization;
        errorResponse.statusMessage = "You don't have permission to access this resource.";
      case 404:
        errorResponse.errorType = ErrorType.business;
        errorResponse.statusMessage = 'Requested resource was not found.';
      case 429:
        errorResponse.errorType = ErrorType.business;
        errorResponse.statusMessage = 'Too many requests. Please try again later.';
      case 500:
      case 502:
      case 503:
      case 504:
        errorResponse.errorType = ErrorType.server;
        errorResponse.statusMessage = 'Server error. Our team has been notified.';
      default:
        // Try to parse the error response body
        if (response?.data != null) {
          try {
            // Use the improved ErrorResponse.fromJson that can handle multiple formats
            final parsedResponse = ErrorResponse.fromJson(response?.data);
            
            // Use the parsed values
            errorResponse.statusMessage = parsedResponse.statusMessage;
            errorResponse.message = parsedResponse.message;
            errorResponse.code = parsedResponse.code;
            errorResponse.errorType = parsedResponse.errorType;
            errorResponse.extraData = parsedResponse.extraData;
          } catch (e) {
            logger.e('Error parsing response body: $e');
            errorResponse.statusMessage = 'Failed to process server response';
            errorResponse.errorType = ErrorType.parsing;
          }
        }
    }
    
    return errorResponse;
  }

  /// Get a user-friendly error message
  static String getMessage(dynamic error) {
    final errorResponse = handleError(error);
    return errorResponse.userMessage;
  }
}

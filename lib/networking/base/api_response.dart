import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:zed_nano/networking/base/error_response.dart';

/// API Response wrapper class
/// 
/// Used to standardize response handling throughout the app
class ApiResponse {

  ApiResponse(this.response, this.error);

  /// Create a response for an error condition
  ApiResponse.withError(dynamic errorValue) : 
    response = null,
    error = errorValue;

  /// Create a response for a successful API call
  ApiResponse.withSuccess(Response responseValue) :
    response = responseValue,
    error = null;
  final Response? response;
  final dynamic error;
  
  /// Returns true if this response represents a successful API call
  bool get isSuccess => response != null && error == null && 
      (response!.statusCode! >= 200 && response!.statusCode! < 300);
  
  /// Get response data as Map<String, dynamic> for easy JSON parsing
  Map<String, dynamic>? get data {
    if (response?.data == null) return null;
    
    if (response!.data is Map<String, dynamic>) {
      return response!.data as Map<String, dynamic>;
    } else if (response!.data is Map) {
      // Handle case where it's a Map but not specifically Map<String, dynamic>
      try {
        return Map<String, dynamic>.from(response!.data as Map);
      } catch (e) {
        return {'data': response!.data};
      }
    } else if (response!.data is String) {
      // Try to parse string as JSON
      try {
        final decoded = jsonDecode(response!.data as String);
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        } else {
          return {'data': decoded};
        }
      } catch (e) {
        return {'data': response!.data};
      }
    } else {
      // Fallback for other types
      return {'data': response!.data};
    }
  }

  /// Create a JSON representation of the response
  Map<String, dynamic> toJson() {
    return {
      'response': response?.data,
      'error': error,
    };
  }
  
  /// Get properly typed error object
  ErrorResponse getTypedError() {
    if (error is ErrorResponse) {
      return error as ErrorResponse;
    } else {
      return ErrorResponse(
        statusCode: response?.statusCode ?? 0,
        statusMessage: error.toString(),
      );
    }
  }
}

import 'package:zed_nano/app/app_initializer.dart';

import 'api_response.dart';

class ErrorResponse {
  int? code;            // result.code
  String? message;      // result.message
  dynamic data;         // result.data
  int? statusCode;      // top level
  String? statusMessage;

  ErrorResponse({
    this.code,
    this.message,
    this.data,
    this.statusCode,
    this.statusMessage,
  });

  factory ErrorResponse.fromJson(dynamic json) {
    Map<String, dynamic>? map;

    try {
      if (json is Map<String, dynamic>) {
        map = json;
      } else if (json is ApiResponse) {
        if (json.response?.data is Map<String, dynamic>) {
          map = json.response!.data as Map<String, dynamic>;
        } else if (json.response?.data is String) {
          // If the API returns an error string, not JSON
          map = {
            'statusMessage': json.response?.statusMessage ?? 'An error occurred. Please try again.',
            'statusCode': json.response?.statusCode ?? 5555,
          };
        }
      }
    } catch (e) {
      logger.e('Error parsing response in ErrorResponse.fromJson: $e');
    }

    if (map == null) {
      // No valid map, fallback
      return ErrorResponse(
        code: null,
        message: 'An error occurred',
        data: null,
        statusCode: 0,
        statusMessage: 'An error occurred',
      );
    }

    final result = map['result'];

    return ErrorResponse(
      code: result is Map<String, dynamic> ? (result['code'] as int?) : null,
      message: result is Map<String, dynamic> ? (result['message'] as String?) : (map['statusMessage'] as String?),
      data: result is Map<String, dynamic> ? result['data'] : null,
      statusCode: (map['statusCode'] as int?) ?? 0,
      statusMessage: (map['statusMessage'] as String?) ?? 'An error occurred',
    );
  }


  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "message": message,
      "data": data,
      "statusCode": statusCode,
      "statusMessage": statusMessage,
    };
  }

  bool get isSuccess => statusCode == 5000; // Success if 5000
}

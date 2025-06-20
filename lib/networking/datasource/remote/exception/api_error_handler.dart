import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zed_nano/app/app_initializer.dart';

import '../../../base/error_response.dart';

class ApiErrorHandler {
  static dynamic getMessage(error) {
    dynamic errorDescription = "Something went wrong.";
    if (error is Exception) {
      try {
        if (error is DioError) {
          switch (error.type) {
            case DioErrorType.cancel:
              errorDescription = "Request to API server was cancelled";
              break;
            case DioErrorType.receiveTimeout:
              errorDescription = "Receive timeout in connection with API server";
              break;
            case DioErrorType.badResponse:
              switch (error.response!.statusCode) {
                case 500:
                case 503:
                  errorDescription = error.response!.statusMessage;
                  break;
                default:
                  ErrorResponse? errorResponse;
                  try {
                    errorResponse = ErrorResponse.fromJson(error.response!.data);
                  } catch (e) {
                    if (kDebugMode) {
                      logger.e('Error parsing response: ${e.toString()}');
                    }
                  }

                  if (errorResponse != null) {
                    if (kDebugMode) {
                      logger.e(
                          'API Error -- Path: ${error.response?.requestOptions.uri} || '
                              'Status: ${errorResponse.statusCode} || '
                              'Message: ${errorResponse.statusMessage}');
                    }
                    errorDescription = errorResponse.statusMessage ?? "An error occurred.";
                  } else {
                    errorDescription =
                    "Failed to load data - status code: ${error.response!.statusCode}";
                  }
              }
              break;
            case DioErrorType.sendTimeout:
              errorDescription = "Send timeout in connection with API server";
              break;
            case DioErrorType.connectionTimeout:
              errorDescription = "Connection timeout with API server";
              break;
            case DioErrorType.badCertificate:
              errorDescription = "Incorrect certificate";
              break;
            case DioErrorType.connectionError:
              errorDescription = "Connection error with API server";
              break;
            case DioErrorType.unknown:
              debugPrint(
                  'Unknown error -- Path: ${error.response?.requestOptions.path} || '
                      'Status: ${error.response?.statusCode} || '
                      'Data: ${error.response?.data}');
              errorDescription = "Unknown error occurred";
              break;
          }
        } else {
          errorDescription = "Unexpected error occurred";
        }
      } on FormatException catch (e) {
        errorDescription = e.toString();
      }
    } else {
      errorDescription = "Error is not a subtype of Exception.";
    }
    return errorDescription;
  }
}

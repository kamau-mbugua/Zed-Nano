import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:zed_nano/networking/base/api_response.dart';
import 'package:zed_nano/networking/models/response_model.dart';

/// Handles an API response and converts it to a standardized ResponseModel
Future<ResponseModel> handleApiResponse(ApiResponse apiResponse) async {
  if (apiResponse.isSuccess) {
    try {
      // Get data from improved ApiResponse
      final responseData = apiResponse.data;
      Map<String, dynamic> data = castMap(responseData);
      final dataMessage = data['message'] ?? 'Success';
      
      // Handle success response
      return ResponseModel(true, dataMessage.toString() ?? 'Success', responseData);
    } catch (e) {
      return ResponseModel(false, 'Failed to process response: $e');
    }
  } else {
    // Get properly typed error with the improved error handler
    final error = apiResponse.getTypedError();
    
    // Use the error message from our improved error handling
    return ResponseModel(false, error.userMessage);
  }
}

/// Type-safe map casting from dynamic to Map<String, dynamic>
Map<String, dynamic> castMap(dynamic data) {
  if (data is Map) {
    return Map<String, dynamic>.from(data);
  }
  throw Exception('Expected a Map but got ${data.runtimeType}');
}

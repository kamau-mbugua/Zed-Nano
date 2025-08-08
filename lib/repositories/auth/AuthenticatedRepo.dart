import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/contants/AppConstants.dart';
import 'package:zed_nano/models/business/BusinessDetails.dart';
import 'package:zed_nano/models/posLoginVersion2/login_response.dart';
import 'package:zed_nano/networking/base/api_response.dart';
import 'package:zed_nano/networking/datasource/remote/dio/dio_client.dart';
import 'package:zed_nano/networking/datasource/remote/exception/api_error_handler.dart';

class AuthenticatedRepo {
  
  AuthenticatedRepo({required this.dioClient, required this.sharedPreferences});
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  /// Save user authentication token
  /// 
  /// Updates the DioClient header and saves to SharedPreferences
  Future<void> saveUserToken(String token) async {
    try {
      await dioClient!.updateHeader(getToken: token);
      await sharedPreferences!.setString(AppConstants.token, token);
    } catch (e) {
      if (kDebugMode) {
        logger.e('Failed to save user token: $e');
      }
      rethrow;
    }
  }

  Future<void> saveBusinessDetails(BusinessDetails details) async {
    try {
      await BusinessDetails.saveToSharedPreferences(details);
    } catch (e) {
      if (kDebugMode) {
        logger.e('Failed to save business details: $e');
      }
      rethrow;
    }
  }

  Future<BusinessDetails?> getBusinessDetails() async {
    try {
      return await BusinessDetails.loadFromSharedPreferences();
    } catch (e) {
      if (kDebugMode) {
        logger.e('Failed to load business details: $e');
      }
      return null;
    }
  }



  /// Save full login response for later use
  Future<void> saveLoginResponse(LoginResponse loginResponse) async {
    try {
      final loginResponseJson = jsonEncode(loginResponse.toJson());
      await sharedPreferences!
          .setString(AppConstants.loginResponse, loginResponseJson);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to save login response: $e');
      }
      throw Exception('Failed to save login data: $e');
    }
  }

  /// Save user details extracted from login response
  Future<void> saveUserData(LoginUserDetails? userData) async {
    if (userData == null) {
      throw ArgumentError('User data cannot be null');
    }
    
    try {
      final userDataJson = jsonEncode(userData.toJson());
      await sharedPreferences!
          .setString(AppConstants.userDataResponse, userDataJson);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to save user data: $e');
      }
      throw Exception('Failed to save user data: $e');
    }
  }

  /// Get previously saved login response
  LoginResponse? getLoginResponse() {
    try {
      final loginResponseJson =
          sharedPreferences!.getString(AppConstants.loginResponse);
      if (loginResponseJson != null) {
        final decoded = jsonDecode(loginResponseJson);
        if (decoded is Map<String, dynamic>) {
          return LoginResponse.fromJson(decoded);
        } else if (decoded is Map) {
          return LoginResponse.fromJson(Map<String, dynamic>.from(decoded));
        } else {
          if (kDebugMode) {
            print('Unexpected login response format: ${decoded.runtimeType}');
          }
          return null;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to retrieve login response: $e');
      }
    }
    return null;
  }

  /// Get previously saved user data
  LoginUserDetails? getUserData() {
    try {
      final userDataJson =
          sharedPreferences!.getString(AppConstants.userDataResponse);
      if (userDataJson != null) {
        final decoded = jsonDecode(userDataJson);
        if (decoded is Map<String, dynamic>) {
          return LoginUserDetails.fromJson(decoded);
        } else if (decoded is Map) {
          return LoginUserDetails.fromJson(Map<String, dynamic>.from(decoded));
        } else {
          if (kDebugMode) {
            print('Unexpected user data format: ${decoded.runtimeType}');
          }
          return null;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to retrieve user data: $e');
      }
    }
    return null;
  }

  /// Get stored authentication token
  String getUserToken() {
    return sharedPreferences!.getString(AppConstants.token) ?? '';
  }

  /// Check if user is currently logged in
  bool isLoggedIn() {
    return sharedPreferences!.containsKey(AppConstants.token);
  }

  /// Clear all user data and logout
  /// 
  /// Returns true if successful, false otherwise
  Future<bool> clearSharedData() async {
    try {
      await sharedPreferences!.remove(AppConstants.token);
      await sharedPreferences!.remove(AppConstants.loginResponse);
      await sharedPreferences!.remove(AppConstants.userDataResponse);
      
      // After removing the token, update the header to clear out the token value.
      dioClient!.updateHeader(getToken: '');
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to clear user data: $e');
      }
      return false;
    }
  }

  /// Authenticate user with credentials
  /// 
  /// Returns an ApiResponse with the result
  Future<ApiResponse> login({required Map<String, dynamic> requestData}) async {
    try {
      final response =
          await dioClient!.post(AppConstants.login, data: requestData);
      
      return ApiResponse.withSuccess(response);
    } catch (e) {
      // Use the improved ApiErrorHandler that now returns ErrorResponse objects
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> loginByFirebase({required Map<String, dynamic> requestData}) async {
    try {
      final response =
          await dioClient!.post(AppConstants.loginByFirebase, data: requestData);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      // Use the improved ApiErrorHandler that now returns ErrorResponse objects
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  /// Register a new user
  /// 
  /// Returns an ApiResponse with the result
  Future<ApiResponse> register({required Map<String, dynamic> requestData}) async {
    try {
      final response =
          await dioClient!.post(AppConstants.register, data: requestData);
      
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> registerByFirebase({required Map<String, dynamic> requestData}) async {
    try {
      final response =
          await dioClient!.post(AppConstants.registerByFirebase, data: requestData);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> resetPinVersion({required Map<String, dynamic> requestData}) async {
    try {
      final response =
          await dioClient!.put(AppConstants.resetPinVersion, data: requestData);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> forgotPin({required Map<String, dynamic> requestData}) async {
    try {
      final response =
          await dioClient!.post(AppConstants.forgotPin, data: requestData);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> getTokenAfterInvite({required Map<String, dynamic> requestData}) async {
    try {
      final response =
          await dioClient!.post(AppConstants.getTokenAfterInvite, data: requestData);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> createBusiness({required Map<String, dynamic> requestData}) async {
    try {
      final response =
      await dioClient!.post(AppConstants.createBusiness, data: requestData);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  /// Refresh authentication token
  Future<ApiResponse> refreshToken({required String refreshToken}) async {
    try {
      final response = await dioClient!.post(
        AppConstants.refreshToken,
        data: {'refreshToken': refreshToken},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
}
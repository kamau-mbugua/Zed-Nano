import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zed_nano/networking/base/api_helpers.dart';
import 'package:zed_nano/networking/base/api_response.dart';
import 'package:zed_nano/networking/models/login_response.dart';
import 'package:zed_nano/networking/models/response_model.dart';
import 'package:zed_nano/providers/base_provider.dart';
import 'package:zed_nano/repositories/AuthenticatedRepo.dart';

class AuthenticatedAppProviders extends BaseProvider {
  final AuthenticatedRepo authenticatedRepo;
  
  // User state
  String _token = '';
  LoginResponse? _loginResponse;
  LoginUserDetails? _userDetails;

  // Getters
  String get token => _token;
  LoginResponse? get loginResponse => _loginResponse;
  LoginUserDetails? get userDetails => _userDetails;
  bool get isLoggedIn => _token.isNotEmpty;

  AuthenticatedAppProviders({
    required this.authenticatedRepo,
  }) {
    // Load saved user data on initialization
    _loadSavedData();
  }

  // Load data from persistent storage
  Future<void> _loadSavedData() async {
    _token = authenticatedRepo.getUserToken();
    _loginResponse = authenticatedRepo.getLoginResponse();
    _userDetails = authenticatedRepo.getUserData();
    notifyListeners();
  }

  // Helper method to perform API calls with automatic loading management
  Future<ResponseModel> _performApiCall(Future<ApiResponse> Function() apiFunction, BuildContext context) async {
    final result = await performApiCall(() async {
      ApiResponse apiResponse = await apiFunction();
      ResponseModel responseModel = await handleApiResponse(apiResponse);
      return responseModel;
    }, context);
    
    // Handle case where performApiCall returns null (an error occurred)
    return result ?? ResponseModel(
      false, 
      error?.userMessage ?? 'An unknown error occurred'
    );
  }

  // Future<ResponseModel> callEndpoint({
  //   required Future<ApiResponse> Function() apiCall
  // }) async {
  //   return await _performApiCall(apiCall);
  // }

  /// Login with provided credentials
  Future<ResponseModel<LoginResponse>> login({required Map<String, dynamic> requestData, required BuildContext context}) async {
    ResponseModel responseModel = await _performApiCall(() => 
      authenticatedRepo.login(requestData: requestData), context
    );
    
    ResponseModel<LoginResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      Map<String, dynamic> map = castMap(responseModel.data);
      _loginResponse = LoginResponse.fromJson(map);
      finalResponseModel = ResponseModel<LoginResponse>(true, responseModel.message!, _loginResponse);
      
      // Save token from the updated response structure
      final token = _loginResponse?.token ?? '';
      if (token.isNotEmpty) {
        _token = token;
        await authenticatedRepo.saveUserToken(token);
        
        // Save full login response
        await authenticatedRepo.saveLoginResponse(_loginResponse!);
        
        // Extract and save user details
        _userDetails = _loginResponse?.data?.userDetails;
        if (_userDetails != null) {
          await authenticatedRepo.saveUserData(_userDetails);
        }
        
        notifyListeners();
      }
    } else {
      finalResponseModel = ResponseModel<LoginResponse>(false, responseModel.message!);
    }
    
    return finalResponseModel;
  }

  /// Log out the current user
  Future<ResponseModel> logout(BuildContext context) async {
    return await _performApiCall(() async {
      final result = await authenticatedRepo.clearSharedData();
      
      if (result) {
        // Clear local state
        _token = '';
        _loginResponse = null;
        _userDetails = null;
        notifyListeners();
        
        // Return success response
        return ApiResponse.withSuccess(
          Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
            data: {'message': 'Logged out successfully'}
          )
        );
      } else {
        // Return error response
        return ApiResponse.withError('Failed to clear user data');
      }
    },context);
  }
  
  /// Generic method for API calls where you just need success/failure

  Future<ResponseModel> register({required Map<String, dynamic> requestData, required BuildContext context}) async {
    return await _performApiCall(() => 
      authenticatedRepo.register(requestData: requestData), context
    );
  }
  Future<ResponseModel> resetPinVersion({required Map<String, dynamic> requestData, required BuildContext context}) async {
    return await _performApiCall(() =>
      authenticatedRepo.resetPinVersion(requestData: requestData),context
    );
  }
  Future<ResponseModel> forgotPin({required Map<String, dynamic> requestData,required BuildContext context}) async {
    return await _performApiCall(() =>
      authenticatedRepo.forgotPin(requestData: requestData),context
    );
  }
}

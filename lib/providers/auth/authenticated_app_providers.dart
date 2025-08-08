import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart' as AppInitializer;
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/models/business/BusinessDetails.dart';
import 'package:zed_nano/networking/base/api_helpers.dart';
import 'package:zed_nano/networking/base/api_response.dart';
import 'package:zed_nano/models/common/CommonResponse.dart';
import 'package:zed_nano/models/get_token_after_invite/GetTokenAfterInviteResponse.dart';
import 'package:zed_nano/models/posLoginVersion2/login_response.dart';
import 'package:zed_nano/models/postBusiness/PostBusinessResponse.dart';
import 'package:zed_nano/networking/models/response_model.dart';
import 'package:zed_nano/providers/base/base_provider.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/repositories/auth/AuthenticatedRepo.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/routes/routes_helper.dart';
import 'package:zed_nano/services/business_setup_service.dart';

class AuthenticatedAppProviders extends BaseProvider {
  final AuthenticatedRepo authenticatedRepo;

  // User state
  String _token = '';
  BusinessDetails? _businessDetails;
  LoginResponse? _loginResponse;
  LoginUserDetails? _userDetails;

  // Getters
  String get token => _token;
  BusinessDetails? get businessDetails => _businessDetails;
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
    _businessDetails = (await authenticatedRepo.getBusinessDetails());
    notifyListeners();
  }

  Future<ResponseModel<LoginResponse>> _processLoginResponse(
      LoginResponse? loginResponse, BuildContext context,
      String responseMessage, String? userPin)
  async {

    if (loginResponse?.state?.toLowerCase() != 'new') {
      final token = loginResponse?.token ?? '';
      if (token.isNotEmpty) {
        _token = token;
        await authenticatedRepo.saveUserToken(token);

        final details = BusinessDetails(
            businessId: loginResponse?.defaultBusinessId,
            businessNumber: loginResponse?.businessNumber,
            group: loginResponse?.group,
            branchId: loginResponse?.branchId,
            localCurrency: loginResponse?.localCurrency,
            businessCategory: loginResponse?.businessCategory,
            businessName: loginResponse?.businessName,
        );

        _businessDetails = details;
        await authenticatedRepo.saveBusinessDetails(details);

        await authenticatedRepo.saveLoginResponse(loginResponse!);
        _userDetails = loginResponse?.data?.userDetails;
        if (_userDetails != null) {
          await authenticatedRepo.saveUserData(_userDetails);
        }
        notifyListeners();
      }
      return ResponseModel<LoginResponse>(true, responseMessage, loginResponse);
    } else {
      // await Navigator.pushNamed(context, AppRoutes.getSetPinRoutePageRoute(), arguments: {
      //   'oldPin': userPin ?? '',
      //   'userEmail': loginResponse?.email ?? ''
      // });


      // return ResponseModel<LoginResponse>(false, "New Pin, Please Change your Pin!");
      return ResponseModel<LoginResponse>(true, 'New Pin, Please Change your Pin!', loginResponse);

    }
  }


  Future<ResponseModel<LoginResponse>> login(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => authenticatedRepo.login(requestData: requestData), context);

    ResponseModel<LoginResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      _loginResponse = LoginResponse.fromJson(map);
      return await _processLoginResponse(_loginResponse,
          context, responseModel.message!,requestData['userPin'].toString());
    } else {
      finalResponseModel =
          ResponseModel<LoginResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }


  Future<ResponseModel<LoginResponse>> loginByFirebase(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => authenticatedRepo.loginByFirebase(requestData: requestData), context);

    ResponseModel<LoginResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      _loginResponse = LoginResponse.fromJson(map);
      return await _processLoginResponse(_loginResponse,
          context, responseModel.message!,requestData['userPin'].toString());
    } else {
      finalResponseModel =
          ResponseModel<LoginResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  /// Log out the current user
  Future<ResponseModel> logout(BuildContext context) async {
    return await performApiCallWithHandling(() async {
      final result = await authenticatedRepo.clearSharedData();

      if (result) {
        // Clear BusinessSetupService data to ensure clean state for next user
        try {
          final businessSetupService = BusinessSetupService();
          await businessSetupService.logout();
          logger.i('✅ BusinessSetupService logout completed');
        } catch (e) {
          logger.e('❌ Failed to logout BusinessSetupService: $e');
          // Continue with logout even if BusinessSetupService fails
        }

        // Clear local state
        _token = '';
        _loginResponse = null;
        _userDetails = null;
        notifyListeners();

        // Return success response
        return ApiResponse.withSuccess(Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
            data: {'message': 'Logged out successfully'}));
      } else {
        // Return error response
        return ApiResponse.withError('Failed to clear user data');
      }
    }, context);
  }

  /// Generic method for API calls where you just need success/failure

  Future<ResponseModel<CommonResponse>> register(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => authenticatedRepo.register(requestData: requestData), context);

    ResponseModel<CommonResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<CommonResponse>(
          true, responseModel.message!, CommonResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<CommonResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }
  Future<ResponseModel<CommonResponse>> registerByFirebase(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => authenticatedRepo.registerByFirebase(requestData: requestData), context);

    ResponseModel<CommonResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<CommonResponse>(
          true, responseModel.message!, CommonResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<CommonResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<CommonResponse>> resetPinVersion(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => authenticatedRepo.resetPinVersion(requestData: requestData),
        context);

    ResponseModel<CommonResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<CommonResponse>(
          true, responseModel.message!, CommonResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<CommonResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<CommonResponse>> forgotPin(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => authenticatedRepo.forgotPin(requestData: requestData), context);

    ResponseModel<CommonResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<CommonResponse>(
          true, responseModel.message!, CommonResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<CommonResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<GetTokenAfterInviteResponse>> getTokenAfterInvite(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => authenticatedRepo.getTokenAfterInvite(requestData: requestData), context);

    ResponseModel<GetTokenAfterInviteResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);

      final getTokenAfterInviteResponse = GetTokenAfterInviteResponse.fromJson(map);

      finalResponseModel = ResponseModel<GetTokenAfterInviteResponse>(
          true, responseModel.message!, getTokenAfterInviteResponse);

      final newToken = getTokenAfterInviteResponse.data?.token ?? '';
      if (newToken.isNotEmpty) {
        _token = newToken;
        await authenticatedRepo.saveUserToken(newToken);
        notifyListeners();
      }


    } else {
      finalResponseModel =
          ResponseModel<GetTokenAfterInviteResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }


  Future<ResponseModel<PostBusinessResponse>> createBusiness(
      {required Map<String, dynamic> requestData,required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
            () => authenticatedRepo.createBusiness(requestData:requestData), context);

    ResponseModel<PostBusinessResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      var response = PostBusinessResponse.fromJson(map);
      finalResponseModel = ResponseModel<PostBusinessResponse>(
          true, responseModel.message!,response);

      final postBusinessData = response.data;
      final newToken = postBusinessData?.token ?? '';
      if (newToken.isNotEmpty) {
        _token = newToken;

        final details = BusinessDetails(
            businessId: postBusinessData?.defaultBusinessId,
            businessNumber: postBusinessData?.businessNumber,
            group: postBusinessData?.group,
            branchId: postBusinessData?.branchId,
            localCurrency: postBusinessData?.localCurrency,
            businessCategory: postBusinessData?.businessCategory,
            businessName: postBusinessData?.businessName,
        );

        _businessDetails = details;
        await authenticatedRepo.saveBusinessDetails(details);

        await authenticatedRepo.saveUserToken(newToken);
        notifyListeners();
      }
    } else {
      finalResponseModel =
          ResponseModel<PostBusinessResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

}

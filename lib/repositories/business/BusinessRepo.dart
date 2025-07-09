import 'package:dio/dio.dart';
import 'package:zed_nano/contants/AppConstants.dart';
import 'package:zed_nano/networking/base/api_response.dart';
import 'package:zed_nano/networking/datasource/remote/dio/dio_client.dart';
import 'package:zed_nano/networking/datasource/remote/exception/api_error_handler.dart';

class BusinessRepo{
  final DioClient? dioClient;

  BusinessRepo({this.dioClient});


  Future<ApiResponse> getBusinessInfo({required Map<String, dynamic> requestData}) async {
    try {
      final response =
      await dioClient!.post('${AppConstants.getBusinessInfo}', data: requestData);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> doPushStk({required Map<String, dynamic> requestData}) async {
    try {
      final response =
      await dioClient!.post('${AppConstants.doPushStk}', data: requestData);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> doInitiateKcbStkPush({required Map<String, dynamic> requestData}) async {
    try {
      final response =
      await dioClient!.post('${AppConstants.initiateKcbStkPush}', data: requestData);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> activateFreeTrialPlan({required Map<String, dynamic> requestData}) async {
    try {
      final response =
      await dioClient!.post('${AppConstants.activateFreeTrialPlan}', data: requestData);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> createCategory({required Map<String, dynamic> requestData}) async {
    try {
      final response =
      await dioClient!.post('${AppConstants.createCategory}', data: requestData);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> createBillingInvoice({required Map<String, dynamic> requestData}) async {
    try {
      final response =
      await dioClient!.post('${AppConstants.createBillingInvoice}', data: requestData);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> uploadBusinessLogo({
    required FormData requestData,
  }) async {
    try {
      final response =
      await dioClient!.post('${AppConstants.uploadBusinessLogo}', data: requestData);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> uploadImage({
    required FormData requestData,
    required String urlPart,
  }) async {
    try {
      final response =
      await dioClient!.post('${AppConstants.uploadImage}$urlPart', data: requestData);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> getSetupStatus() async {
    try {
      final response =
      await dioClient!.get('${AppConstants.getSetupStatus}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> listBusinessCategory() async {
    try {
      final response =
      await dioClient!.get('${AppConstants.listBusinessCategory}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> getBusinessPlanPackages() async {
    try {
      final response =
      await dioClient!.get('${AppConstants.getBusinessPlanPackages}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

}
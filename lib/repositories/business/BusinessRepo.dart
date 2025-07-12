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
  Future<ApiResponse> createProduct({required Map<String, dynamic> requestData}) async {
    try {
      final response =
      await dioClient!.post('${AppConstants.createProduct}', data: requestData);

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
  Future<ApiResponse> enableCashPayment({required Map<String, dynamic> requestData, required String status}) async {
    try {
      final response =
      await dioClient!.post('${AppConstants.enableCashPayment}?status=$status', data: requestData);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> enableSettleInvoiceStatus({required Map<String, dynamic> requestData}) async {
    try {
      final response =
      await dioClient!.post('${AppConstants.enableSettleInvoiceStatus}', data: requestData);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> addKCBPayment({required Map<String, dynamic> requestData}) async {
    try {
      final response =
      await dioClient!.post('${AppConstants.addKCBPayment}', data: requestData);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> addMPESAPayment({required Map<String, dynamic> requestData}) async {
    try {
      final response =
      await dioClient!.post('${AppConstants.addMPESAPayment}', data: requestData);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> updateBusinessSetupStatus({required Map<String, dynamic> requestData}) async {
    try {
      final response =
      await dioClient!.post('${AppConstants.updateBusinessSetupStatus}', data: requestData);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> branchStoreSummary({required Map<String, dynamic> requestData}) async {
    try {
      final response =
      await dioClient!.post('${AppConstants.branchStoreSummary}', data: requestData);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> getBranchTransactionByDate({required Map<String, dynamic> requestData}) async {
    try {
      final response =
      await dioClient!.post('${AppConstants.getBranchTransactionByDate}', data: requestData);

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
  Future<ApiResponse> getPaymentMethodsWithStatus() async {
    try {
      final response =
      await dioClient!.get('${AppConstants.getPaymentMethodsWithStatus}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> getListCategories({
    required int page ,
    required int limit ,
    required String searchValue ,
    required String productService ,
  }) async {
    try {
      final response =
      await dioClient!.get('${AppConstants.getListCategories}?page=$page&limit=$limit&searchValue=$searchValue&productService=$productService');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> getListProducts({
    required int page ,
    required int limit ,
    required String searchValue ,
    required String productService ,
  }) async {
    try {
      final response =
      await dioClient!.get('${AppConstants.getListProducts}?page=$page&limit=$limit&search=$searchValue&productService=$productService');

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
  Future<ApiResponse> listSubscribedBillingPlans() async {
    try {
      final response =
      await dioClient!.get('${AppConstants.listSubscribedBillingPlans}');

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
  Future<ApiResponse> getUnitOfMeasure() async {
    try {
      final response =
      await dioClient!.get('${AppConstants.getUnitOfMeasure}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> getVariablePriceStatus() async {
    try {
      final response =
      await dioClient!.get('${AppConstants.getVariablePriceStatus}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

}
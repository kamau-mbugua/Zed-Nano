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

  Future<ApiResponse> updateBusinessInfo({required Map<String, dynamic> requestData, required String businessNumber}) async {
    try {
      final response =
      await dioClient!.put('${AppConstants.updateBusinessInfo}?businessId=$businessNumber', data: requestData);

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
  Future<ApiResponse> createCustomer({required Map<String, dynamic> requestData}) async {
    try {
      final response =
      await dioClient!.post('${AppConstants.createCustomer}', data: requestData);

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
  Future<ApiResponse> addStockRequest({required Map<String, dynamic> requestData}) async {
    try {
      final response =
      await dioClient!.post('${AppConstants.addStockRequest}', data: requestData);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> updateStockItem({required List<Map<String, dynamic>> requestData}) async {
    try {
      final response =
      await dioClient!.post('${AppConstants.updateStockItem}', data: requestData);

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
  Future<ApiResponse> getListCustomers({
    required int page ,
    required int limit ,
    required String searchValue ,
    required String status ,
    required String paymentType ,
    required String customerType ,
  }) async {
    try {
      final response =
      await dioClient!.get('${AppConstants.getListCustomers}?page=$page&limit=$limit&searchValue=$searchValue&status=$status${paymentType.isNotEmpty ? '&paymentType=$paymentType' : ''}${customerType.isNotEmpty ? '&customerType=$customerType' : ''}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> getCustomerTransactions({
    required int page ,
    required int limit ,
    required String searchValue ,
    required String customerId ,
  }) async {
    try {
      final response =
      await dioClient!.get('${AppConstants.getCustomerTransactions}?page=$page&limit=$limit&searchValue=$searchValue${customerId.isNotEmpty ? '&customerId=$customerId' : ''}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> getCustomerInvoices({
    required int page ,
    required int limit ,
    required String searchValue ,
    required String customerId ,
  }) async {
    try {
      final response =
      await dioClient!.get('${AppConstants.getCustomerInvoices}?page=$page&limit=$limit&searchValue=$searchValue${customerId.isNotEmpty ? '&customerId=$customerId' : ''}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> viewAllTransactions({
    required int page ,
    required int limit ,
    required String searchValue ,
    required String startDate ,
    required String endDate ,
  }) async {
    try {
      final response =
      await dioClient!.get('${AppConstants.viewAllTransactions}?page=$page&limit=$limit&search=$searchValue&startDate=$startDate&endDate=$endDate');

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
  Future<ApiResponse> getListByProducts({
    required int page ,
    required int limit ,
    required String searchValue ,
    required String categoryId ,
  }) async {
    try {
      final response =
      await dioClient!.get('${AppConstants.getListByProducts}?page=$page&limit=$limit&search=$searchValue&categoryId=$categoryId');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> getApprovedAddStockBatchesByBranch({
    required int page ,
    required int limit ,
    required String searchValue ,
  }) async {
    try {
      final response =
      await dioClient!.post('${AppConstants.getApprovedAddStockBatchesByBranch}?page=$page&limit=$limit');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> getApprovedBatchesByBranch({
    required int page ,
    required int limit ,
    required String searchValue ,
  }) async {
    try {
      final response =
      await dioClient!.post('${AppConstants.getApprovedBatchesByBranch}?page=$page&limit=$limit');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> getPendingAddStockBatchesByBranch({
    required int page ,
    required int limit ,
    required String searchValue ,
  }) async {
    try {
      final response =
      await dioClient!.post('${AppConstants.getPendingAddStockBatchesByBranch}?page=$page&limit=$limit');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> getPendingBatchesByBranch({
    required int page ,
    required int limit ,
    required String searchValue ,
  }) async {
    try {
      final response =
      await dioClient!.post('${AppConstants.getPendingBatchesByBranch}?page=$page&limit=$limit');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> getAllActiveStock({
    required int page ,
    required int limit ,
    required String searchValue ,
    required String categoryId ,
    required bool showStockDashboard,
  }) async {
    try {
      // Validate parameters
      if (page < 1) page = 1;
      if (limit < 1) limit = 10;
      
      // Clean search value and categoryId to avoid null/undefined issues
      final cleanSearchValue = searchValue.trim();
      final cleanCategoryId = categoryId.trim();
      
      // Build query parameters map for better URL encoding
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        'search': cleanSearchValue,
        'categoryId': cleanCategoryId,
        'showStockDashboard': showStockDashboard,
      };
      
      print('🔍 Making API call with params: $queryParams');
      
      final response = await dioClient!.get(
        AppConstants.getAllActiveStock,
        queryParameters: queryParams,
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('🔍 BusinessRepo.getAllActiveStock error: $e');
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> fetchByStatus({
    required int page ,
    required int limit ,
    required String searchValue ,
    required String status ,
    required String startDate,
    required String endDate,
    required String customerId,
    required String cashier,
  }) async {
    try {
      // Validate parameters
      if (page < 1) page = 1;
      if (limit < 1) limit = 10;

      // Clean search value and categoryId to avoid null/undefined issues
      final cleanSearchValue = searchValue.trim();

      // Build query parameters map for better URL encoding
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        'search': cleanSearchValue,
        'status': status,
        'startDate': startDate,
        'endDate': endDate,
        'customerId': customerId,
        'cashier': cashier,
      };

      print('🔍 Making API call with params: $queryParams');

      final response = await dioClient!.get(
        AppConstants.fetchByStatus,
        queryParameters: queryParams,
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('🔍 BusinessRepo.getAllActiveStock error: $e');
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> getListStockTake({
    required int page ,
    required int limit ,
    required String searchValue ,
    required String categoryId ,
  }) async {
    try {
      // Validate parameters
      if (page < 1) page = 1;
      if (limit < 1) limit = 10;

      // Clean search value and categoryId to avoid null/undefined issues
      final cleanSearchValue = searchValue.trim();
      final cleanCategoryId = categoryId.trim();

      // Build query parameters map for better URL encoding
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        'search': cleanSearchValue,
        'categoryId': cleanCategoryId,
      };


      final response = await dioClient!.get(
        AppConstants.getListStockTake,
        queryParameters: queryParams,
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('🔍 BusinessRepo.getAllActiveStock error: $e');
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> getAddStockProductsBatch({
    required int page ,
    required int limit ,
    required Map<String, dynamic> requestData ,
  }) async {
    try {
      if (page < 1) page = 1;
      if (limit < 1) limit = 10;

      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      final response = await dioClient!.post(
        AppConstants.getAddStockProductsBatch,
        queryParameters: queryParams,
        data: requestData
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> getAddStockPendingProductsBatch({
    required int page ,
    required int limit ,
    required Map<String, dynamic> requestData ,
  }) async {
    try {
      if (page < 1) page = 1;
      if (limit < 1) limit = 10;

      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      final response = await dioClient!.post(
        AppConstants.getAddStockPendingProductsBatch,
        queryParameters: queryParams,
        data: requestData
      );

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

  Future<ApiResponse> getCategoryById({required Map<String, dynamic> requestData}) async {
    try {
      final businessId = requestData['businessId'];
      final categoryId = requestData['categoryId'];
      final response =
      await dioClient!.get('${AppConstants.getCategoryById}?businessId=$businessId&categoryId=$categoryId');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  
  Future<ApiResponse> updateCategory({required Map<String, dynamic> requestData}) async {
    try {
      final categoryId = requestData['categoryId'];

      //remove categoryId from requestData
      requestData.remove('categoryId');

      final response =
      await dioClient!.put('${AppConstants.updateCategory}/$categoryId', data: requestData);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> updateProduct({required Map<String, dynamic> requestData}) async {
    try {
      final productId = requestData['productId'];

      //remove categoryId from requestData
      requestData.remove('productId');

      final response =
      await dioClient!.put('${AppConstants.updateProduct}/$productId', data: requestData);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> getProductById({required Map<String, dynamic> requestData}) async {
    try {
      final productId = requestData['productId'];
      final response =
      await dioClient!.get('${AppConstants.findProduct}/$productId');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> getCustomerByNumber({required String customerNumber}) async {
    try {
      final response =
      await dioClient!.get('${AppConstants.getCustomerByNumber}?customerId=$customerNumber');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> getOrderPaymentStatus({required Map<String, dynamic> requestData}) async {
    try {
      final response =
      await dioClient!.post('${AppConstants.getOrderPaymentStatus}', data: requestData);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> cancelPushyTransaction({required String? orderId}) async {
    try {
      final response =
      await dioClient!.put('${AppConstants.cancelPushyTransaction}?_id=$orderId');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> activateCustomer({required String customerNumber}) async {
    try {
      final response =
      await dioClient!.get('${AppConstants.activateCustomer}?customerId=$customerNumber');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> suspendCustomer({required String customerNumber}) async {
    try {
      final response =
      await dioClient!.get('${AppConstants.suspendCustomer}?customerId=$customerNumber');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
}
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;
import 'package:zed_nano/models/approval_response.dart';
import 'package:zed_nano/models/branch-store-summary/BranchStoreSummaryResponse.dart';
import 'package:zed_nano/models/branchTerminals/BranchTerminalsResponse.dart';
import 'package:zed_nano/models/by-transaction-id/TransactionDetailResponse.dart';
import 'package:zed_nano/models/cashPayment/OrderCheckoutPaymentResponse.dart';
import 'package:zed_nano/models/createCategory/CreateCategoryResponse.dart';
import 'package:zed_nano/models/getZedPayItUserById/GetZedPayItUserByIdResponse.dart';
import 'package:zed_nano/models/get_business_invoices_by_status/GetBusinessInvoicesByStatusResponse.dart';
import 'package:zed_nano/models/get_business_roles/GetBusinessRolesResponse.dart';
import 'package:zed_nano/models/get_invoice_by_invoice_number/GetInvoiceByInvoiceNumberResponse.dart';
import 'package:zed_nano/models/get_invoice_receipt_payment_methods_no_login/GetInvoiceReceiptPaymentMethodsNoLoginResponse.dart';
import 'package:zed_nano/models/get_product_gross_margin/GetProductGrossMarginResponse.dart';
import 'package:zed_nano/models/get_total_sales/GetTotalSalesResponse.dart';
import 'package:zed_nano/models/get_whatsapp_message_for_invoice/GetWhatsappMessageForInvoiceResponse.dart';
import 'package:zed_nano/models/listUsers/ListUsersResponse.dart';
import 'package:zed_nano/models/opening_closing/OpeningClosingResponse.dart';
import 'package:zed_nano/models/product_total_cost/ProductTotalCostResponse.dart';
import 'package:zed_nano/models/profile/ProfileResponse.dart';
import 'package:zed_nano/models/quantities_sold/QuantitiesSoldResponse.dart';
import 'package:zed_nano/models/sales_dashboard/SalesDashboardResponse.dart';
import 'package:zed_nano/models/sales_report/SalesReportResponse.dart';
import 'package:zed_nano/models/savePushy/CreateOrderResponse.dart';
import 'package:zed_nano/models/createProduct/CreateProductResponse.dart';
import 'package:zed_nano/models/createbillingInvoice/CreateBillingInvoiceResponse.dart';
import 'package:zed_nano/models/customerTransactions/CustomerTransactionsResponse.dart';
import 'package:zed_nano/models/customers_list/CustomerListResponse.dart';
import 'package:zed_nano/models/fetchByStatus/OrderResponse.dart';
import 'package:zed_nano/models/findProduct/FindProductResponse.dart';
import 'package:zed_nano/models/getVariablePriceStatus/GetVariablePriceStatusResponse.dart';
import 'package:zed_nano/models/get_add_stock_products_batch/StockBatchDetail.dart';
import 'package:zed_nano/models/get_all_activeStock/GetAllActiveStockResponse.dart';
import 'package:zed_nano/models/get_approved_add_stock_batches_by_branch/GetBatchesListResponse.dart';
import 'package:zed_nano/models/get_branch_transaction_by_date/BranchTransactionByDateResponse.dart';
import 'package:zed_nano/models/get_business_info/BusinessInfoResponse.dart';
import 'package:zed_nano/models/get_customer_by_number/CustomerListResponse.dart';
import 'package:zed_nano/models/get_payment_methods_with_status/PaymentMethodsResponse.dart';
import 'package:zed_nano/models/get_user_invoices/InvoiceListResponse.dart';
import 'package:zed_nano/models/listByProducts/ListByProductsResponse.dart';
import 'package:zed_nano/models/listCategories/ListCategoriesResponse.dart';
import 'package:zed_nano/models/listProducts/ListProductsResponse.dart';
import 'package:zed_nano/models/listStockTake/GetActiveStockTakeResponse.dart';
import 'package:zed_nano/models/listbillingplan_packages/BillingPlanPackagesResponse.dart';
import 'package:zed_nano/models/listsubscribed_billing_plans/SubscribedBillingPlansResponse.dart';
import 'package:zed_nano/models/order_payment_status/OrderDetailResponse.dart';
import 'package:zed_nano/models/payment_methods_status_no_auth/CheckoutPaymentResponse.dart';
import 'package:zed_nano/models/pushstk/PushStkResponse.dart';
import 'package:zed_nano/models/unitofmeasure/UnitOfMeasureResponse.dart';
import 'package:zed_nano/models/viewAllTransactions/TransactionListResponse.dart';
import 'package:zed_nano/models/void-approved/VoidApprovedResponse.dart';
import 'package:zed_nano/networking/base/api_helpers.dart';
import 'package:zed_nano/models/common/CommonResponse.dart';
import 'package:zed_nano/models/get_setup_status/SetupStatusResponse.dart';
import 'package:zed_nano/models/listBusinessCategory/ListBusinessCategoryResponse.dart';
import 'package:zed_nano/networking/models/response_model.dart';
import 'package:zed_nano/providers/base/base_provider.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/repositories/business/BusinessRepo.dart';
import 'package:zed_nano/models/generateInvoice/GenerateInvoiceResponse.dart';

class BusinessProviders extends BaseProvider {
  final BusinessRepo businessRepo;

  BusinessProviders({required this.businessRepo});

  Future<ResponseModel<BusinessInfoResponse>> getBusinessInfo(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getBusinessInfo(requestData: requestData), context);

    ResponseModel<BusinessInfoResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<BusinessInfoResponse>(
          true, responseModel.message!, BusinessInfoResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<BusinessInfoResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<PushStkResponse>> doPushStk(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.doPushStk(requestData: requestData), context);

    ResponseModel<PushStkResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<PushStkResponse>(
          true, responseModel.message!, PushStkResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<PushStkResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<PushStkResponse>> doInitiateKcbStkPush(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.doInitiateKcbStkPush(requestData: requestData),
        context);

    ResponseModel<PushStkResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<PushStkResponse>(
          true, responseModel.message!, PushStkResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<PushStkResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<CommonResponse>> resendInvoice(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.resendInvoice(requestData: requestData),
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

  Future<ResponseModel<GetWhatsappMessageForInvoiceResponse>> shareInvoice(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.shareInvoice(requestData: requestData),
        context);

    ResponseModel<GetWhatsappMessageForInvoiceResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<GetWhatsappMessageForInvoiceResponse>(
          true, responseModel.message!, GetWhatsappMessageForInvoiceResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<GetWhatsappMessageForInvoiceResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<CommonResponse>> activateFreeTrialPlan(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.activateFreeTrialPlan(requestData: requestData),
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

  Future<ResponseModel<CreateCategoryResponse>> createCategory(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.createCategory(requestData: requestData), context);

    ResponseModel<CreateCategoryResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<CreateCategoryResponse>(
          true, responseModel.message!, CreateCategoryResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<CreateCategoryResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<CreateCategoryResponse>> getCategoryById(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getCategoryById(requestData: requestData), context);

    ResponseModel<CreateCategoryResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<CreateCategoryResponse>(
          true, responseModel.message!, CreateCategoryResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<CreateCategoryResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<CommonResponse>> updateCategory(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.updateCategory(requestData: requestData), context);

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

  Future<ResponseModel<CommonResponse>> updateProduct(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.updateProduct(requestData: requestData), context);

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

  Future<ResponseModel<CommonResponse>> updateBusinessInfo(
      {required Map<String, dynamic> requestData,
      required String businessNumber,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.updateBusinessInfo(
            requestData: requestData, businessNumber: businessNumber),
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

  Future<ResponseModel<CreateProductResponse>> createProduct(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.createProduct(requestData: requestData), context);

    ResponseModel<CreateProductResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<CreateProductResponse>(
          true, responseModel.message!, CreateProductResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<CreateProductResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<CreateProductResponse>> createCustomer(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.createCustomer(requestData: requestData), context);

    ResponseModel<CreateProductResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<CreateProductResponse>(
          true, responseModel.message!, CreateProductResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<CreateProductResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<CommonResponse>> addNewUser(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.addNewUser(requestData: requestData), context);

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

  Future<ResponseModel<GetBusinessRolesResponse>> getBusinessRoles(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getBusinessRoles(requestData: requestData), context);

    ResponseModel<GetBusinessRolesResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<GetBusinessRolesResponse>(
          true, responseModel.message!, GetBusinessRolesResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<GetBusinessRolesResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<CreateOrderResponse>> createOrder(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.createOrder(requestData: requestData), context);

    ResponseModel<CreateOrderResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<CreateOrderResponse>(
          true, responseModel.message!, CreateOrderResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<CreateOrderResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<GenerateInvoiceResponse>> sendInvoice(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.sendInvoice(requestData: requestData), context);

    ResponseModel<GenerateInvoiceResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<GenerateInvoiceResponse>(
          true, responseModel.message!, GenerateInvoiceResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<GenerateInvoiceResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<CreateBillingInvoiceResponse>> createBillingInvoice(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.createBillingInvoice(requestData: requestData),
        context);

    ResponseModel<CreateBillingInvoiceResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<CreateBillingInvoiceResponse>(true,
          responseModel.message!, CreateBillingInvoiceResponse.fromJson(map));
    } else {
      finalResponseModel = ResponseModel<CreateBillingInvoiceResponse>(
          false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<CommonResponse>> enableCashPayment(
      {required Map<String, dynamic> requestData,
      required String status,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.enableCashPayment(
            requestData: requestData, status: status),
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

  Future<ResponseModel<CommonResponse>> addStockRequest(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.addStockRequest(requestData: requestData), context);

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

  Future<ResponseModel<CommonResponse>> updateStockItem(
      {required List<Map<String, dynamic>> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.updateStockItem(requestData: requestData), context);

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

  Future<ResponseModel<CommonResponse>> enableSettleInvoiceStatus(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.enableSettleInvoiceStatus(requestData: requestData),
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

  Future<ResponseModel<CommonResponse>> addKCBPayment(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.addKCBPayment(requestData: requestData), context);

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

  Future<ResponseModel<CommonResponse>> addMPESAPayment(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.addMPESAPayment(requestData: requestData), context);

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

  Future<ResponseModel<CommonResponse>> updateBusinessSetupStatus(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.updateBusinessSetupStatus(requestData: requestData),
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

  Future<ResponseModel<CommonResponse>> approveSelectedStockTake(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.approveSelectedStockTake(requestData: requestData),
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

  Future<ResponseModel<CommonResponse>> approveMultipleAddStockBatches(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.approveMultipleAddStockBatches(requestData: requestData),
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

  Future<ResponseModel<BranchStoreSummaryResponse>> branchStoreSummary(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.branchStoreSummary(requestData: requestData),
        context);

    ResponseModel<BranchStoreSummaryResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<BranchStoreSummaryResponse>(true,
          responseModel.message!, BranchStoreSummaryResponse.fromJson(map));
    } else {
      finalResponseModel = ResponseModel<BranchStoreSummaryResponse>(
          false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<SalesDashboardResponse>> getbusinessMetrics(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getbusinessMetrics(requestData: requestData),
        context);

    ResponseModel<SalesDashboardResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<SalesDashboardResponse>(true,
          responseModel.message!, SalesDashboardResponse.fromJson(map));
    } else {
      finalResponseModel = ResponseModel<SalesDashboardResponse>(
          false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<CommonResponse>> getSalesByDay(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getSalesByDay(requestData: requestData),
        context);

    ResponseModel<CommonResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<CommonResponse>(true,
          responseModel.message!, CommonResponse.fromJson(map));
    } else {
      finalResponseModel = ResponseModel<CommonResponse>(
          false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<BranchTransactionByDateResponse>>
      getBranchTransactionByDate(
          {required Map<String, dynamic> requestData,
          required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getBranchTransactionByDate(requestData: requestData),
        context);

    ResponseModel<BranchTransactionByDateResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<BranchTransactionByDateResponse>(
          true,
          responseModel.message!,
          BranchTransactionByDateResponse.fromJson(map));
    } else {
      finalResponseModel = ResponseModel<BranchTransactionByDateResponse>(
          false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<SetupStatusResponse>> getSetupStatus(
      {required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getSetupStatus(), context);

    ResponseModel<SetupStatusResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<SetupStatusResponse>(
          true, responseModel.message!, SetupStatusResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<SetupStatusResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<SubscribedBillingPlansResponse>>
      listSubscribedBillingPlans({required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.listSubscribedBillingPlans(), context);

    ResponseModel<SubscribedBillingPlansResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<SubscribedBillingPlansResponse>(true,
          responseModel.message!, SubscribedBillingPlansResponse.fromJson(map));
    } else {
      finalResponseModel = ResponseModel<SubscribedBillingPlansResponse>(
          false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<ListBusinessCategoryResponse>> listBusinessCategory(
      {required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.listBusinessCategory(), context);

    ResponseModel<ListBusinessCategoryResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<ListBusinessCategoryResponse>(true,
          responseModel.message!, ListBusinessCategoryResponse.fromJson(map));
    } else {
      finalResponseModel = ResponseModel<ListBusinessCategoryResponse>(
          false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<BillingPlanPackagesResponse>> getBusinessPlanPackages(
      {required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getBusinessPlanPackages(), context);

    ResponseModel<BillingPlanPackagesResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<BillingPlanPackagesResponse>(true,
          responseModel.message!, BillingPlanPackagesResponse.fromJson(map));
    } else {
      finalResponseModel = ResponseModel<BillingPlanPackagesResponse>(
          false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<UnitOfMeasureResponse>> getUnitOfMeasure(
      {required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getUnitOfMeasure(), context);

    ResponseModel<UnitOfMeasureResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<UnitOfMeasureResponse>(
          true, responseModel.message!, UnitOfMeasureResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<UnitOfMeasureResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<GetVariablePriceStatusResponse>> getVariablePriceStatus(
      {required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getVariablePriceStatus(), context);

    ResponseModel<GetVariablePriceStatusResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<GetVariablePriceStatusResponse>(true,
          responseModel.message!, GetVariablePriceStatusResponse.fromJson(map));
    } else {
      finalResponseModel = ResponseModel<GetVariablePriceStatusResponse>(
          false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<CommonResponse>> uploadBusinessLogo(
      {required File logo, required BuildContext context}) async {
    final formData = FormData.fromMap({
      'businessLogo': await MultipartFile.fromFile(
        logo.path,
        filename: p.basename(logo.path),
        contentType: MediaType('image', 'jpeg'), // or png
      ),
    });

    final responseModel = await performApiCallWithHandling(
        () => businessRepo.uploadBusinessLogo(requestData: formData), context);

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

  Future<ResponseModel<CommonResponse>> uploadProductCategoryImage({
    required FormData formData,
    required BuildContext context,
    required String urlPart,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.uploadImage(requestData: formData, urlPart: urlPart),
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

  Future<ResponseModel<PaymentMethodsResponse>> getPaymentMethodsWithStatus({
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getPaymentMethodsWithStatus(), context);

    ResponseModel<PaymentMethodsResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<PaymentMethodsResponse>(
          true, responseModel.message!, PaymentMethodsResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<PaymentMethodsResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<ListCategoriesResponse>> getListCategories({
    required int page,
    required int limit,
    required String productService,
    required String searchValue,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getListCategories(
            page: page,
            limit: limit,
            searchValue: searchValue,
            productService: productService),
        context);

    ResponseModel<ListCategoriesResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<ListCategoriesResponse>(
          true, responseModel.message!, ListCategoriesResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<ListCategoriesResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<CustomerListResponse>> getListCustomers({
    required int page,
    required int limit,
    required String searchValue,
    required String status,
    required String paymentType,
    required String customerType,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getListCustomers(
              page: page,
              limit: limit,
              searchValue: searchValue,
              status: status,
              paymentType: paymentType,
              customerType: customerType,
            ),
        context);

    ResponseModel<CustomerListResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<CustomerListResponse>(
          true, responseModel.message!, CustomerListResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<CustomerListResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<ListUsersResponse>> getListListUsers({
    required int page,
    required int limit,
    required String searchValue,
    required String status,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getListListUsers(
              page: page,
              limit: limit,
              searchValue: searchValue,
              status: status,
            ),
        context);

    ResponseModel<ListUsersResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<ListUsersResponse>(
          true, responseModel.message!, ListUsersResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<ListUsersResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<CustomerTransactionsResponse>> getCustomerTransactions({
    required int page,
    required int limit,
    required String searchValue,
    required String customerId,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getCustomerTransactions(
              page: page,
              limit: limit,
              searchValue: searchValue,
          customerId: customerId,
            ),
        context);

    ResponseModel<CustomerTransactionsResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<CustomerTransactionsResponse>(
          true, responseModel.message!, CustomerTransactionsResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<CustomerTransactionsResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<CustomerInvoiceListResponse>> getCustomerInvoices({
    required int page,
    required int limit,
    required String searchValue,
    required String customerId,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getCustomerInvoices(
              page: page,
              limit: limit,
              searchValue: searchValue,
          customerId: customerId,
            ),
        context);

    ResponseModel<CustomerInvoiceListResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<CustomerInvoiceListResponse>(
          true, responseModel.message!, CustomerInvoiceListResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<CustomerInvoiceListResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }
  Future<ResponseModel<OrderResponse>> fetchByStatus({
    required int page,
    required int limit,
    required String searchValue,
    required String status ,
    required String startDate,
    required String endDate,
    required String customerId,
    required String cashier,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.fetchByStatus(
              page: page,
              limit: limit,
              searchValue: searchValue,
              status: status,
              startDate: startDate,
              endDate: endDate,
              cashier: cashier,
          customerId: customerId,
            ),
        context);

    ResponseModel<OrderResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<OrderResponse>(
          true, responseModel.message!, OrderResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<OrderResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }
  Future<ResponseModel<GetBusinessInvoicesByStatusResponse>> getBusinessInvoicesByStatus({
    required int page,
    required int limit,
    required String searchValue,
    required String status ,
    required String startDate,
    required String endDate,
    required String customerId,
    required String cashier,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getBusinessInvoicesByStatus(
              page: page,
              limit: limit,
              searchValue: searchValue,
              status: status,
              startDate: startDate,
              endDate: endDate,
              cashier: cashier,
          customerId: customerId,
            ),
        context);

    ResponseModel<GetBusinessInvoicesByStatusResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<GetBusinessInvoicesByStatusResponse>(
          true, responseModel.message!, GetBusinessInvoicesByStatusResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<GetBusinessInvoicesByStatusResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<TransactionListResponse>> viewAllTransactions({
    required int page,
    required int limit,
    required String startDate,
    required String searchValue,
    required String endDate,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.viewAllTransactions(
            page: page,
            limit: limit,
            searchValue: searchValue,
            startDate: startDate,
            endDate: endDate),
        context);

    ResponseModel<TransactionListResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<TransactionListResponse>(
          true, responseModel.message!, TransactionListResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<TransactionListResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<ListProductsResponse>> getListProducts({
    required int page,
    required int limit,
    required String productService,
    required String searchValue,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getListProducts(
            page: page,
            limit: limit,
            searchValue: searchValue,
            productService: productService),
        context);

    ResponseModel<ListProductsResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<ListProductsResponse>(
          true, responseModel.message!, ListProductsResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<ListProductsResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<ListByProductsResponse>> getListByProducts({
    required int page,
    required int limit,
    required String categoryId,
    required String searchValue,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getListByProducts(
            page: page,
            limit: limit,
            searchValue: searchValue,
            categoryId: categoryId),
        context);

    ResponseModel<ListByProductsResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<ListByProductsResponse>(
          true, responseModel.message!, ListByProductsResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<ListByProductsResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<GetBatchesListResponse>>
      getApprovedAddStockBatchesByBranch({
    required int page,
    required int limit,
    required String searchValue,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getApprovedAddStockBatchesByBranch(
              page: page,
              limit: limit,
              searchValue: searchValue,
            ),
        context);

    ResponseModel<GetBatchesListResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<GetBatchesListResponse>(
          true, responseModel.message!, GetBatchesListResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<GetBatchesListResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<GetBatchesListResponse>>
  getAddStockCancelledBatchesByBranch({
    required int page,
    required int limit,
    required String searchValue,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getAddStockCancelledBatchesByBranch(
              page: page,
              limit: limit,
              searchValue: searchValue,
            ),
        context);

    ResponseModel<GetBatchesListResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<GetBatchesListResponse>(
          true, responseModel.message!, GetBatchesListResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<GetBatchesListResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<GetBatchesListResponse>> getApprovedBatchesByBranch({
    required int page,
    required int limit,
    required String searchValue,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getApprovedBatchesByBranch(
              page: page,
              limit: limit,
              searchValue: searchValue,
            ),
        context);

    ResponseModel<GetBatchesListResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<GetBatchesListResponse>(
          true, responseModel.message!, GetBatchesListResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<GetBatchesListResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<GetBatchesListResponse>> getStockTakeCancelledBatchesByBranch({
    required int page,
    required int limit,
    required String searchValue,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getStockTakeCancelledBatchesByBranch(
              page: page,
              limit: limit,
              searchValue: searchValue,
            ),
        context);

    ResponseModel<GetBatchesListResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<GetBatchesListResponse>(
          true, responseModel.message!, GetBatchesListResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<GetBatchesListResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<GetBatchesListResponse>>
      getPendingAddStockBatchesByBranch({
    required int page,
    required int limit,
    required String searchValue,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getPendingAddStockBatchesByBranch(
              page: page,
              limit: limit,
              searchValue: searchValue,
            ),
        context);

    ResponseModel<GetBatchesListResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<GetBatchesListResponse>(
          true, responseModel.message!, GetBatchesListResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<GetBatchesListResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<GetBatchesListResponse>> getPendingBatchesByBranch({
    required int page,
    required int limit,
    required String searchValue,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getPendingBatchesByBranch(
              page: page,
              limit: limit,
              searchValue: searchValue,
            ),
        context);

    ResponseModel<GetBatchesListResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<GetBatchesListResponse>(
          true, responseModel.message!, GetBatchesListResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<GetBatchesListResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<GetAllActiveStockResponse>> getAllActiveStock({
    required int page,
    required int limit,
    required String categoryId,
    required String searchValue,
    required BuildContext context,
    required bool showStockDashboard,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getAllActiveStock(
            page: page,
            limit: limit,
            searchValue: searchValue,
            categoryId: categoryId,
            showStockDashboard: showStockDashboard),
        context);

    ResponseModel<GetAllActiveStockResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<GetAllActiveStockResponse>(true,
          responseModel.message!, GetAllActiveStockResponse.fromJson(map));
    } else {
      finalResponseModel = ResponseModel<GetAllActiveStockResponse>(
          false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<GetActiveStockTakeResponse>> getListStockTake({
    required int page,
    required int limit,
    required String categoryId,
    required String searchValue,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getListStockTake(
              page: page,
              limit: limit,
              searchValue: searchValue,
              categoryId: categoryId,
            ),
        context);

    ResponseModel<GetActiveStockTakeResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<GetActiveStockTakeResponse>(true,
          responseModel.message!, GetActiveStockTakeResponse.fromJson(map));
    } else {
      finalResponseModel = ResponseModel<GetActiveStockTakeResponse>(
          false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<StockBatchDetail>> getAddStockProductsBatch({
    required int page,
    required int limit,
    required BuildContext context,
    required Map<String, dynamic> requestData,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getAddStockProductsBatch(
              page: page,
              limit: limit,
              requestData: requestData,
            ),
        context);

    ResponseModel<StockBatchDetail> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<StockBatchDetail>(
          true, responseModel.message!, StockBatchDetail.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<StockBatchDetail>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<StockBatchDetail>> getAddStockPendingProductsBatch({
    required int page,
    required int limit,
    required BuildContext context,
    required Map<String, dynamic> requestData,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getAddStockPendingProductsBatch(
              page: page,
              limit: limit,
              requestData: requestData,
            ),
        context);

    ResponseModel<StockBatchDetail> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<StockBatchDetail>(
          true, responseModel.message!, StockBatchDetail.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<StockBatchDetail>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<FindProductsResponse>> getProductById({
    required Map<String, dynamic> requestData,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getProductById(requestData: requestData), context);

    ResponseModel<FindProductsResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<FindProductsResponse>(
          true, responseModel.message!, FindProductsResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<FindProductsResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<GetCustomerByNumberResponse>> getCustomerByNumber({
    required String customerNumber,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getCustomerByNumber(customerNumber: customerNumber), context);

    ResponseModel<GetCustomerByNumberResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<GetCustomerByNumberResponse>(
          true, responseModel.message!, GetCustomerByNumberResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<GetCustomerByNumberResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<OrderDetailResponse>> getOrderPaymentStatus({
    required Map<String, dynamic> requestData,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getOrderPaymentStatus(requestData: requestData), context);

    ResponseModel<OrderDetailResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<OrderDetailResponse>(
          true, responseModel.message!, OrderDetailResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<OrderDetailResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<CommonResponse>> voidTransaction({
    required Map<String, dynamic> requestData,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.voidTransaction(requestData: requestData), context);

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

  Future<ResponseModel<ByTransactionIdDetailResponse>> getTransactionByTransactionId({
    required Map<String, dynamic> requestData,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getTransactionByTransactionId(requestData: requestData), context);

    ResponseModel<ByTransactionIdDetailResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<ByTransactionIdDetailResponse>(
          true, responseModel.message!, ByTransactionIdDetailResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<ByTransactionIdDetailResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<ApprovalResponse>> getApprovalByStatus({
    required Map<String, dynamic> requestData,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getApprovalByStatus(requestData: requestData), context);

    ResponseModel<ApprovalResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<ApprovalResponse>(
          true, responseModel.message!, ApprovalResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<ApprovalResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<GetInvoiceByInvoiceNumberResponse>> getInvoiceByInvoiceNumber({
    required Map<String, dynamic> requestData,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getInvoiceByInvoiceNumber(requestData: requestData), context);

    ResponseModel<GetInvoiceByInvoiceNumberResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<GetInvoiceByInvoiceNumberResponse>(
          true, responseModel.message!, GetInvoiceByInvoiceNumberResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<GetInvoiceByInvoiceNumberResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }


  Future<ResponseModel<GetInvoiceReceiptPaymentMethodsNoLoginResponse>> getInvoiceReceiptPaymentMethodsNoLogin({
    required Map<String, dynamic> requestData,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getInvoiceReceiptPaymentMethodsNoLogin(requestData: requestData), context);

    ResponseModel<GetInvoiceReceiptPaymentMethodsNoLoginResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<GetInvoiceReceiptPaymentMethodsNoLoginResponse>(
          true, responseModel.message!, GetInvoiceReceiptPaymentMethodsNoLoginResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<GetInvoiceReceiptPaymentMethodsNoLoginResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<CommonResponse>> doSendToPos({
    required Map<String, dynamic> requestData,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.doSendToPos(requestData: requestData), context);

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

  Future<ResponseModel<BranchTerminalsResponse>> getBranchTerminals({
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getBranchTerminals(), context);

    ResponseModel<BranchTerminalsResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<BranchTerminalsResponse>(
          true, responseModel.message!, BranchTerminalsResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<BranchTerminalsResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<CheckoutPaymentResponse>> getPaymentMethodsStatusNoAuth({
    required Map<String, dynamic> requestData,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getPaymentMethodsStatusNoAuth(requestData: requestData), context);

    ResponseModel<CheckoutPaymentResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<CheckoutPaymentResponse>(
          true, responseModel.message!, CheckoutPaymentResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<CheckoutPaymentResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<OrderCheckoutPaymentResponse>> doCashPayment({
    required Map<String, dynamic> requestData,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.doCashPayment(requestData: requestData), context);

    ResponseModel<OrderCheckoutPaymentResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<OrderCheckoutPaymentResponse>(
          true, responseModel.message!, OrderCheckoutPaymentResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<OrderCheckoutPaymentResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<OrderCheckoutPaymentResponse>> doCashPaymentInvoice({
    required Map<String, dynamic> requestData,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.doCashPaymentInvoice(requestData: requestData), context);

    ResponseModel<OrderCheckoutPaymentResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<OrderCheckoutPaymentResponse>(
          true, responseModel.message!, OrderCheckoutPaymentResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<OrderCheckoutPaymentResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<CommonResponse>> cancelPushyTransaction({
    required String? orderId,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.cancelPushyTransaction(orderId: orderId), context);

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

  Future<ResponseModel<CommonResponse>> activateCustomer({
    required String customerNumber,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.activateCustomer(customerNumber: customerNumber), context);

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

  Future<ResponseModel<GetZedPayItUserByIdResponse>> getUserByNumber({
    required String customerNumber,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getUserByNumber(customerNumber: customerNumber), context);

    ResponseModel<GetZedPayItUserByIdResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<GetZedPayItUserByIdResponse>(
          true, responseModel.message!, GetZedPayItUserByIdResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<GetZedPayItUserByIdResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<CommonResponse>> suspendCustomer({
    required String customerNumber,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.suspendCustomer(customerNumber: customerNumber), context);

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

  Future<ResponseModel<CommonResponse>> changeStatus({
    required String customerNumber,
    required String status,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.changeStatus(customerNumber: customerNumber, status: status), context);

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

  // Sales Report APIs
  Future<ResponseModel<SalesReportSummaryResponse>> getSalesSummary({
    required String startDate,
    required String endDate,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getSalesSummary(startDate: startDate, endDate: endDate), context);

    ResponseModel<SalesReportSummaryResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<SalesReportSummaryResponse>(
          true, responseModel.message!, SalesReportSummaryResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<SalesReportSummaryResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<SalesReportTotalSalesResponse>> getTotalSales({
    required String startDate,
    required String endDate,
    int limit = 10000,
    int page = 1,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getTotalSales(
          startDate: startDate,
          endDate: endDate,
          limit: limit,
          page: page,
        ), context);

    ResponseModel<SalesReportTotalSalesResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<SalesReportTotalSalesResponse>(
          true, responseModel.message!, SalesReportTotalSalesResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<SalesReportTotalSalesResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<GetProductGrossMarginResponse>> getProductGrossMargin({
    required String startDate,
    required String endDate,
    int limit = 10000,
    int page = 1,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getProductGrossMargin(
          startDate: startDate,
          endDate: endDate,
          limit: limit,
          page: page,
        ), context);

    ResponseModel<GetProductGrossMarginResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<GetProductGrossMarginResponse>(
          true, responseModel.message!, GetProductGrossMarginResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<GetProductGrossMarginResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<OpeningClosingResponse>> getClosingOpeningReport({
    required String startDate,
    required String endDate,
    int limit = 10000,
    int page = 1,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getClosingOpeningReport(
          startDate: startDate,
          endDate: endDate,
          limit: limit,
          page: page,
        ), context);

    ResponseModel<OpeningClosingResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<OpeningClosingResponse>(
          true, responseModel.message!, OpeningClosingResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<OpeningClosingResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<VoidApprovedResponse>> getVoidedTRansactionReports({
    required String startDate,
    required String endDate,
    int limit = 10000,
    int page = 1,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getVoidedTRansactionReports(
          startDate: startDate,
          endDate: endDate,
          limit: limit,
          page: page,
        ), context);

    ResponseModel<VoidApprovedResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<VoidApprovedResponse>(
          true, responseModel.message!, VoidApprovedResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<VoidApprovedResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<QuantitiesSoldResponse>> getTotalQuantitiesSold({
    required String startDate,
    required String endDate,
    int limit = 10000,
    int page = 1,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getTotalQuantitiesSold(
          startDate: startDate,
          endDate: endDate,
          limit: limit,
          page: page,
        ), context);

    ResponseModel<QuantitiesSoldResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<QuantitiesSoldResponse>(
          true, responseModel.message!, QuantitiesSoldResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<QuantitiesSoldResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<GetTotalSalesResponse>> getTotalSalesReport({
    required String startDate,
    required String endDate,
    int limit = 10000,
    int page = 1,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getTotalSalesReport(
          startDate: startDate,
          endDate: endDate,
          limit: limit,
          page: page,
        ), context);

    ResponseModel<GetTotalSalesResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<GetTotalSalesResponse>(
          true, responseModel.message!, GetTotalSalesResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<GetTotalSalesResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<ProductTotalCostResponse>> getProductTotalCost({
    required String startDate,
    required String endDate,
    required int limit,
    required int page,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getProductTotalCost(
          startDate: startDate,
          endDate: endDate,
          limit: limit,
          page: page,
        ), context);

    ResponseModel<ProductTotalCostResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<ProductTotalCostResponse>(
          true, responseModel.message!, ProductTotalCostResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<ProductTotalCostResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  // Profile related methods
  Future<ResponseModel<ProfileResponse>> getUserProfile({
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getUserProfile(), context);

    ResponseModel<ProfileResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<ProfileResponse>(
          true, responseModel.message!, ProfileResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<ProfileResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }

  Future<ResponseModel<CommonResponse>> updateUserProfile({
    required Map<String, dynamic> requestData,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.updateUserProfile(requestData: requestData), context);

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

  Future<ResponseModel<CommonResponse>> deleteUserAccount({
    required Map<String, dynamic> requestData,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.deleteUserAccount(requestData: requestData), context);

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

  Future<ResponseModel<CommonResponse>> resetUserPin({
    required Map<String, dynamic> requestData,
    required BuildContext context,
  }) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.resetUserPin(requestData: requestData), context);

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
}

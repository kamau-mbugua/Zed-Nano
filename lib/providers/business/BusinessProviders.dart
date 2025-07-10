import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;
import 'package:zed_nano/models/createCategory/CreateCategoryResponse.dart';
import 'package:zed_nano/models/createbillingInvoice/CreateBillingInvoiceResponse.dart';
import 'package:zed_nano/models/get_business_info/BusinessInfoResponse.dart';
import 'package:zed_nano/models/listCategories/ListCategoriesResponse.dart';
import 'package:zed_nano/models/listbillingplan_packages/BillingPlanPackagesResponse.dart';
import 'package:zed_nano/models/pushstk/PushStkResponse.dart';
import 'package:zed_nano/networking/base/api_helpers.dart';
import 'package:zed_nano/models/common/CommonResponse.dart';
import 'package:zed_nano/models/get_setup_status/SetupStatusResponse.dart';
import 'package:zed_nano/models/listBusinessCategory/ListBusinessCategoryResponse.dart';
import 'package:zed_nano/networking/models/response_model.dart';
import 'package:zed_nano/providers/base/base_provider.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/repositories/business/BusinessRepo.dart';

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
        () => businessRepo.doInitiateKcbStkPush(requestData: requestData), context);

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

  Future<ResponseModel<CommonResponse>> activateFreeTrialPlan(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.activateFreeTrialPlan(requestData: requestData), context);

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
  Future<ResponseModel<CreateBillingInvoiceResponse>> createBillingInvoice(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.createBillingInvoice(requestData: requestData), context);

    ResponseModel<CreateBillingInvoiceResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<CreateBillingInvoiceResponse>(
          true, responseModel.message!, CreateBillingInvoiceResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<CreateBillingInvoiceResponse>(false, responseModel.message!);
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
  Future<ResponseModel<ListBusinessCategoryResponse>> listBusinessCategory(
      {required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.listBusinessCategory(), context);

    ResponseModel<ListBusinessCategoryResponse> finalResponseModel;

    if (responseModel.isSuccess) {
      final map = castMap(responseModel.data);
      finalResponseModel = ResponseModel<ListBusinessCategoryResponse>(
          true, responseModel.message!, ListBusinessCategoryResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<ListBusinessCategoryResponse>(false, responseModel.message!);
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
      finalResponseModel = ResponseModel<BillingPlanPackagesResponse>(
          true, responseModel.message!, BillingPlanPackagesResponse.fromJson(map));
    } else {
      finalResponseModel =
          ResponseModel<BillingPlanPackagesResponse>(false, responseModel.message!);
    }

    return finalResponseModel;
  }


  Future<ResponseModel<CommonResponse>> uploadBusinessLogo(
      {required File logo ,required BuildContext context}) async {

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

  Future<ResponseModel<CommonResponse>> uploadProductCategoryImage(
      {
        required FormData formData ,
        required BuildContext context,
        required String urlPart,
      }) async {

    final responseModel = await performApiCallWithHandling(
        () => businessRepo.uploadImage(requestData: formData, urlPart:urlPart), context);

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

  Future<ResponseModel<ListCategoriesResponse>> getListCategories(
      {
        required int page ,
        required int limit ,
        required String productService ,
        required String searchValue ,
        required BuildContext context,
      }) async {

    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getListCategories(
          page: page,
          limit: limit,
          searchValue: searchValue,
            productService: productService
        ), context);

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


}

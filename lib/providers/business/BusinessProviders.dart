import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zed_nano/networking/base/api_helpers.dart';
import 'package:zed_nano/networking/models/common/CommonResponse.dart';
import 'package:zed_nano/networking/models/get_setup_status/SetupStatusResponse.dart';
import 'package:zed_nano/networking/models/listBusinessCategory/ListBusinessCategoryResponse.dart';
import 'package:zed_nano/networking/models/postBusiness/PostBusinessResponse.dart';
import 'package:zed_nano/networking/models/response_model.dart';
import 'package:zed_nano/providers/base/base_provider.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/repositories/business/BusinessRepo.dart';
import 'package:path/path.dart' as p;
import 'package:http_parser/http_parser.dart';

class BusinessProviders extends BaseProvider {
  final BusinessRepo businessRepo;

  BusinessProviders({required this.businessRepo});

  Future<ResponseModel<CommonResponse>> getBusinessInfo(
      {required Map<String, dynamic> requestData,
      required BuildContext context}) async {
    final responseModel = await performApiCallWithHandling(
        () => businessRepo.getBusinessInfo(requestData: requestData), context);

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


}

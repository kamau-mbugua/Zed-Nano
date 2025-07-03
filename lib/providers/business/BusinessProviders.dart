import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zed_nano/networking/base/api_helpers.dart';
import 'package:zed_nano/networking/models/common/CommonResponse.dart';
import 'package:zed_nano/networking/models/get_setup_status/SetupStatusResponse.dart';
import 'package:zed_nano/networking/models/response_model.dart';
import 'package:zed_nano/providers/base/base_provider.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/repositories/business/BusinessRepo.dart';

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
}

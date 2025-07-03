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
  Future<ApiResponse> getSetupStatus() async {
    try {
      final response =
      await dioClient!.get('${AppConstants.getSetupStatus}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

}
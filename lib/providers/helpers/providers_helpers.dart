import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/models/business/BusinessDetails.dart';
import 'package:zed_nano/models/posLoginVersion2/login_response.dart';
import 'package:zed_nano/networking/base/api_helpers.dart';
import 'package:zed_nano/networking/base/api_response.dart';
import 'package:zed_nano/networking/models/response_model.dart';
import 'package:zed_nano/providers/auth/authenticated_app_providers.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/providers/base/base_provider.dart';
import 'package:zed_nano/providers/business/BusinessProviders.dart';
import 'package:zed_nano/viewmodels/WorkflowViewModel.dart';

AuthenticatedAppProviders getAuthProvider(BuildContext context ,{bool listen = false}) {
  return Provider.of<AuthenticatedAppProviders>(context, listen: listen);
}

BusinessDetails? getBusinessDetails(BuildContext context) {
  logger.d('getBusinessDetails called ${getAuthProvider(context).businessDetails?.toJson()}');
  return getAuthProvider(context).businessDetails;
}
LoginUserDetails? getUserDetails(BuildContext context) {
  return getAuthProvider(context).userDetails;
}

BusinessProviders getBusinessProvider(BuildContext context,{bool listen = false}) {
  return Provider.of<BusinessProviders>(context, listen: listen);
}

WorkflowViewModel getWorkflowViewModel(BuildContext context,{bool listen = false}) {
  return Provider.of<WorkflowViewModel>(context, listen: listen);;
}

extension ProviderApiHelpers on BaseProvider {
  /// Performs an API call with automatic loading state management and
  /// standardized [ResponseModel] handling. This method can be used across
  /// any provider that extends [BaseProvider] to avoid duplicating code.
  Future<ResponseModel> performApiCallWithHandling(
    Future<ApiResponse> Function() apiFunction,
    BuildContext context,
  ) async {
    final result = await performApiCall(() async {
      final apiResponse = await apiFunction();
     /* logger.d(
          'performApiCallWithHandling API Response: \\n              \\u{1F4AC} data: \\${apiResponse.data} | success: \\${apiResponse.isSuccess}');*/
      final responseModel = await handleApiResponse(apiResponse);
      return responseModel;
    }, context);
    return result ??
        ResponseModel(false, error?.userMessage ?? 'An unknown error occurred');
  }
}

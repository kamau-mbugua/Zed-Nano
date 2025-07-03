import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/networking/base/api_helpers.dart';
import 'package:zed_nano/networking/base/api_response.dart';
import 'package:zed_nano/networking/models/response_model.dart';
import 'package:zed_nano/providers/auth/authenticated_app_providers.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/providers/base/base_provider.dart';

AuthenticatedAppProviders getAuthProvider(BuildContext context) {
  return Provider.of<AuthenticatedAppProviders>(context, listen: false);
}

// Extension on BaseProvider to add a reusable API call helper that manages
// loading and error handling automatically for all providers.
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
      logger.d(
          'performApiCallWithHandling API Response: \\n              \\u{1F4AC} data: \\${apiResponse.data} | success: \\${apiResponse.isSuccess}');
      final responseModel = await handleApiResponse(apiResponse);
      return responseModel;
    }, context);

    // If [performApiCall] returned null, propagate the error message.
    return result ??
        ResponseModel(false, error?.userMessage ?? 'An unknown error occurred');
  }
}

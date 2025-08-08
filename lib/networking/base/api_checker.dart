import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/networking/base/api_response.dart';
import 'package:zed_nano/networking/base/error_response.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';

class ApiChecker {
  static void checkApi(ApiResponse apiResponse) {
    try {
      final error = getError(apiResponse);

      if (!error.isSuccess) {
        showCustomSnackBar(error.message ?? 'An error occurred');
      }
    } catch (e) {
      logger.e('Error in ApiChecker: $e');
      showCustomSnackBar('Something went wrong. Please try again.');
    }
  }

  static ErrorResponse getError(ApiResponse apiResponse) {
    return ErrorResponse.fromJson(apiResponse);
  }
}

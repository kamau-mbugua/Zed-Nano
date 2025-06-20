// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app_loading_indicator/flutter_app_loading_indicator.dart';
// import 'package:provider/provider.dart';
// import 'package:zed_nano/providers/authenticated_app_providers.dart';
// import 'package:zed_nano/routes/routes.dart';
// import 'dio_client.dart'; // to get your AuthenticatedAppProviders
//
// class TokenRefreshInterceptor extends Interceptor {
//   final DioClient dioClient;
//   bool _isRefreshing = false;
//   List<Function> _retryQueue = [];
//
//   TokenRefreshInterceptor(this.dioClient);
//
//
//   BuildContext? appContext = navigatorKey.currentContext;
//
//
//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) async {
//     if (err.response?.statusCode == 401) {
//       if (!_isRefreshing) {
//         _isRefreshing = true;
//         try {
//           bool success = await _refreshToken();
//           if (success) {
//             // Retry all failed requests
//             for (var retry in _retryQueue) {
//               retry();
//             }
//             _retryQueue.clear();
//           } else {
//             appContext!.dismissLoading();
//             // Force logout
//             showCustomSnackBar('Session expired, please login again.');
//             await appContext?.read<AuthenticatedAppProviders>().clearSharedData();
//             // Navigate to Login
//             Navigator.pushNamedAndRemoveUntil(appContext!, AppRoutes.getSplashPageRoute(), (route) => false);
//           }
//         } catch (e) {
//           appContext!.dismissLoading();
//           showCustomSnackBar('Token refresh failed. Please login again.');
//           await appContext?.read<AuthenticatedAppProviders>().clearSharedData();
//           Navigator.pushNamedAndRemoveUntil(appContext!, AppRoutes.getSplashPageRoute(), (route) => false);
//         } finally {
//           _isRefreshing = false;
//         }
//       }
//
//       // Queue this request to retry after refreshing
//       _retryQueue.add(() {
//         dioClient.dio!
//             .fetch(err.requestOptions)
//             .then((value) => handler.resolve(value))
//             .catchError((e) => handler.reject(e));
//       });
//     } else {
//       handler.next(err);
//     }
//   }
//
//   Future<bool> _refreshToken() async {
//     final refreshToken = dioClient.sharedPreferences.getString(AppConstants.refreshToken);
//
//     if (refreshToken == null) {
//       return false;
//     }
//
//     try {
//       // Assume your refresh token API endpoint is like:
//       final response = await dioClient.dio!.post(
//         '/auth/refresh-token',
//         data: {
//           'refreshToken': refreshToken,
//         },
//       );
//
//       if (response.statusCode == 200 && response.data['statusCode'] == 5000) {
//         final newAccessToken = response.data['result']['data']['accessToken'];
//         final newRefreshToken = response.data['result']['data']['refreshToken'];
//
//         // Save new tokens
//         await dioClient.sharedPreferences.setString(AppConstants.token, newAccessToken);
//         await dioClient.sharedPreferences.setString(AppConstants.refreshToken, newRefreshToken);
//
//         // Update headers
//         await dioClient.updateHeader(getToken: newAccessToken);
//
//         return true;
//       } else {
//         return false;
//       }
//     } catch (e) {
//       return false;
//     }
//   }
// }

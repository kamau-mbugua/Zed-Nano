import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zed_nano/contants/AppConstants.dart';

import '../../../../utils/logger.dart';
import 'TokenRefreshInterceptor.dart';
import 'logging_interceptor.dart';

class DioClient {
  final String baseUrl;
  final LoggingInterceptor loggingInterceptor;
  final SharedPreferences sharedPreferences;
  // TokenRefreshInterceptor? tokenRefreshInterceptor;

  Dio? dio;
  String? token;

  DioClient(this.baseUrl,
      Dio? dioC, {
        required this.loggingInterceptor,
        required this.sharedPreferences,
      }) {
    token = sharedPreferences.getString(AppConstants.token) ?? '';

    updateHeader(dioC: dioC);

  }

  Future<void> updateHeader({String? getToken, Dio? dioC})async {
    dio = dioC ?? Dio();
    dio
      ?..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(seconds: 30)
      ..options.receiveTimeout = const Duration(seconds: 30)
      ..httpClientAdapter
      ..options.headers = {

        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Bearer ${getToken ?? token}',

      };

    // tokenRefreshInterceptor = TokenRefreshInterceptor(this);

    dio?.interceptors.add(loggingInterceptor);

  }



  Future<Response> get(String uri, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      logger.i('baseUrlGet=> $baseUrl');
      logger.i('apiCall ==> url=> $uri \nparams---> $queryParameters\nheader=> ${dio!.options.headers}');
      var response = await dio!.get(
        uri,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      logger.i('apiCall ==> url=> $uri\nparams---> $queryParameters\nheader=> ${dio!.options.headers}\nresponse=> ${response.data}');
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      logger.i('baseUrlPost=> $baseUrl');
      logger.i('apiCall ==> url=> $uri \nparams---> $queryParameters\nheader=> ${dio!.options.headers} \ndata=> $data');
      var response = await dio!.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      loggerNoStack.i('apiCall ==> url=> $uri \nparams---> $queryParameters\nheader=> ${dio!.options.headers} \ndata=> $data \nresponse=> ${response.data}');
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      debugPrint('apiCall ==> url=> $uri \nparams---> $queryParameters\nheader=> ${dio!.options.headers} \nerror=> ${e.toString()}');
      rethrow;
    }
  }

  Future<Response> put(String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    logger.i('apiCall ==> url=> $uri \nparams---> $queryParameters\nheader=> ${dio!.options.headers}');
    try {
      var response = await dio!.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    logger.i('apiCall ==> url=> $uri \nparams---> $queryParameters\nheader=> ${dio!.options.headers}');
    try {
      var response = await dio!.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }
}

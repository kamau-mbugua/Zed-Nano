import 'dart:convert';
import 'dart:developer';
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
        // Use API-Key style authentication header as required by backend
        if ((getToken ?? token).toString().isNotEmpty)
          'X-Authorization': (getToken ?? token)!,

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
      // await   _logRequest(uri, queryParameters: queryParameters);

      var response = await dio!.get(
        uri,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      // await _logResponse(uri, queryParameters: queryParameters, data: null, response: response.data);
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _logRequest(String uri, {Map<String, dynamic>? queryParameters}) async {
    logger.i('REQUEST baseUrlGet=> $baseUrl');
    logger.i('REQUEST uri=> $uri');
    logger.i('REQUEST complete uri=> ${baseUrl + uri}');
    logger.i('REQUEST params---> $queryParameters');
    final authHeader = dio!.options.headers['X-Authorization'];
    logLong('REQUEST X-Authorization: $authHeader',);
  }

  Future<void> _logResponse(String uri, {Map<String, dynamic>? queryParameters, data, response}) async {
    logger.i('REQUEST baseUrlGet=> $baseUrl');
    logger.i('REQUEST uri=> $uri');
    logger.i('REQUEST complete uri=> ${baseUrl + uri}');
    logger.i('REQUEST params---> $queryParameters');
    final authHeader = dio!.options.headers['X-Authorization'];
    logLong('REQUEST X-Authorization: $authHeader',);
    logLong('REQUEST DATA: $jsonDecode($data)');
    logLong('RESPONSE RESPONSE: $jsonDecode($response)');
  }

  void logLong(String message, {String tag = "💡"}) {
    const int chunkSize = 1000;
    int len = message.length;
    for (int i = 0; i < len; i += chunkSize) {
      print('$tag ${message.substring(i, i + chunkSize > len ? len : i + chunkSize)}');
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
      //await _logRequest(uri, queryParameters: queryParameters);

      var response = await dio!.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      //await _logResponse(uri, queryParameters: queryParameters, data: data, response: response.data);
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
    //await _logRequest(uri, queryParameters: queryParameters);

    try {
      var response = await dio!.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      //await _logResponse(uri, queryParameters: queryParameters, data: data, response: response.data);

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
    //await _logRequest(uri, queryParameters: queryParameters);
    try {
      var response = await dio!.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      //await _logResponse(uri, queryParameters: queryParameters, data: data, response: response.data);

      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }
}

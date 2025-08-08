import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:zed_nano/utils/logger.dart';

class LoggingInterceptor extends InterceptorsWrapper {
  int maxCharactersPerLine = 200;

  void logLong(String message) {
    const chunkSize = 1000;
    final len = message.length;
    for (var i = 0; i < len; i += chunkSize) {
      print(message.substring(i, i + chunkSize > len ? len : i + chunkSize));
    }
  }

  Future<void> _logRequest({required RequestOptions options, required RequestInterceptorHandler handler}) async {
    logLong('💡 <----- START HTTP REQUEST -----> 💡\n'
        '💡 REQUEST Method: ${options.method} 💡 \n'
        '💡 REQUEST PATH: ${options.path} 💡\n'
        '💡 REQUEST URL: ${options.uri} 💡\n'
        '💡 REQUEST QUERY PARAMETERS: ${_safeMapToString(options.queryParameters)} 💡\n'
        '💡 REQUEST DATA: ${
        options.data == null
          ? 'No Data'
          : options.data is Map || options.data is List
          ? _safeMapToString(options.data)
          : options.data} 💡\n'
        '💡 REQUEST X-Authorization: ${options.headers['X-Authorization']} 💡\n'
        '💡<----- END HTTP REQUEST ----->💡');
  }

  Future<void> _logResponse({required Response response, required ResponseInterceptorHandler handler}) async {

    logLong('💡 <----- START HTTP RESPONSE -----> 💡\n'
        '💡 RESPONSE Status Code: ${response.statusCode} 💡\n'
        '💡 RESPONSE Method: ${response.requestOptions.method} 💡\n'
        '💡 RESPONSE PATH: ${response.requestOptions.path} 💡\n'
        '💡 RESPONSE URL: ${response.requestOptions.uri} 💡\n'
        '💡 RESPONSE DATA: ${
        response.data == null
            ? 'null'
            : response.data is Map || response.data is List
            ? _safeMapToString(response.data)
            : response.data} 💡\n'
        '💡 RESPONSE X-Authorization: ${response.requestOptions.headers['X-Authorization']} 💡\n'
        '💡 <----- END HTTP RESPONSE -----> 💡 ');
  }
  
  // Helper method to safely convert maps to string
  String _safeMapToString(dynamic object) {
    try {
      if (object == null) return 'null';
      return jsonEncode(object);
    } catch (e) {
      // If we can't encode the whole object, try to extract safe properties
      if (object is Map) {
        final safeMap = <String, dynamic>{};
        object.forEach((key, value) {
          try {
            // Test if this entry can be encoded
            jsonEncode({key.toString(): value});
            safeMap[key.toString()] = value;
          } catch (_) {
            safeMap[key.toString()] = value.toString();
          }
        });
        return jsonEncode(safeMap);
      }
      return object.toString();
    }
  }

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    await _logRequest(options: options, handler: handler);
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) async {
    await _logResponse(response: response, handler: handler);
    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    logger.i('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path} \n'
        'MESSAGE: ${err.message}\n'
        'WHOLE ERROR: $err\n'
        'DATA: ${err.response?.data}');
    return super.onError(err, handler);
  }
}

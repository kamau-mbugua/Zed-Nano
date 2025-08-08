/// Represents an API response from the server
class ApiResponse {

  ApiResponse({
    required this.body,
    required this.statusCode,
    this.headers,
  });
  final dynamic body;
  final int statusCode;
  final Map<String, String>? headers;

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}

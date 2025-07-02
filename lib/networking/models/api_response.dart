/// Represents an API response from the server
class ApiResponse {
  final dynamic body;
  final int statusCode;
  final Map<String, String>? headers;

  ApiResponse({
    required this.body,
    required this.statusCode,
    this.headers,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}

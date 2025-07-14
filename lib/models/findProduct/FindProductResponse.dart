import 'package:zed_nano/models/listProducts/ListProductsResponse.dart';

class FindProductsResponse {
  final String? status;
  final String? message;
  final ProductData? data;

  FindProductsResponse({
    this.status,
    this.message,
    this.data,
  });

  factory FindProductsResponse.fromJson(Map<String, dynamic> json) {
    return FindProductsResponse(
      status: json['Status'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : ProductData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}
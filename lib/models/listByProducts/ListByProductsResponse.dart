import 'package:zed_nano/models/listProducts/ListProductsResponse.dart';

class ListByProductsResponse {
  final String? status;
  final String? message;
  final int? count;
  final List<ProductData>? data;

  ListByProductsResponse({
    this.status,
    this.message,
    this.count,
    this.data,
  });

  factory ListByProductsResponse.fromJson(Map<String, dynamic> json) {
    return ListByProductsResponse(
      status: json['Status'] as String?,
      message: json['message'] as String?,
      count: json['count'] as int?,
      data: (json['products'] as List<dynamic>?)
          ?.map((e) => ProductData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'message': message,
      'count': count,
      'products': data?.map((e) => e.toJson()).toList(),
    };
  }
}

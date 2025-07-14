import 'package:zed_nano/models/listCategories/ListCategoriesResponse.dart';

class CreateCategoryResponse {
  final String? status;
  final String? message;
  final ProductCategoryData? data;

  CreateCategoryResponse({
    this.status,
    this.message,
    this.data,
  });

  factory CreateCategoryResponse.fromJson(Map<String, dynamic> json) {
    return CreateCategoryResponse(
      status: json['Status'] as String?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? ProductCategoryData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
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

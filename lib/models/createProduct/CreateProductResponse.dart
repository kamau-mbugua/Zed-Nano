class CreateProductResponse {

  CreateProductResponse({
    this.status,
    this.message,
    this.productId,
  });

  factory CreateProductResponse.fromJson(Map<String, dynamic> json) {
    return CreateProductResponse(
      status: json['Status'] as String?,
      message: json['message'] as String?,
      productId: json['productId'] as String?,
    );
  }
  final String? status;
  final String? message;
  final String? productId;

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'message': message,
      'productId': productId,
    };
  }
}
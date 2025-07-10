class CreateProductResponse {
  final String? status;
  final String? message;
  final String? productId;

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

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'message': message,
      'productId': productId,
    };
  }
}
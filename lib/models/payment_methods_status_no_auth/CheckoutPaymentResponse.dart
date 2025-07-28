class CheckoutPaymentResponse {
  final String? status;
  final String? message;
  final List<String>? data;

  CheckoutPaymentResponse({
    this.status,
    this.message,
    this.data,
  });

  factory CheckoutPaymentResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutPaymentResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
    };
  }

  @override
  String toString() {
    return 'CheckoutPaymentResponse(status: $status, message: $message, data: $data)';
  }
}
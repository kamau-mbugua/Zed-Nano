class UnitOfMeasureResponse {

  UnitOfMeasureResponse({
    this.status,
    this.message,
    this.data,
  });

  factory UnitOfMeasureResponse.fromJson(Map<String, dynamic> json) {
    return UnitOfMeasureResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }
  final String? status;
  final String? message;
  final List<String>? data;

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
    };
  }
}
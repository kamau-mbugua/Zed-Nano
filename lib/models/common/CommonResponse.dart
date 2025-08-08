class CommonResponse {

  CommonResponse({
    this.status,
    this.statusCapital,
    this.message,
  });

  factory CommonResponse.fromJson(Map<String, dynamic> json) {
    return CommonResponse(
      status: json['status'] as String?,
      statusCapital: json['Status'] as String?,
      message: json['message'] as String?,
    );
  }
  final String? status;
  final String? statusCapital;
  final String? message;

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'Status': statusCapital,
      'message': message,
    };
  }
}
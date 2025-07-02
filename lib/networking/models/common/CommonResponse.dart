class CommonResponse {
  final String? status;
  final String? statusCapital;
  final String? message;

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

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'Status': statusCapital,
      'message': message,
    };
  }
}
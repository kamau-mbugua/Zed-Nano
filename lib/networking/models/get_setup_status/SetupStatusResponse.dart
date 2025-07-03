class SetupStatusResponse {
  final String? status;
  final String? message;
  final SetupStatusData? data;

  SetupStatusResponse({this.status, this.message, this.data});

  factory SetupStatusResponse.fromJson(Map<String, dynamic> json) {
    return SetupStatusResponse(
      status: json['Status'] as String?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? SetupStatusData.fromJson(json['data'] as Map<String, dynamic>)
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

class SetupStatusData {
  final String? workflowState;

  SetupStatusData({this.workflowState});

  factory SetupStatusData.fromJson(Map<String, dynamic> json) {
    return SetupStatusData(
      workflowState: json['workflowState'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workflowState': workflowState,
    };
  }
}
class SetupStatusResponse {

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
  final String? status;
  final String? message;
  final SetupStatusData? data;

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class SetupStatusData {

  SetupStatusData({this.workflowState});

  factory SetupStatusData.fromJson(Map<String, dynamic> json) {
    return SetupStatusData(
      workflowState: json['workflowState'] as String?,
    );
  }
  final String? workflowState;

  Map<String, dynamic> toJson() {
    return {
      'workflowState': workflowState,
    };
  }
}
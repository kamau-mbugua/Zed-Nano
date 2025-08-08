class PushStkResponse {

  PushStkResponse({
    this.data,
    this.status,
    this.message,
  });

  factory PushStkResponse.fromJson(Map<String, dynamic> json) {
    return PushStkResponse(
      data: json['data'] != null
          ? PushStkData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      status: json['status'] as String?,
      message: json['message'] as String?,
    );
  }
  final PushStkData? data;
  final String? status;
  final String? message;

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'status': status,
      'message': message,
    };
  }
}

class PushStkData {

  PushStkData({
    this.status,
    this.id,
    this.stkOrderId,
    this.requestReferenceId,
  });

  factory PushStkData.fromJson(Map<String, dynamic> json) {
    return PushStkData(
      status: json['status'] as int?,
      id: json['id'] as String?,
      stkOrderId: json['stkOrderId'] as String?,
      requestReferenceId: json['requestReferenceId'] as String?,
    );
  }
  final int? status;
  final String? id;
  final String? stkOrderId;
  final String? requestReferenceId;

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'id': id,
      'stkOrderId': stkOrderId,
      'requestReferenceId': requestReferenceId,
    };
  }
}
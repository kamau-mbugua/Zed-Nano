class GetVariablePriceStatusResponse {
  final String? status;
  final String? message;
  final List<VariablePriceStatus>? data;

  GetVariablePriceStatusResponse({
    this.status,
    this.message,
    this.data,
  });

  factory GetVariablePriceStatusResponse.fromJson(Map<String, dynamic> json) {
    return GetVariablePriceStatusResponse(
      status: json['Status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => VariablePriceStatus.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class VariablePriceStatus {
  final String? id;
  final String? priceStatusName;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  VariablePriceStatus({
    this.id,
    this.priceStatusName,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory VariablePriceStatus.fromJson(Map<String, dynamic> json) {
    return VariablePriceStatus(
      id: json['_id'] as String?,
      priceStatusName: json['priceStatusName'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'priceStatusName': priceStatusName,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}
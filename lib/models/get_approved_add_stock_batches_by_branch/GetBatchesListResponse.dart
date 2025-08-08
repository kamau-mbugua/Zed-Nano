class GetBatchesListResponse {

  GetBatchesListResponse({
    this.status,
    this.message,
    this.data,
    this.count,
  });

  factory GetBatchesListResponse.fromJson(Map<String, dynamic> json) {
    return GetBatchesListResponse(
      status: json['Status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BatchData.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: json['count'] as int?,
    );
  }
  final String? status;
  final String? message;
  final List<BatchData>? data;
  final int? count;

  Map<String, dynamic> toJson() => {
    'Status': status,
    'message': message,
    'data': data?.map((e) => e.toJson()).toList(),
    'count': count,
  };
}

class BatchData {

  BatchData({
    this.id,
    this.createdBy,
    this.status,
    this.dateCreated,
    this.storeId,
    this.batchId,
    this.batchNumber,
    this.approvedBy,
    this.dateApproved,
    this.approvedById,
    this.batchHeader,
    this.createdByName,
    this.productCount,
  });

  factory BatchData.fromJson(Map<String, dynamic> json) {
    return BatchData(
      id: json['_id'] as String?,
      createdBy: json['createdBy'] as String?,
      status: json['status'] as String?,
      dateCreated: json['dateCreated'] as String?,
      storeId: json['storeId'] as String?,
      batchId: json['batchId'] as String?,
      batchNumber: json['batchNumber'] as String?,
      approvedBy: json['approvedBy'] as String?,
      dateApproved: json['dateApproved'] as String?,
      approvedById: json['approvedById'] as String?,
      batchHeader: json['batchHeader'] != null
          ? BatchHeader.fromJson(json['batchHeader'] as Map<String, dynamic>)
          : null,
      createdByName: json['createdByName'] as String?,
      productCount: json['productCount'] as int?,
    );
  }
  final String? id;
  final String? createdBy;
  final String? status;
  final String? dateCreated;
  final String? storeId;
  final String? batchId;
  final String? batchNumber;
  final String? approvedBy;
  final String? dateApproved;
  final String? approvedById;
  final BatchHeader? batchHeader;
  final String? createdByName;
  final int? productCount;

  Map<String, dynamic> toJson() => {
    '_id': id,
    'createdBy': createdBy,
    'status': status,
    'dateCreated': dateCreated,
    'storeId': storeId,
    'batchId': batchId,
    'batchNumber': batchNumber,
    'approvedBy': approvedBy,
    'dateApproved': dateApproved,
    'approvedById': approvedById,
    'batchHeader': batchHeader?.toJson(),
    'createdByName': createdByName,
    'productCount': productCount,
  };
}

class BatchHeader {

  BatchHeader({this.to, this.approvedBy});

  factory BatchHeader.fromJson(Map<String, dynamic> json) {
    return BatchHeader(
      to: json['to'] as String?,
      approvedBy: json['approvedBy'] as String?,
    );
  }
  final String? to;
  final String? approvedBy;

  Map<String, dynamic> toJson() => {
    'to': to,
    'approvedBy': approvedBy,
  };
}
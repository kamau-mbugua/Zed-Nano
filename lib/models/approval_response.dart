
class ApprovalResponse {

  ApprovalResponse({
    this.status,
    this.message,
    this.data,
  });

  factory ApprovalResponse.fromJson(Map<String, dynamic> json) {
    return ApprovalResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? ApprovalListData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
  final String? status;
  final String? message;
  final ApprovalListData? data;

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }

  /// Check if the response indicates success
  bool get isSuccess => status == 'SUCCESS';

  @override
  String toString() {
    return 'ApprovalResponse(status: $status, message: $message, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApprovalResponse && 
        other.status == status &&
        other.message == message &&
        other.data == data;
  }

  @override
  int get hashCode => Object.hash(status, message, data);
}

class ApprovalListData {

  ApprovalListData({
    this.addStockCount,
    this.stockTakeCount,
    this.stockTransferCount,
    this.customersCount,
    this.usersCount,
    this.voidedTransactions,
  });

  factory ApprovalListData.fromJson(Map<String, dynamic> json) {
    return ApprovalListData(
      addStockCount: json['addStockCount'] as int?,
      stockTakeCount: json['stockTakeCount'] as int?,
      stockTransferCount: json['stockTransferCount'] as int?,
      customersCount: json['customersCount'] as int?,
      usersCount: json['usersCount'] as int?,
      voidedTransactions: json['voidCount'] as int?,
    );
  }
  final int? addStockCount;
  final int? stockTakeCount;
  final int? stockTransferCount;
  final int? customersCount;
  final int? voidedTransactions;
  final int? usersCount;

  Map<String, dynamic> toJson() {
    return {
      'addStockCount': addStockCount,
      'stockTakeCount': stockTakeCount,
      'stockTransferCount': stockTransferCount,
      'customersCount': customersCount,
      'usersCount': usersCount,
      'voidedTransactions': voidedTransactions,
    };
  }

  @override
  String toString() {
    return 'ApprovalData(addStockCount: $addStockCount, stockTakeCount: $stockTakeCount, stockTransferCount: $stockTransferCount, customersCount: $customersCount, usersCount: $usersCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApprovalListData &&
        other.addStockCount == addStockCount &&
        other.stockTakeCount == stockTakeCount &&
        other.stockTransferCount == stockTransferCount &&
        other.customersCount == customersCount &&
        other.voidedTransactions == voidedTransactions &&
        other.usersCount == usersCount;
  }

  @override
  int get hashCode => Object.hash(
      addStockCount,
      stockTakeCount,
      stockTransferCount,
    voidedTransactions,
      customersCount,
      usersCount,
  );
}


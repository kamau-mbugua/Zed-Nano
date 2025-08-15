class VoidPendingApprovalResponse {
  final String? status;
  final String? message;
  final List<VoidPendingTransaction>? transactions;
  final String? currency;
  final int? count;

  VoidPendingApprovalResponse({
    this.status,
    this.message,
    this.transactions,
    this.currency,
    this.count,
  });

  factory VoidPendingApprovalResponse.fromJson(Map<String, dynamic> json) {
    return VoidPendingApprovalResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      transactions: (json['transactions'] as List<dynamic>?)
          ?.map((item) => VoidPendingTransaction.fromJson(item as Map<String, dynamic>))
          .toList(),
      currency: json['currency'] as String?,
      count: json['count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'transactions': transactions?.map((item) => item.toJson()).toList(),
      'currency': currency,
      'count': count,
    };
  }

  /// Check if the API response was successful
  bool get isSuccess => status?.toUpperCase() == 'SUCCESS';

  /// Get the number of pending void transactions
  int get transactionCount => count ?? 0;

  /// Get formatted total count message
  String get countMessage => '$transactionCount pending void ${transactionCount == 1 ? 'transaction' : 'transactions'}';
}

class VoidPendingTransaction {
  final String? transactionType;
  final String? transactionID;
  final double? transamount;
  final String? receiptNumber;
  final String? createdAt;
  final String? dateVoidRequested;
  final String? voidRequestedBy;
  final String? status;
  final String? voidComments;
  final String? dateVoided;
  final String? voidApproveComments;
  final String? voidedBy;


  final String? voidDeclinedBy;
  final String? voidDeclineComments;
  final String? dateVoidDeclined;


  VoidPendingTransaction({
    this.transactionType,
    this.transactionID,
    this.transamount,
    this.receiptNumber,
    this.createdAt,
    this.dateVoidRequested,
    this.voidRequestedBy,
    this.status,
    this.voidComments,
    this.dateVoided,
    this.voidApproveComments,
    this.voidedBy,
    this.voidDeclinedBy,
    this.voidDeclineComments,
    this.dateVoidDeclined,

  });

  factory VoidPendingTransaction.fromJson(Map<String, dynamic> json) {
    return VoidPendingTransaction(
      transactionType: json['transactionType'] as String?,
      transactionID: json['transactionID'] as String?,
      transamount: (json['transamount']as num?)?.toDouble(),
      receiptNumber: json['receiptNumber'] as String?,
      createdAt: json['createdAt'] as String?,
      dateVoidRequested: json['dateVoidRequested'] as String?,
      voidRequestedBy: json['voidRequestedBy'] as String?,
      status: json['voidStatus'] as String?,
      voidComments: json['voidComments'] as String?,
      dateVoided: json['dateVoided'] as String?,
      voidApproveComments: json['voidApproveComments'] as String?,
      voidedBy: json['voidedBy'] as String?,
      voidDeclinedBy: json['voidDeclinedBy'] as String?,
      voidDeclineComments: json['voidDeclineComments'] as String?,
      dateVoidDeclined: json['dateVoidDeclined'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionType': transactionType,
      'transactionID': transactionID,
      'transamount': transamount,
      'receiptNumber': receiptNumber,
      'createdAt': createdAt,
      'dateVoidRequested': dateVoidRequested,
      'voidRequestedBy': voidRequestedBy,
      'status': status,
      'voidComments': voidComments,
      'dateVoided': dateVoided,
      'voidApproveComments': voidApproveComments,
      'voidedBy': voidedBy,
      'voidDeclinedBy': voidDeclinedBy,
      'voidDeclineComments': voidDeclineComments,
      'dateVoidDeclined': dateVoidDeclined,
    };
  }

}

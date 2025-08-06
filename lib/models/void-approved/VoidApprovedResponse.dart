class VoidApprovedResponse {
  final String? status;
  final String? message;
  final List<VoidApprovedTransaction>? transactions;
  final String? currency;
  final int? count;
  final double? totalAmount;

  VoidApprovedResponse({
    this.status,
    this.message,
    this.transactions,
    this.currency,
    this.count,
    this.totalAmount,
  });

  factory VoidApprovedResponse.fromJson(Map<String, dynamic> json) {
    return VoidApprovedResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      transactions: json['transactions'] != null
          ? (json['transactions'] as List)
              .map((item) => VoidApprovedTransaction.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
      currency: json['currency'] as String?,
      count: json['count'] as int?,
      totalAmount: _parseDouble(json['totalAmount']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'transactions': transactions?.map((item) => item.toJson()).toList(),
      'currency': currency,
      'count': count,
      'totalAmount': totalAmount,
    };
  }

  /// Helper method to safely parse double values
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  /// Check if the response is successful
  bool get isSuccess => status?.toUpperCase() == 'SUCCESS';

  /// Get total number of voided transactions
  int get transactionCount => transactions?.length ?? 0;

  /// Get formatted total amount with currency
  String get formattedTotalAmount {
    if (totalAmount == null || currency == null) return '0';
    return '$currency ${totalAmount!.toStringAsFixed(2)}';
  }
}

class VoidApprovedTransaction {
  final String? transactionType;
  final String? transactionID;
  final double? transamount;
  final String? receiptNumber;
  final String? createdAt;
  final String? dateVoidRequested;
  final String? voidComments;
  final String? voidRequestedBy;
  final String? voidStatus;
  final String? dateVoided;
  final String? voidApproveComments;
  final String? voidedBy;
  final String? voidDeclinedBy;

  VoidApprovedTransaction({
    this.transactionType,
    this.transactionID,
    this.transamount,
    this.receiptNumber,
    this.createdAt,
    this.dateVoidRequested,
    this.voidComments,
    this.voidRequestedBy,
    this.voidStatus,
    this.dateVoided,
    this.voidApproveComments,
    this.voidedBy,
    this.voidDeclinedBy,
  });

  factory VoidApprovedTransaction.fromJson(Map<String, dynamic> json) {
    return VoidApprovedTransaction(
      transactionType: json['transactionType'] as String?,
      transactionID: json['transactionID'] as String?,
      transamount: _parseDouble(json['transamount']),
      receiptNumber: json['receiptNumber'] as String?,
      createdAt: json['createdAt'] as String?,
      dateVoidRequested: json['dateVoidRequested'] as String?,
      voidComments: json['voidComments'] as String?,
      voidRequestedBy: json['voidRequestedBy'] as String?,
      voidStatus: json['voidStatus'] as String?,
      dateVoided: json['dateVoided'] as String?,
      voidApproveComments: json['voidApproveComments'] as String?,
      voidedBy: json['voidedBy'] as String?,
      voidDeclinedBy: json['voidDeclinedBy'] as String?,
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
      'voidComments': voidComments,
      'voidRequestedBy': voidRequestedBy,
      'voidStatus': voidStatus,
      'dateVoided': dateVoided,
      'voidApproveComments': voidApproveComments,
      'voidedBy': voidedBy,
      'voidDeclinedBy': voidDeclinedBy,
    };
  }

  /// Helper method to safely parse double values
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  /// Get clean transaction ID without _VOIDED suffix
  String get cleanTransactionID {
    if (transactionID == null) return '';
    return transactionID!.replaceAll('_VOIDED', '');
  }

  /// Check if transaction is voided
  bool get isVoided => voidStatus?.toUpperCase() == 'VOIDED';

  /// Check if transaction was declined
  bool get isDeclined => voidStatus?.toUpperCase() == 'DECLINED';

  /// Check if void request is pending
  bool get isPending => voidStatus?.toUpperCase() == 'PENDING';

  /// Get formatted transaction amount with currency symbol
  String getFormattedAmount(String? currency) {
    if (transamount == null) return '0';
    final currencySymbol = currency ?? 'KES';
    return '$currencySymbol ${transamount!.toStringAsFixed(2)}';
  }

  /// Get formatted creation date
  String get formattedCreatedDate {
    if (createdAt == null) return '';
    try {
      final dateTime = DateTime.parse(createdAt!);
      return '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return createdAt ?? '';
    }
  }

  /// Get formatted void date
  String get formattedVoidDate {
    if (dateVoided == null) return '';
    try {
      final dateTime = DateTime.parse(dateVoided!);
      return '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateVoided ?? '';
    }
  }

  /// Get formatted void request date
  String get formattedVoidRequestDate {
    if (dateVoidRequested == null) return '';
    try {
      final dateTime = DateTime.parse(dateVoidRequested!);
      return '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateVoidRequested ?? '';
    }
  }

  /// Get void status color for UI
  String get voidStatusColor {
    switch (voidStatus?.toUpperCase()) {
      case 'VOIDED':
        return '#FF4444'; // Red
      case 'PENDING':
        return '#FFA500'; // Orange
      case 'DECLINED':
        return '#808080'; // Gray
      default:
        return '#000000'; // Black
    }
  }

  /// Get transaction type display name
  String get displayTransactionType {
    switch (transactionType?.toUpperCase()) {
      case 'MPESA':
        return 'M-Pesa';
      case 'CASH':
        return 'Cash';
      case 'CARD':
        return 'Card';
      case 'BANK':
        return 'Bank Transfer';
      default:
        return transactionType ?? 'Unknown';
    }
  }
}

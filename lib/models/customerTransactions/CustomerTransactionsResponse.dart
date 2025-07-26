class CustomerTransactionsResponse {
  final String? status;
  final String? message;
  final double? total;
  final int? count;
  final List<CustomerTransaction>? transaction;
  final num? customerBalance;

  CustomerTransactionsResponse({
    this.status,
    this.message,
    this.total,
    this.count,
    this.transaction,
    this.customerBalance,
  });

  factory CustomerTransactionsResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CustomerTransactionsResponse();

    return CustomerTransactionsResponse(
      status: json['Status'] as String?,
      message: json['Message'] as String?,
      total: (json['total'] as num?)?.toDouble(),
      count: (json['count'] as num?)?.toInt(),
      transaction: (json['transaction'] as List<dynamic>?)
          ?.map((e) => CustomerTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
      customerBalance: (json['customerBalance'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'Status': status,
    'Message': message,
    'total': total,
    'count': count,
    'transaction': transaction?.map((e) => e.toJson()).toList(),
    'customerBalance': customerBalance,
  };
}

class CustomerTransaction {
  final String? transactionId;
  final String? transactionNo;
  final String? transactionTime;
  final String? servedBy;
  final double? noOfItems;
  final String? business;
  final double? amount;
  final String? approvedBy;
  final String? branchName;
  final String? customerName;
  final String? currency;
  final double? customerBalance;
  final String? status;
  final double? totalPaid;
  final double? totalInvoices;
  final double? totalOrder;

  CustomerTransaction({
    this.transactionId,
    this.transactionNo,
    this.transactionTime,
    this.servedBy,
    this.noOfItems,
    this.business,
    this.amount,
    this.approvedBy,
    this.branchName,
    this.customerName,
    this.currency,
    this.customerBalance,
    this.status,
    this.totalPaid,
    this.totalInvoices,
    this.totalOrder,
  });

  factory CustomerTransaction.fromJson(Map<String, dynamic> json) {
    return CustomerTransaction(
      transactionId: json['transactionId'] as String?,
      transactionNo: json['transactionNo'] as String?,
      transactionTime: json['transactionTime'] as String?,
      servedBy: json['servedBy'] as String?,
      noOfItems: (json['noOfItems'] as num?)?.toDouble(),
      business: json['business'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      approvedBy: json['approvedBy'] as String?,
      branchName: json['branchName'] as String?,
      customerName: json['customerName'] as String?,
      currency: json['currency'] as String?,
      customerBalance: (json['customerBalance'] as num?)?.toDouble(),
      status: json['status'] as String?,
      totalPaid: (json['totalPaid'] as num?)?.toDouble(),
      totalInvoices: (json['totalInvoices'] as num?)?.toDouble(),
      totalOrder: (json['totalOrder'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'transactionId': transactionId,
    'transactionNo': transactionNo,
    'transactionTime': transactionTime,
    'servedBy': servedBy,
    'noOfItems': noOfItems,
    'business': business,
    'amount': amount,
    'approvedBy': approvedBy,
    'branchName': branchName,
    'customerName': customerName,
    'currency': currency,
    'customerBalance': customerBalance,
    'status': status,
    'totalPaid': totalPaid,
    'totalInvoices': totalInvoices,
    'totalOrder': totalOrder,
  };
}
class CustomerTransactionsResponse {
  final String? status;
  final String? message;
  final int? total;
  final int? count;
  final List<CustomerTransaction>? transaction;
  final int? customerBalance;

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
      total: json['total'] as int?,
      count: json['count'] as int?,
      transaction: (json['transaction'] as List<dynamic>?)
          ?.map((e) => CustomerTransaction.fromJson(e as Map<String, dynamic>?))
          .toList(),
      customerBalance: json['customerBalance'] as int?,
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
  final int? noOfItems;
  final String? business;
  final int? amount;
  final String? approvedBy;
  final String? branchName;
  final String? customerName;
  final String? currency;
  final int? customerBalance;
  final String? status;
  final int? totalPaid;
  final int? totalInvoices;
  final int? totalOrder;

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

  factory CustomerTransaction.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CustomerTransaction();

    return CustomerTransaction(
      transactionId: json['transactionId'] as String?,
      transactionNo: json['transactionNo'] as String?,
      transactionTime: json['transactionTime'] as String?,
      servedBy: json['servedBy'] as String?,
      noOfItems: json['noOfItems'] as int?,
      business: json['business'] as String?,
      amount: json['amount'] as int?,
      approvedBy: json['approvedBy'] as String?,
      branchName: json['branchName'] as String?,
      customerName: json['customerName'] as String?,
      currency: json['currency'] as String?,
      customerBalance: json['customerBalance'] as int?,
      status: json['status'] as String?,
      totalPaid: json['totalPaid'] as int?,
      totalInvoices: json['totalInvoices'] as int?,
      totalOrder: json['totalOrder'] as int?,
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
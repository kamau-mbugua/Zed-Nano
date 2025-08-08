class GetInvoiceReceiptPaymentMethodsNoLoginResponse {

  GetInvoiceReceiptPaymentMethodsNoLoginResponse({
    this.status,
    this.message,
    this.data,
    this.count,
  });

  factory GetInvoiceReceiptPaymentMethodsNoLoginResponse.fromJson(Map<String, dynamic> json) {
    return GetInvoiceReceiptPaymentMethodsNoLoginResponse(
      status: json['Status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => PaymentReceipt.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: (json['count'] as num?)?.toInt(),
    );
  }
  final String? status;
  final String? message;
  final List<PaymentReceipt>? data;
  final int? count;

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
      'count': count,
    };
  }
}

class PaymentReceipt {

  PaymentReceipt({
    this.modeOfPayment,
    this.transactionCode,
    this.transactionDate,
    this.amount,
    this.currency,
    this.receiptNumber,
  });

  factory PaymentReceipt.fromJson(Map<String, dynamic> json) {
    return PaymentReceipt(
      modeOfPayment: json['modeOfPayment'] as String?,
      transactionCode: json['transactionCode'] as String?,
      transactionDate: json['transactionDate'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      receiptNumber: json['receiptNumber'] as String?,
    );
  }
  final String? modeOfPayment;
  final String? transactionCode;
  final String? transactionDate;
  final double? amount;
  final String? currency;
  final String? receiptNumber;

  Map<String, dynamic> toJson() {
    return {
      'modeOfPayment': modeOfPayment,
      'transactionCode': transactionCode,
      'transactionDate': transactionDate,
      'amount': amount,
      'currency': currency,
      'receiptNumber': receiptNumber,
    };
  }
}

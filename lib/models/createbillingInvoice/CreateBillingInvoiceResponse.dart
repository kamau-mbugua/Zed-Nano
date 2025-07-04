class CreateBillingInvoiceResponse {
  final String? status;
  final String? message;
  final int? amount;
  final String? invoiceNumber;
  final String? businessNumber;
  final String? invoiceId;
  final String? invoiceStatus;
  final String? billingPeriod;
  final String? billingPlanName;
  final int? freeTrialDays;

  CreateBillingInvoiceResponse({
    this.status,
    this.message,
    this.amount,
    this.invoiceNumber,
    this.businessNumber,
    this.invoiceId,
    this.invoiceStatus,
    this.billingPeriod,
    this.billingPlanName,
    this.freeTrialDays,
  });

  factory CreateBillingInvoiceResponse.fromJson(Map<String, dynamic> json) {
    return CreateBillingInvoiceResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      amount: json['amount'] as int?,
      invoiceNumber: json['invoiceNumber'] as String?,
      businessNumber: json['businessNumber'] as String?,
      invoiceId: json['invoiceId'] as String?,
      invoiceStatus: json['invoiceStatus'] as String?,
      billingPeriod: json['billingPeriod'] as String?,
      billingPlanName: json['billingPlanName'] as String?,
      freeTrialDays: json['freeTrialDays'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'amount': amount,
      'invoiceNumber': invoiceNumber,
      'businessNumber': businessNumber,
      'invoiceId': invoiceId,
      'invoiceStatus': invoiceStatus,
      'billingPeriod': billingPeriod,
      'billingPlanName': billingPlanName,
      'freeTrialDays': freeTrialDays,
    };
  }
}
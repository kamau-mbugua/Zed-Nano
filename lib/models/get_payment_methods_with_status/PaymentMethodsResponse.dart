class PaymentMethodsResponse {

  PaymentMethodsResponse({
    this.status,
    this.message,
    this.data,
  });

  factory PaymentMethodsResponse.fromJson(Map<String, dynamic> json) {
    return PaymentMethodsResponse(
      status: json['Status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  final String? status;
  final String? message;
  final List<PaymentMethod>? data;
}
class PaymentMethod {

  PaymentMethod({
    this.name,
    this.status,
    this.bankdepositStatus,
    this.paymentOptions,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      name: json['name'] as String?,
      status: json['status'] as bool?,
      bankdepositStatus: json['bankdepositStatus'] as bool?,
      paymentOptions: (json['paymentOptions'] as List<dynamic>?)
          ?.map((e) => PaymentOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  final String? name;
  final bool? status;
  final bool? bankdepositStatus;
  final List<PaymentOption>? paymentOptions;
}
class PaymentOption {

  PaymentOption({
    this.name,
    this.kcb,
    this.equity,
    this.coOperative,
  });

  factory PaymentOption.fromJson(Map<String, dynamic> json) {
    return PaymentOption(
      name: json['name'] as String?,
      kcb: (json['kcb'] as List<dynamic>?)
          ?.map((e) => BankPayment.fromJson(e as Map<String, dynamic>))
          .toList(),
      equity: (json['equity'] as List<dynamic>?)
          ?.map((e) => BankPayment.fromJson(e as Map<String, dynamic>))
          .toList(),
      coOperative: (json['coOperative'] as List<dynamic>?)
          ?.map((e) => BankPayment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  final String? name;
  final List<BankPayment>? kcb;
  final List<BankPayment>? equity;
  final List<BankPayment>? coOperative;
}

class BankPayment {

  BankPayment({
    this.name,
    this.status,
    this.count,
  });

  factory BankPayment.fromJson(Map<String, dynamic> json) {
    return BankPayment(
      name: json['name'] as String?,
      status: json['status'] as bool?,
      count: json['count'] as int?,
    );
  }
  final String? name;
  final bool? status;
  final int? count;
}
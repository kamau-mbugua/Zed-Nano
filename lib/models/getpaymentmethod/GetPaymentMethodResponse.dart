class GetPaymentMethodResponse {
  final List<PaymentMethodData>? data;
  final String? status;
  final String? message;

  GetPaymentMethodResponse({
    this.data,
    this.status,
    this.message,
  });

  factory GetPaymentMethodResponse.fromJson(Map<String, dynamic> json) {
    return GetPaymentMethodResponse(
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => PaymentMethodData.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
      status: json['status'] as String?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((item) => item.toJson()).toList(),
      'status': status,
      'message': message,
    };
  }

  /// Check if the API response was successful
  bool get isSuccess => status?.toLowerCase() == 'success';

  /// Get payment method names as a list of strings
  List<String> get paymentMethodNames =>
      data?.map((method) => method.name ?? '').where((name) => name.isNotEmpty).toList() ?? [];

  /// Get payment method values as a list of strings
  List<String> get paymentMethodValues =>
      data?.map((method) => method.value ?? '').where((value) => value.isNotEmpty).toList() ?? [];

  /// Find payment method by name
  PaymentMethodData? findByName(String name) {
    return data?.firstWhere(
      (method) => method.name?.toLowerCase() == name.toLowerCase(),
      orElse: () => PaymentMethodData(),
    );
  }

  /// Find payment method by value
  PaymentMethodData? findByValue(String value) {
    return data?.firstWhere(
      (method) => method.value?.toLowerCase() == value.toLowerCase(),
      orElse: () => PaymentMethodData(),
    );
  }
}

class PaymentMethodData {
  final String? name;
  final String? value;

  PaymentMethodData({
    this.name,
    this.value,
  });

  factory PaymentMethodData.fromJson(Map<String, dynamic> json) {
    return PaymentMethodData(
      name: json['name'] as String?,
      value: json['value'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }

  /// Get display name for UI (falls back to value if name is null)
  String get displayName => name ?? value ?? 'Unknown';

  /// Get the value for API calls (falls back to name if value is null)
  String get apiValue => value ?? name ?? '';

  /// Check if this payment method is valid (has either name or value)
  bool get isValid => (name?.isNotEmpty ?? false) || (value?.isNotEmpty ?? false);

  /// Check if this is a mobile payment method
  bool get isMobilePayment =>
      displayName.toLowerCase().contains('mobile') ||
      displayName.toLowerCase().contains('mpesa') ||
      displayName.toLowerCase().contains('money');

  /// Check if this is a bank transfer method
  bool get isBankTransfer =>
      displayName.toLowerCase().contains('rtgs') ||
      displayName.toLowerCase().contains('eft') ||
      displayName.toLowerCase().contains('pesalink') ||
      displayName.toLowerCase().contains('bank');

  /// Check if this is a card payment method
  bool get isCardPayment =>
      displayName.toLowerCase().contains('card');

  /// Check if this is a cheque payment method
  bool get isChequePayment =>
      displayName.toLowerCase().contains('cheque');

  @override
  String toString() => 'PaymentMethodData(name: $name, value: $value)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentMethodData &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          value == other.value;

  @override
  int get hashCode => name.hashCode ^ value.hashCode;
}

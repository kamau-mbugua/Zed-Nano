import 'package:flutter/material.dart';
import 'package:zed_nano/models/customers_list/CustomerListResponse.dart';

class CustomerInvoicingViewModel extends ChangeNotifier {
  Customer? _customerData;
  Customer? get customerData => _customerData;

  final Map<String, dynamic> _invoiceDetailData = {};
  
  InvoiceDetailItem get invoiceDetailItem {
    return InvoiceDetailItem.fromJson(_invoiceDetailData);
  }

  void setCustomerData(Customer? value) {
    _customerData = value;
    notifyListeners();
  }

  void addInvoiceDetailItem({
    String? type,
    String? frequency,
    String? purchaseOrderNumber,
    String? customerId,
  }) {
    _invoiceDetailData.addAll(
      {
        'type': type,
        'frequency': frequency,
        'purchaseOrderNumber': purchaseOrderNumber,
        'customerId': customerId,
      },
    );
    notifyListeners();
  }

  //clear data
  void clearData() {
    _customerData = null;
    _invoiceDetailData.clear();
    notifyListeners();
  }
}


class InvoiceDetailItem {
  final String type;
  final String frequency;
  final String purchaseOrderNumber;
  final String customerId;

  InvoiceDetailItem({
    required this.type,
    required this.frequency,
    required this.purchaseOrderNumber,
    required this.customerId,
  });

  factory InvoiceDetailItem.fromJson(Map<String, dynamic> json) {
    return InvoiceDetailItem(
      type: json['type'] as String? ?? '',
      frequency: json['frequency'] as String? ?? '',
      purchaseOrderNumber: json['purchaseOrderNumber'] as String? ?? '',
      customerId: json['customerId'] as String? ?? '',
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'frequency': frequency,
      'purchaseOrderNumber': purchaseOrderNumber,
      'customerId': customerId
    };
  }
}
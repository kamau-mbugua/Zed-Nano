class OrderCheckoutPaymentResponse {
  final String? status;
  final String? message;
  final CashPaymentData? data;

  OrderCheckoutPaymentResponse({
    this.status,
    this.message,
    this.data,
  });

  factory OrderCheckoutPaymentResponse.fromJson(Map<String, dynamic> json) {
    return OrderCheckoutPaymentResponse(
      status: json['Status'] as String?,
      message: json['message'] as String?,
      data: json['data'] != null ? CashPaymentData.fromJson(json['data'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }

  @override
  String toString() {
    return 'OrderCheckoutPaymentResponse(status: $status, message: $message, data: $data)';
  }
}

class CashPaymentData {
  final CashPaymentResults? results;

  CashPaymentData({
    this.results,
  });

  factory CashPaymentData.fromJson(Map<String, dynamic> json) {
    return CashPaymentData(
      results: json['results'] != null ? CashPaymentResults.fromJson(json['results'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'results': results?.toJson(),
    };
  }

  @override
  String toString() {
    return 'CashPaymentData(results: $results)';
  }
}

class CashPaymentResults {
  final String? transactionID;
  final String? receiptNumber;
  final String? businessName;
  final double? transamount;
  final String? status;
  final String? zedSequenceNumber;
  final String? zedReceiptNumber;
  final String? businessSequenceNumber;
  final String? businessReceiptNumber;
  final String? businessNo;
  final String? serialNo;
  final String? transactionType;
  final String? transtime;
  final String? businessShortCode;
  final String? billRefNo;
  final String? customerPhone;
  final String? customerFirstName;
  final String? customerMiddleName;
  final String? customerSecondName;
  final String? paybillBalance;
  final String? requestType;
  final String? uploadTime;
  final String? versionCode;
  final String? versionName;
  final String? appBuildTime;
  final String? cashier;
  final String? paymentChanel;
  final String? productName;
  final String? productCategory;
  final List<String>? pushyTransactionId;
  final String? userId;
  final List<dynamic>? items;
  final bool? settled;
  final bool? multiOrder;
  final String? branchId;
  final String? businessIdString;
  final String? paidOrderId;
  final String? customerId;
  final String? orderType;
  final double? discountAmount;
  final double? discountPercent;
  final String? sequenceNumber;
  final String? termId;
  final String? documentType;
  final List<dynamic>? invoicesIds;
  final double? refundAmount;
  final bool? transferredToSchool;
  final bool? approvedTransaction;
  final List<dynamic>? seatNumbers;
  final bool? duplicatePrint;
  final String? terminalSerialNumber;
  final String? tellerId;
  final bool? isPreOrder;
  final String? businessType;
  final String? cardNumber;
  final String? cardPresentSettlementStatus;
  final double? cardPresentCharge;
  final String? isSponsorpayment;
  final String? zeddebitaccountNumber;
  final bool? isBillingPayment;
  final String? insuranceCompanyName;
  final String? id;
  final String? transactionCreated;
  final List<dynamic>? orders;
  final List<dynamic>? paidOrders;
  final List<dynamic>? invoices;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  CashPaymentResults({
    this.transactionID,
    this.receiptNumber,
    this.businessName,
    this.transamount,
    this.status,
    this.zedSequenceNumber,
    this.zedReceiptNumber,
    this.businessSequenceNumber,
    this.businessReceiptNumber,
    this.businessNo,
    this.serialNo,
    this.transactionType,
    this.transtime,
    this.businessShortCode,
    this.billRefNo,
    this.customerPhone,
    this.customerFirstName,
    this.customerMiddleName,
    this.customerSecondName,
    this.paybillBalance,
    this.requestType,
    this.uploadTime,
    this.versionCode,
    this.versionName,
    this.appBuildTime,
    this.cashier,
    this.paymentChanel,
    this.productName,
    this.productCategory,
    this.pushyTransactionId,
    this.userId,
    this.items,
    this.settled,
    this.multiOrder,
    this.branchId,
    this.businessIdString,
    this.paidOrderId,
    this.customerId,
    this.orderType,
    this.discountAmount,
    this.discountPercent,
    this.sequenceNumber,
    this.termId,
    this.documentType,
    this.invoicesIds,
    this.refundAmount,
    this.transferredToSchool,
    this.approvedTransaction,
    this.seatNumbers,
    this.duplicatePrint,
    this.terminalSerialNumber,
    this.tellerId,
    this.isPreOrder,
    this.businessType,
    this.cardNumber,
    this.cardPresentSettlementStatus,
    this.cardPresentCharge,
    this.isSponsorpayment,
    this.zeddebitaccountNumber,
    this.isBillingPayment,
    this.insuranceCompanyName,
    this.id,
    this.transactionCreated,
    this.orders,
    this.paidOrders,
    this.invoices,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory CashPaymentResults.fromJson(Map<String, dynamic> json) {
    return CashPaymentResults(
      transactionID: json['transactionID'] as String?,
      receiptNumber: json['receiptNumber'] as String?,
      businessName: json['businessName'] as String?,
      transamount: (json['transamount'] as num?)?.toDouble(),
      status: json['status'] as String?,
      zedSequenceNumber: json['zedSequenceNumber'] as String?,
      zedReceiptNumber: json['zedReceiptNumber'] as String?,
      businessSequenceNumber: json['businessSequenceNumber'] as String?,
      businessReceiptNumber: json['businessReceiptNumber'] as String?,
      businessNo: json['businessNo'] as String?,
      serialNo: json['serialNo'] as String?,
      transactionType: json['transactionType'] as String?,
      transtime: json['transtime'] as String?,
      businessShortCode: json['businessShortCode'] as String?,
      billRefNo: json['billRefNo'] as String?,
      customerPhone: json['customerPhone'] as String?,
      customerFirstName: json['customerFirstName'] as String?,
      customerMiddleName: json['customerMiddleName'] as String?,
      customerSecondName: json['customerSecondName'] as String?,
      paybillBalance: json['paybillBalance'] as String?,
      requestType: json['requestType'] as String?,
      uploadTime: json['uploadTime'] as String?,
      versionCode: json['versionCode'] as String?,
      versionName: json['versionName'] as String?,
      appBuildTime: json['appBuildTime'] as String?,
      cashier: json['cashier'] as String?,
      paymentChanel: json['paymentChanel'] as String?,
      productName: json['productName'] as String?,
      productCategory: json['productCategory'] as String?,
      pushyTransactionId: (json['pushyTransactionId'] as List<dynamic>?)?.map((e) => e as String).toList(),
      userId: json['userId'] as String?,
      items: json['items'] as List<dynamic>?,
      settled: json['settled'] as bool?,
      multiOrder: json['multiOrder'] as bool?,
      branchId: json['branchId'] as String?,
      businessIdString: json['businessIdString'] as String?,
      paidOrderId: json['paidOrderId'] as String?,
      customerId: json['customerId'] as String?,
      orderType: json['orderType'] as String?,
      discountAmount: (json['discountAmount'] as num?)?.toDouble(),
      discountPercent: (json['discountPercent'] as num?)?.toDouble(),
      sequenceNumber: json['sequenceNumber'] as String?,
      termId: json['termId'] as String?,
      documentType: json['documentType'] as String?,
      invoicesIds: json['invoicesIds'] as List<dynamic>?,
      refundAmount: (json['refundAmount'] as num?)?.toDouble(),
      transferredToSchool: json['transferredToSchool'] as bool?,
      approvedTransaction: json['approvedTransaction'] as bool?,
      seatNumbers: json['seatNumbers'] as List<dynamic>?,
      duplicatePrint: json['duplicatePrint'] as bool?,
      terminalSerialNumber: json['terminalSerialNumber'] as String?,
      tellerId: json['tellerId'] as String?,
      isPreOrder: json['isPreOrder'] as bool?,
      businessType: json['businessType'] as String?,
      cardNumber: json['cardNumber'] as String?,
      cardPresentSettlementStatus: json['cardPresentSettlementStatus'] as String?,
      cardPresentCharge: (json['cardPresentCharge'] as num?)?.toDouble(),
      isSponsorpayment: json['isSponsorpayment'] as String?,
      zeddebitaccountNumber: json['zeddebitaccountNumber'] as String?,
      isBillingPayment: json['isBillingPayment'] as bool?,
      insuranceCompanyName: json['insuranceCompanyName'] as String?,
      id: json['_id'] as String?,
      transactionCreated: json['transactionCreated'] as String?,
      orders: json['orders'] as List<dynamic>?,
      paidOrders: json['paidOrders'] as List<dynamic>?,
      invoices: json['invoices'] as List<dynamic>?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionID': transactionID,
      'receiptNumber': receiptNumber,
      'businessName': businessName,
      'transamount': transamount,
      'status': status,
      'zedSequenceNumber': zedSequenceNumber,
      'zedReceiptNumber': zedReceiptNumber,
      'businessSequenceNumber': businessSequenceNumber,
      'businessReceiptNumber': businessReceiptNumber,
      'businessNo': businessNo,
      'serialNo': serialNo,
      'transactionType': transactionType,
      'transtime': transtime,
      'businessShortCode': businessShortCode,
      'billRefNo': billRefNo,
      'customerPhone': customerPhone,
      'customerFirstName': customerFirstName,
      'customerMiddleName': customerMiddleName,
      'customerSecondName': customerSecondName,
      'paybillBalance': paybillBalance,
      'requestType': requestType,
      'uploadTime': uploadTime,
      'versionCode': versionCode,
      'versionName': versionName,
      'appBuildTime': appBuildTime,
      'cashier': cashier,
      'paymentChanel': paymentChanel,
      'productName': productName,
      'productCategory': productCategory,
      'pushyTransactionId': pushyTransactionId,
      'userId': userId,
      'items': items,
      'settled': settled,
      'multiOrder': multiOrder,
      'branchId': branchId,
      'businessIdString': businessIdString,
      'paidOrderId': paidOrderId,
      'customerId': customerId,
      'orderType': orderType,
      'discountAmount': discountAmount,
      'discountPercent': discountPercent,
      'sequenceNumber': sequenceNumber,
      'termId': termId,
      'documentType': documentType,
      'invoicesIds': invoicesIds,
      'refundAmount': refundAmount,
      'transferredToSchool': transferredToSchool,
      'approvedTransaction': approvedTransaction,
      'seatNumbers': seatNumbers,
      'duplicatePrint': duplicatePrint,
      'terminalSerialNumber': terminalSerialNumber,
      'tellerId': tellerId,
      'isPreOrder': isPreOrder,
      'businessType': businessType,
      'cardNumber': cardNumber,
      'cardPresentSettlementStatus': cardPresentSettlementStatus,
      'cardPresentCharge': cardPresentCharge,
      'isSponsorpayment': isSponsorpayment,
      'zeddebitaccountNumber': zeddebitaccountNumber,
      'isBillingPayment': isBillingPayment,
      'insuranceCompanyName': insuranceCompanyName,
      '_id': id,
      'transactionCreated': transactionCreated,
      'orders': orders,
      'paidOrders': paidOrders,
      'invoices': invoices,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }

  @override
  String toString() {
    return 'CashPaymentResults(transactionID: $transactionID, receiptNumber: $receiptNumber, businessName: $businessName, transamount: $transamount, status: $status)';
  }
}
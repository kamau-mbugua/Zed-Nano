class TransactionListResponse {
  final String? status;
  final String? message;
  final int? total;
  final int? count;
  final List<TransactionTotal>? transactionTotals;
  final List<TransactionData>? data;

  TransactionListResponse({
    this.status,
    this.message,
    this.total,
    this.count,
    this.transactionTotals,
    this.data,
  });

  factory TransactionListResponse.fromJson(Map<String, dynamic> json) {
    return TransactionListResponse(
      status: json['Status'] as String?,
      message: json['message'] as String?,
      total: json['Total'] as int?,
      count: json['count'] as int?,
      transactionTotals: (json['TransactionTotals'] as List<dynamic>?)
          ?.map((e) => TransactionTotal.fromJson(e as Map<String, dynamic>))
          .toList(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => TransactionData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TransactionTotal {
  final String? transactionType;
  final int? totals;

  TransactionTotal({
    this.transactionType,
    this.totals,
  });

  factory TransactionTotal.fromJson(Map<String, dynamic> json) {
    return TransactionTotal(
      transactionType: json['transactionType'] as String?,
      totals: json['totals'] as int?,
    );
  }
}

class TransactionData {
  final String? id;
  final String? businessNo;
  final String? businessName;
  final String? transactionType;
  final String? transtime;
  final int? transamount;
  final String? customerPhone;
  final String? customerFirstName;
  final String? customerMiddleName;
  final String? customerSecondName;
  final String? paybillBalance;
  final String? requestType;
  final String? versionCode;
  final String? cashier;
  final String? userId;
  final String? receiptNumber;
  final List<TransactionItem>? items;
  final bool? settled;
  final String? customerId;
  final int? discountAmount;
  final int? discountPercent;
  final String? invoiceId;
  final String? status;
  final String? documentType;
  final String? terminalSerialNumber;
  final String? serialNo;
  final String? transactionID;
  final String? billRefNo;
  final String? uploadTime;
  final String? currency;

  TransactionData({
    this.id,
    this.businessNo,
    this.businessName,
    this.transactionType,
    this.transtime,
    this.transamount,
    this.customerPhone,
    this.customerFirstName,
    this.customerMiddleName,
    this.customerSecondName,
    this.paybillBalance,
    this.requestType,
    this.versionCode,
    this.cashier,
    this.userId,
    this.receiptNumber,
    this.items,
    this.settled,
    this.customerId,
    this.discountAmount,
    this.discountPercent,
    this.invoiceId,
    this.status,
    this.documentType,
    this.terminalSerialNumber,
    this.serialNo,
    this.transactionID,
    this.billRefNo,
    this.uploadTime,
    this.currency,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      id: json['_id'] as String?,
      businessNo: json['businessNo'] as String?,
      businessName: json['businessName'] as String?,
      transactionType: json['transactionType'] as String?,
      transtime: json['transtime'] as String?,
      transamount: (json['transamount'] as num?)?.toInt(),
      customerPhone: json['customerPhone'] as String?,
      customerFirstName: json['customerFirstName'] as String?,
      customerMiddleName: json['customerMiddleName'] as String?,
      customerSecondName: json['customerSecondName'] as String?,
      paybillBalance: json['paybillBalance'] as String?,
      requestType: json['requestType'] as String?,
      versionCode: json['versionCode'] as String?,
      cashier: json['cashier'] as String?,
      userId: json['userId'] as String?,
      receiptNumber: json['receiptNumber'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => TransactionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      settled: json['settled'] as bool?,
      customerId: json['customerId'] as String?,
      discountAmount: (json['discountAmount'] as num?)?.toInt(),
      discountPercent: (json['discountPercent'] as num?)?.toInt(),
      invoiceId: json['invoiceId'] as String?,
      status: json['status'] as String?,
      documentType: json['documentType'] as String?,
      terminalSerialNumber: json['terminalSerialNumber'] as String?,
      serialNo: json['serialNo'] as String?,
      transactionID: json['transactionID'] as String?,
      billRefNo: json['billRefNo'] as String?,
      uploadTime: json['uploadTime'] as String?,
      currency: json['currency'] as String?,
    );
  }
}

class TransactionItem {
  final double? itemAmount;
  final String? itemCategory;
  final double? itemCount;
  final String? itemName;
  final String? reciptNumber;
  final double? totalAmount;
  final String? productId;
  final String? orderNote;
  final String? variationKeyId;
  final String? variationKey;
  final List<String>? tags;
  final double? discountPercent;
  final String? discountType;
  final double? discount;
  final bool? isPreOrder;
  final String? pumpId;
  final String? beneficiary;
  final String? mileage;
  final String? id;
  final List<dynamic>? additionalItems;

  TransactionItem({
    this.itemAmount,
    this.itemCategory,
    this.itemCount,
    this.itemName,
    this.reciptNumber,
    this.totalAmount,
    this.productId,
    this.orderNote,
    this.variationKeyId,
    this.variationKey,
    this.tags,
    this.discountPercent,
    this.discountType,
    this.discount,
    this.isPreOrder,
    this.pumpId,
    this.beneficiary,
    this.mileage,
    this.id,
    this.additionalItems,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      itemAmount: (json['itemAmount'] as num?)?.toDouble(),
      itemCategory: json['itemCategory'] as String?,
      itemCount: (json['itemCount'] as num?)?.toDouble(),
      itemName: json['itemName'] as String?,
      reciptNumber: json['reciptNumber'] as String?,
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      productId: json['productId'] as String?,
      orderNote: json['orderNote'] as String?,
      variationKeyId: json['variationKeyId'] as String?,
      variationKey: json['variationKey'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      discountPercent: (json['discountPercent'] as num?)?.toDouble(),
      discountType: json['discountType'] as String?,
      discount: (json['discount'] as num?)?.toDouble(),
      isPreOrder: json['isPreOrder'] as bool?,
      pumpId: json['pumpId'] as String?,
      beneficiary: json['beneficiary'] as String?,
      mileage: json['mileage'] as String?,
      id: json['_id'] as String?,
      additionalItems: json['additionalItems'] as List<dynamic>?,
    );
  }
}
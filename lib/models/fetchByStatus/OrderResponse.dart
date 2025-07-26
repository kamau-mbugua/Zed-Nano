class OrderResponse {
  String? status;
  String? message;
  int? total;
  List<OrdeTotal>? transactionTotals;
  List<OrderData>? transaction;
  OrderSummary? orderSummary;
  int? count;

  OrderResponse({
    this.status,
    this.message,
    this.total,
    this.transactionTotals,
    this.transaction,
    this.orderSummary,
    this.count,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      status: json['Status'] as String?,
      message: json['Message'] as String?,
      total: json['total'] as int?,
      transactionTotals: (json['TransactionTotals'] as List?)
          ?.map((e) => OrdeTotal.fromJson(e as Map<String, dynamic>))
          .toList(),
      transaction: (json['transaction'] as List?)
          ?.map((e) => OrderData.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: json['count'] as int?,
      orderSummary: json['orderSummary'] as OrderSummary?,
    );
  }
}

class OrderSummary {
  double? orderTotal;
  int? orderCount;
  String? currency;

  OrderSummary({
    this.orderTotal,
    this.orderCount,
    this.currency,
  });

  factory OrderSummary.fromJson(Map<String, dynamic> json) {
    return OrderSummary(
      orderTotal: (json['orderTotal'] as int)?.toDouble(),
      orderCount: json['orderCount'] as int?,
      currency: json['currency'] as String?,
    );
  }
}

class OrdeTotal {
  int? totals;

  OrdeTotal({this.totals});

  factory OrdeTotal.fromJson(Map<String, dynamic> json) {
    return OrdeTotal(
      totals: json['Totals'] as int?,
    );
  }
}

class OrderData {
  String? id;
  int? transamount;
  String? transtime;
  String? businessId;
  String? serialNo;
  String? cashier;
  String? customerName;
  String? paymentMethod;
  String? pushTransactionId;
  String? orderTable;
  String? status;
  String? servedBy;
  String? userId;
  bool? duplicate;
  List<TransactionItem>? items;
  double? vat;
  double? subTotal;
  String? parentOrderId;
  String? branchId;
  String? businessIdString;
  bool? multiOrderImplementation;
  String? customerId;
  String? customerPaymentType;
  String? customerType;
  String? orderType;
  int? balance;
  int? customerBalance;
  int? discountAmount;
  int? discountPercent;
  String? storeId;
  bool? orderFullfilled;
  List<dynamic>? stkOrderList;
  String? stkOrderId;
  bool? zedPayItOrder;
  String? orderStatus;
  String? orderNumberSequence;
  String? orderNumber;
  int? numberOfReprints;
  bool? isOrderPreorder;
  int? cardPresentCharge;
  String? isStudentSponsoredOrder;
  String? creditNoteStatus;
  bool? isZedCreditNote;
  bool? isKraInvoice;
  List<dynamic>? remainingItems;
  List<dynamic>? partialPayments;
  List<dynamic>? reprintHistory;
  String? createdAt;
  String? updatedAt;
  int? v;
  int? deficit;
  List<dynamic>? childOrders;
  int? childUnpaid;
  int? billTotal;
  int? total;
  String? currency;

  OrderData({
    this.id,
    this.transamount,
    this.transtime,
    this.businessId,
    this.serialNo,
    this.cashier,
    this.customerName,
    this.paymentMethod,
    this.pushTransactionId,
    this.orderTable,
    this.status,
    this.servedBy,
    this.userId,
    this.duplicate,
    this.items,
    this.vat,
    this.subTotal,
    this.parentOrderId,
    this.branchId,
    this.businessIdString,
    this.multiOrderImplementation,
    this.customerId,
    this.customerPaymentType,
    this.customerType,
    this.orderType,
    this.balance,
    this.customerBalance,
    this.discountAmount,
    this.discountPercent,
    this.storeId,
    this.orderFullfilled,
    this.stkOrderList,
    this.stkOrderId,
    this.zedPayItOrder,
    this.orderStatus,
    this.orderNumberSequence,
    this.orderNumber,
    this.numberOfReprints,
    this.isOrderPreorder,
    this.cardPresentCharge,
    this.isStudentSponsoredOrder,
    this.creditNoteStatus,
    this.isZedCreditNote,
    this.isKraInvoice,
    this.remainingItems,
    this.partialPayments,
    this.reprintHistory,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.deficit,
    this.childOrders,
    this.childUnpaid,
    this.billTotal,
    this.total,
    this.currency,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['_id'] as String?,
      transamount: json['transamount'] as int?,
      transtime: json['transtime'] as String?,
      businessId: json['businessId'] as String?,
      serialNo: json['serialNo'] as String?,
      cashier: json['cashier'] as String?,
      customerName: json['customerName'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      pushTransactionId: json['pushTransactionId'] as String?,
      orderTable: json['orderTable'] as String?,
      status: json['status'] as String?,
      servedBy: json['servedBy'] as String?,
      userId: json['userId'] as String?,
      duplicate: json['duplicate'] as bool?,
      items: (json['items'] as List?)
          ?.map((e) => TransactionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      vat: _parseDouble(json['vat']),
      subTotal: _parseDouble(json['subTotal']),
      parentOrderId: json['parentOrderId'] as String?,
      branchId: json['branchId'] as String?,
      businessIdString: json['businessIdString'] as String?,
      multiOrderImplementation: json['multiOrderImplementation'] as bool?,
      customerId: json['customerId'] as String?,
      customerPaymentType: json['customerPaymentType'] as String?,
      customerType: json['customerType'] as String?,
      orderType: json['orderType'] as String?,
      balance: json['balance'] as int?,
      customerBalance: json['customerBalance'] as int?,
      discountAmount: json['discountAmount'] as int?,
      discountPercent: json['discountPercent'] as int?,
      storeId: json['storeId'] as String?,
      orderFullfilled: json['orderFullfilled'] as bool?,
      stkOrderList: json['stkOrderList'] as List?,
      stkOrderId: json['stkOrderId'] as String?,
      zedPayItOrder: json['zedPayItOrder'] as bool?,
      orderStatus: json['orderStatus'] as String?,
      orderNumberSequence: json['orderNumberSequence'] as String?,
      orderNumber: json['orderNumber'] as String?,
      numberOfReprints: json['numberOfReprints'] as int?,
      isOrderPreorder: json['isOrderPreorder'] as bool?,
      cardPresentCharge: json['cardPresentCharge'] as int?,
      isStudentSponsoredOrder: json['isStudentSponsoredOrder'] as String?,
      creditNoteStatus: json['creditNoteStatus'] as String?,
      isZedCreditNote: json['isZedCreditNote'] as bool?,
      isKraInvoice: json['isKraInvoice'] as bool?,
      remainingItems: json['remainingItems'] as List?,
      partialPayments: json['partialPayments'] as List?,
      reprintHistory: json['reprintHistory'] as List?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
      deficit: json['deficit'] as int?,
      childOrders: json['childOrders'] as List?,
      childUnpaid: json['childUnpaid'] as int?,
      billTotal: json['billTotal'] as int?,
      total: json['total'] as int?,
      currency: json['currency'] as String?,
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else if (value is num) {
      return value.toDouble();
    } else {
      return null;
    }
  }
}

class TransactionItem {
  int? itemAmount;
  String? itemName;
  String? itemCategory;
  int? itemCount;
  String? reciptNumber;
  int? totalAmount;
  String? orderNote;
  String? productId;
  String? variationKeyId;
  String? variationKey;
  List<String>? tags;
  int? discountPercent;
  String? discountType;
  int? discount;
  bool? isPreOrder;
  String? pumpId;
  String? beneficiary;
  String? mileage;
  String? taxTyCd;
  String? taxType;
  String? id;
  List<dynamic>? additionalItems;

  TransactionItem({
    this.itemAmount,
    this.itemName,
    this.itemCategory,
    this.itemCount,
    this.reciptNumber,
    this.totalAmount,
    this.orderNote,
    this.productId,
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
    this.taxTyCd,
    this.taxType,
    this.id,
    this.additionalItems,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      itemAmount: json['itemAmount'] as int?,
      itemName: json['itemName'] as String?,
      itemCategory: json['itemCategory'] as String?,
      itemCount: json['itemCount'] as int?,
      reciptNumber: json['reciptNumber'] as String?,
      totalAmount: json['totalAmount'] as int?,
      orderNote: json['orderNote'] as String?,
      productId: json['productId'] as String?,
      variationKeyId: json['variationKeyId'] as String?,
      variationKey: json['variationKey'] as String?,
      tags: (json['tags'] as List?)?.map((e) => e as String).toList(),
      discountPercent: json['discountPercent'] as int?,
      discountType: json['discountType'] as String?,
      discount: json['discount'] as int?,
      isPreOrder: json['isPreOrder'] as bool?,
      pumpId: json['pumpId'] as String?,
      beneficiary: json['beneficiary'] as String?,
      mileage: json['mileage'] as String?,
      taxTyCd: json['taxTyCd'] as String?,
      taxType: json['taxType'] as String?,
      id: json['_id'] as String?,
      additionalItems: json['additionalItems'] as List?,
    );
  }
}
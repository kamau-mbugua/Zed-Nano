class OrderDetailResponse {
  final String? status;
  final OrderDetailData? data;
  final OrderDetail? order;
  final List<OrderTransactionTotals>? transactionsList;

  OrderDetailResponse({
    this.status,
    this.data,
    this.order,
    this.transactionsList,
  });

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) {
    return OrderDetailResponse(
      status: json['Status'] as String?,
      data: json['data'] != null ? OrderDetailData.fromJson(json['data'] as Map<String, dynamic>) : null,
      order: json['order'] != null ? OrderDetail.fromJson(json['order'] as Map<String, dynamic>) : null,
      transactionsList: (json['transactionsList'] as List<dynamic>?)
          ?.map((e) => OrderTransactionTotals.fromJson(e as Map<String, dynamic>))
          .toList(),    );
  }
}

class OrderTransactionTotals {
  final String? transactionType;
  final String? transactionId;
  final String? transactionDate;
  final String? currency;
  final String? receiptId;
  final double? amount;

  OrderTransactionTotals({
    this.transactionType,
    this.transactionId,
    this.transactionDate,
    this.currency,
    this.receiptId,
    this.amount,
  });

  factory OrderTransactionTotals.fromJson(Map<String, dynamic> json) {
    return OrderTransactionTotals(
      transactionType: json['transactionType'] as String?,
      transactionId: json['transactionId'] as String?,
      transactionDate: json['transactionDate'] as String?,
      currency: json['currency'] as String?,
      receiptId: json['receiptId'] as String?,
      amount: (json['total'] as num?)?.toDouble(),
    );
  }
}

class OrderDetailData {
  final double? billAmount;
  final double? totalPaid;
  final String? cashier;
  final String? pushyTransactionId;
  final String? orderTable;
  final bool? paid;
  final double? deficit;

  OrderDetailData({
    this.billAmount,
    this.totalPaid,
    this.cashier,
    this.pushyTransactionId,
    this.orderTable,
    this.paid,
    this.deficit,
  });

  factory OrderDetailData.fromJson(Map<String, dynamic> json) {
    return OrderDetailData(
      billAmount: (json['billAmount'] as num?)?.toDouble(),
      totalPaid: (json['totalPaid'] as num?)?.toDouble(),
      cashier: json['cashier'] as String?,
      pushyTransactionId: json['pushyTransactionId'] as String?,
      orderTable: json['orderTable'] as String?,
      paid: json['paid'] as bool?,
      deficit: (json['deficit'] as num?)?.toDouble(),
    );
  }
}

class OrderDetail {
  final String? id;
  final double? transamount;
  final String? transtime;
  final String? businessId;
  final String? serialNo;
  final String? cashier;
  final String? customerName;
  final String? pushTransactionId;
  final String? orderTable;
  final String? status;
  final String? userId;
  final bool? duplicate;
  final List<OrderItem>? items;
  final double? vat;
  final double? subTotal;
  final String? parentOrderId;
  final String? branchId;
  final String? businessIdString;
  final bool? multiOrderImplementation;
  final String? customerId;
  final String? customerPaymentType;
  final String? customerType;
  final String? orderType;
  final double? balance;
  final double? customerBalance;
  final double? discountAmount;
  final double? discountPercent;
  final String? storeId;
  final bool? orderFullfilled;
  final List<dynamic>? stkOrderList;
  final String? stkOrderId;
  final bool? zedPayItOrder;
  final String? orderStatus;
  final String? orderNumberSequence;
  final String? orderNumber;
  final int? numberOfReprints;
  final bool? isOrderPreorder;
  final double? cardPresentCharge;
  final String? isStudentSponsoredOrder;
  final String? creditNoteStatus;
  final bool? isZedCreditNote;
  final bool? isKraInvoice;
  final List<dynamic>? remainingItems;
  final List<dynamic>? partialPayments;
  final List<dynamic>? reprintHistory;
  final String? createdAt;
  final String? updatedAt;
  final int? v;
  final List<dynamic>? childOrders;
  final bool? isChild;
  final String? customerPhone;
  final String? customerEmail;
  final String? transactionId;
  final String? insuranceCompanyName;
  final bool? superVisorCanDoReturn;
  final String? branchName;
  final String? transactionStatus;
  final String? currency;

  OrderDetail({
    this.id,
    this.transamount,
    this.transtime,
    this.businessId,
    this.serialNo,
    this.cashier,
    this.customerName,
    this.pushTransactionId,
    this.orderTable,
    this.status,
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
    this.childOrders,
    this.isChild,
    this.customerPhone,
    this.customerEmail,
    this.transactionId,
    this.insuranceCompanyName,
    this.superVisorCanDoReturn,
    this.branchName,
    this.transactionStatus,
    this.currency,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['_id'] as String?,
      transamount: (json['transamount'] as num?)?.toDouble(),
      transtime: json['transtime'] as String?,
      businessId: json['businessId'] as String?,
      serialNo: json['serialNo'] as String?,
      cashier: json['cashier'] as String?,
      customerName: json['customerName'] as String?,
      pushTransactionId: json['pushTransactionId'] as String?,
      orderTable: json['orderTable'] as String?,
      status: json['status'] as String?,
      userId: json['userId'] as String?,
      duplicate: json['duplicate'] as bool?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      vat: (json['vat'] as num?)?.toDouble(),
      subTotal: (json['subTotal'] as num?)?.toDouble(),
      parentOrderId: json['parentOrderId'] as String?,
      branchId: json['branchId'] as String?,
      businessIdString: json['businessIdString'] as String?,
      multiOrderImplementation: json['multiOrderImplementation'] as bool?,
      customerId: json['customerId'] as String?,
      customerPaymentType: json['customerPaymentType'] as String?,
      customerType: json['customerType'] as String?,
      orderType: json['orderType'] as String?,
      balance: (json['balance'] as num?)?.toDouble(),
      customerBalance: (json['customerBalance'] as num?)?.toDouble(),
      discountAmount: (json['discountAmount'] as num?)?.toDouble(),
      discountPercent: (json['discountPercent'] as num?)?.toDouble(),
      storeId: json['storeId'] as String?,
      orderFullfilled: json['orderFullfilled'] as bool?,
      stkOrderList: json['stkOrderList'] as List<dynamic>?,
      stkOrderId: json['stkOrderId'] as String?,
      zedPayItOrder: json['zedPayItOrder'] as bool?,
      orderStatus: json['orderStatus'] as String?,
      orderNumberSequence: json['orderNumberSequence'] as String?,
      orderNumber: json['orderNumber'] as String?,
      numberOfReprints: json['numberOfReprints'] as int?,
      isOrderPreorder: json['isOrderPreorder'] as bool?,
      cardPresentCharge: (json['cardPresentCharge'] as num?)?.toDouble(),
      isStudentSponsoredOrder: json['isStudentSponsoredOrder'] as String?,
      creditNoteStatus: json['creditNoteStatus'] as String?,
      isZedCreditNote: json['isZedCreditNote'] as bool?,
      isKraInvoice: json['isKraInvoice'] as bool?,
      remainingItems: json['remainingItems'] as List<dynamic>?,
      partialPayments: json['partialPayments'] as List<dynamic>?,
      reprintHistory: json['reprintHistory'] as List<dynamic>?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
      childOrders: json['childOrders'] as List<dynamic>?,
      isChild: json['isChild'] as bool?,
      customerPhone: json['customerPhone'] as String?,
      customerEmail: json['customerEmail'] as String?,
      transactionId: json['transactionId'] as String?,
      insuranceCompanyName: json['insuranceCompanyName'] as String?,
      superVisorCanDoReturn: json['superVisorCanDoReturn'] as bool?,
      branchName: json['branchName'] as String?,
      transactionStatus: json['transactionStatus'] as String?,
      currency: json['currency'] as String?,
    );
  }
}

class OrderItem {
  final double? itemAmount;
  final String? itemCategory;
  final int? itemCount;
  final String? itemName;
  final String? orderNote;
  final String? reciptNumber;
  final double? totalAmount;
  final String? productId;
  final String? id;
  final String? status;
  final double? discount;
  final String? pumpId;
  final String? beneficiary;
  final String? mileage;
  final String? imagePath;
  final String? currency;

  OrderItem({
    this.itemAmount,
    this.itemCategory,
    this.itemCount,
    this.itemName,
    this.orderNote,
    this.reciptNumber,
    this.totalAmount,
    this.productId,
    this.id,
    this.status,
    this.discount,
    this.pumpId,
    this.beneficiary,
    this.mileage,
    this.imagePath,
    this.currency,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      itemAmount: (json['itemAmount'] as num?)?.toDouble(),
      itemCategory: json['itemCategory'] as String?,
      itemCount: json['itemCount'] as int?,
      itemName: json['itemName'] as String?,
      orderNote: json['orderNote'] as String?,
      reciptNumber: json['reciptNumber'] as String?,
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      productId: json['productId'] as String?,
      id: json['_id'] as String?,
      status: json['status'] as String?,
      discount: (json['discount'] as num?)?.toDouble(),
      pumpId: json['pumpId'] as String?,
      beneficiary: json['beneficiary'] as String?,
      mileage: json['mileage'] as String?,
      imagePath: json['imagePath'] as String?,
      currency: json['currency'] as String?,
    );
  }
}
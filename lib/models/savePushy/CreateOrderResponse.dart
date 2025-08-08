class CreateOrderResponse {

  CreateOrderResponse({
    this.status,
    this.message,
    this.data,
  });

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) => CreateOrderResponse(
    status: json['Status'] as String?,
    message: json['message'] as String?,
    data: json['data'] != null ? TransactionData.fromJson(json['data'] as Map<String, dynamic>) : null,
  );
  String? status;
  String? message;
  TransactionData? data;
}

class TransactionData {

  TransactionData({
    this.transamount,
    this.transtime,
    this.businessId,
    this.cashier,
    this.customerName,
    this.pushTransactionId,
    this.status,
    this.userId,
    this.duplicate,
    this.items,
    this.vat,
    this.subTotal,
    this.branchId,
    this.businessIdString,
    this.multiOrderImplementation,
    this.customerPaymentType,
    this.balance,
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
    this.id,
    this.remainingItems,
    this.partialPayments,
    this.reprintHistory,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) => TransactionData(
    transamount: (json['transamount'] as num?)?.toDouble(),
    transtime: json['transtime'] as String?,
    businessId: json['businessId'] as String?,
    cashier: json['cashier'] as String?,
    customerName: json['customerName'] as String?,
    pushTransactionId: json['pushTransactionId'] as String?,
    status: json['status'] as String?,
    userId: json['userId'] as String?,
    duplicate: json['duplicate'] as bool?,
    items: (json['items'] as List<dynamic>?)?.map((e) => TransactionItem.fromJson(e as Map<String, dynamic>)).toList(),
    vat: (json['vat'] as num?)?.toDouble(),
    subTotal: (json['subTotal'] as num?)?.toDouble(),
    branchId: json['branchId'] as String?,
    businessIdString: json['businessIdString'] as String?,
    multiOrderImplementation: json['multiOrderImplementation'] as bool?,
    customerPaymentType: json['customerPaymentType'] as String?,
    balance: (json['balance'] as num?)?.toDouble(),
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
    id: json['_id'] as String?,
    remainingItems: json['remainingItems'] as List<dynamic>?,
    partialPayments: json['partialPayments'] as List<dynamic>?,
    reprintHistory: json['reprintHistory'] as List<dynamic>?,
    createdAt: json['createdAt'] as String?,
    updatedAt: json['updatedAt'] as String?,
    v: json['__v'] as int?,
  );
  double? transamount;
  String? transtime;
  String? businessId;
  String? cashier;
  String? customerName;
  String? pushTransactionId;
  String? status;
  String? userId;
  bool? duplicate;
  List<TransactionItem>? items;
  double? vat;
  double? subTotal;
  String? branchId;
  String? businessIdString;
  bool? multiOrderImplementation;
  String? customerPaymentType;
  double? balance;
  double? discountAmount;
  double? discountPercent;
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
  double? cardPresentCharge;
  String? isStudentSponsoredOrder;
  String? creditNoteStatus;
  bool? isZedCreditNote;
  bool? isKraInvoice;
  String? id;
  List<dynamic>? remainingItems;
  List<dynamic>? partialPayments;
  List<dynamic>? reprintHistory;
  String? createdAt;
  String? updatedAt;
  int? v;
}

class TransactionItem {

  TransactionItem({
    this.itemAmount,
    this.itemName,
    this.itemCategory,
    this.itemCount,
    this.totalAmount,
    this.productId,
    this.variationKeyId,
    this.variationKey,
    this.tags,
    this.discountPercent,
    this.discountType,
    this.discount,
    this.isPreOrder,
    this.taxTyCd,
    this.taxType,
    this.id,
    this.additionalItems,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) => TransactionItem(
    itemAmount: (json['itemAmount'] as num?)?.toDouble(),
    itemName: json['itemName'] as String?,
    itemCategory: json['itemCategory'] as String?,
    itemCount: json['itemCount'] as int?,
    totalAmount: (json['totalAmount'] as num?)?.toDouble(),
    productId: json['productId'] as String?,
    variationKeyId: json['variationKeyId'] as String?,
    variationKey: json['variationKey'] as String?,
    tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    discountPercent: (json['discountPercent'] as num?)?.toDouble(),
    discountType: json['discountType'] as String?,
    discount: (json['discount'] as num?)?.toDouble(),
    isPreOrder: json['isPreOrder'] as bool?,
    taxTyCd: json['taxTyCd'] as String?,
    taxType: json['taxType'] as String?,
    id: json['_id'] as String?,
    additionalItems: json['additionalItems'] as List<dynamic>?,
  );
  double? itemAmount;
  String? itemName;
  String? itemCategory;
  int? itemCount;
  double? totalAmount;
  String? productId;
  String? variationKeyId;
  String? variationKey;
  List<String>? tags;
  double? discountPercent;
  String? discountType;
  double? discount;
  bool? isPreOrder;
  String? taxTyCd;
  String? taxType;
  String? id;
  List<dynamic>? additionalItems;
}
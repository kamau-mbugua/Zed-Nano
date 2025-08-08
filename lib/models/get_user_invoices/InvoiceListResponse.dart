class CustomerInvoiceListResponse {

  CustomerInvoiceListResponse({
    this.status,
    this.message,
    this.data,
    this.count,
  });

  factory CustomerInvoiceListResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CustomerInvoiceListResponse();

    return CustomerInvoiceListResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CustomerInvoiceData.fromJson(e as Map<String, dynamic>?))
          .toList(),
      count: json['count'] as int?,
    );
  }
  final String? status;
  final String? message;
  final List<CustomerInvoiceData>? data;
  final int? count;

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data?.map((e) => e.toJson()).toList(),
    'count': count,
  };
}

class CustomerInvoiceData {

  CustomerInvoiceData({
    this.id,
    this.businessId,
    this.businessNumber,
    this.branchId,
    this.invoiceNumberSequence,
    this.invoiceNumber,
    this.customerId,
    this.createdBy,
    this.updatedBy,
    this.storeId,
    this.invoiceType,
    this.invoiceFrequency,
    this.invoiceStatus,
    this.batchStatus,
    this.invoiceBalance,
    this.invoiceAmount,
    this.invoiceOverPayment,
    this.sentTo,
    this.items,
    this.dueDate,
    this.isOriginal,
    this.retailerInvoice,
    this.distributorInvoice,
    this.invoiceForSupplier,
    this.zedPayItWallet,
    this.processStatus,
    this.discountName,
    this.discountType,
    this.discountAmount,
    this.discountPercent,
    this.checkInStatus,
    this.userId,
    this.terminalId,
    this.salesOrPurchaseInvoice,
    this.accountOwner,
    this.transferMoneyFromZed,
    this.settledByZed,
    this.invoiceClassification,
    this.regNo,
    this.partnerRegion,
    this.partnerBranch,
    this.tripId,
    this.seatNumbers,
    this.routeId,
    this.cardPresentCharge,
    this.isSponsorInvoice,
    this.isStudentSponsoredInvoice,
    this.sendToSponsor,
    this.isKraInvoice,
    this.creditNoteStatus,
    this.isZedCreditNote,
    this.purchaseOrderNumber,
    this.isBillingInvoice,
    this.isChangePlan,
    this.isWithdrawal,
    this.deletedItems,
    this.deletions,
    this.payments,
    this.sponsoredBillableItems,
    this.sponsoredBillableItemsInvoice,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.amountPaid,
    this.invoiceDiscountAmount,
    this.total,
  });

  factory CustomerInvoiceData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CustomerInvoiceData();

    return CustomerInvoiceData(
      id: json['_id'] as String?,
      businessId: json['businessId'] as String?,
      businessNumber: json['businessNumber'] as String?,
      branchId: json['branchId'] as String?,
      invoiceNumberSequence: json['invoiceNumberSequence'] as int?,
      invoiceNumber: json['invoiceNumber'] as String?,
      customerId: json['customerId'] as String?,
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
      storeId: json['storeId'] as String?,
      invoiceType: json['invoiceType'] as String?,
      invoiceFrequency: json['invoiceFrequency'] as String?,
      invoiceStatus: json['invoiceStatus'] as String?,
      batchStatus: json['batchStatus'] as String?,
      invoiceBalance: json['invoiceBalance'] as int?,
      invoiceAmount: json['invoiceAmount'] as int?,
      invoiceOverPayment: json['invoiceOverPayment'] as int?,
      sentTo: json['sentTo'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => InvoiceItem.fromJson(e as Map<String, dynamic>?))
          .toList(),
      dueDate: json['dueDate'] as String?,
      isOriginal: json['isOriginal'] as bool?,
      retailerInvoice: json['retailerInvoice'] as bool?,
      distributorInvoice: json['distributorInvoice'] as bool?,
      invoiceForSupplier: json['invoiceForSupplier'] as bool?,
      zedPayItWallet: json['zedPayItWallet'] as bool?,
      processStatus: json['processStatus'] as String?,
      discountName: json['discountName'] as String?,
      discountType: json['discountType'] as String?,
      discountAmount: json['discountAmount'] as int?,
      discountPercent: json['discountPercent'] as int?,
      checkInStatus: json['checkInStatus'] as bool?,
      userId: json['userId'] as String?,
      terminalId: json['terminalId'] as String?,
      salesOrPurchaseInvoice: json['salesOrPurchaseInvoice'] as String?,
      accountOwner: json['accountOwner'] as String?,
      transferMoneyFromZed: json['transferMoneyFromZed'] as bool?,
      settledByZed: json['settledByZed'] as bool?,
      invoiceClassification: json['invoiceClassification'] as String?,
      regNo: json['regNo'] as String?,
      partnerRegion: json['partnerRegion'] as String?,
      partnerBranch: json['partnerBranch'] as String?,
      tripId: json['tripId'] as String?,
      seatNumbers: json['seatNumbers'] as List<dynamic>?,
      routeId: json['routeId'] as String?,
      cardPresentCharge: json['cardPresentCharge'] as int?,
      isSponsorInvoice: json['isSponsorInvoice'] as String?,
      isStudentSponsoredInvoice: json['isStudentSponsoredInvoice'] as String?,
      sendToSponsor: json['sendToSponsor'] as String?,
      isKraInvoice: json['isKraInvoice'] as bool?,
      creditNoteStatus: json['creditNoteStatus'] as String?,
      isZedCreditNote: json['isZedCreditNote'] as bool?,
      purchaseOrderNumber: json['purchaseOrderNumber'] as String?,
      isBillingInvoice: json['isBillingInvoice'] as bool?,
      isChangePlan: json['isChangePlan'] as bool?,
      isWithdrawal: json['isWithdrawal'] as bool?,
      deletedItems: json['deletedItems'] as List<dynamic>?,
      deletions: json['deletions'] as List<dynamic>?,
      payments: json['payments'] as List<dynamic>?,
      sponsoredBillableItems: json['sponsoredBillableItems'] as List<dynamic>?,
      sponsoredBillableItemsInvoice: json['sponsoredBillableItemsInvoice'] as List<dynamic>?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
      amountPaid: json['amountPaid'] as int?,
      invoiceDiscountAmount: json['invoiceDiscountAmount'] as int?,
      total: json['total'] as int?,
    );
  }
  final String? id;
  final String? businessId;
  final String? businessNumber;
  final String? branchId;
  final int? invoiceNumberSequence;
  final String? invoiceNumber;
  final String? customerId;
  final String? createdBy;
  final String? updatedBy;
  final String? storeId;
  final String? invoiceType;
  final String? invoiceFrequency;
  final String? invoiceStatus;
  final String? batchStatus;
  final int? invoiceBalance;
  final int? invoiceAmount;
  final int? invoiceOverPayment;
  final String? sentTo;
  final List<InvoiceItem>? items;
  final String? dueDate;
  final bool? isOriginal;
  final bool? retailerInvoice;
  final bool? distributorInvoice;
  final bool? invoiceForSupplier;
  final bool? zedPayItWallet;
  final String? processStatus;
  final String? discountName;
  final String? discountType;
  final int? discountAmount;
  final int? discountPercent;
  final bool? checkInStatus;
  final String? userId;
  final String? terminalId;
  final String? salesOrPurchaseInvoice;
  final String? accountOwner;
  final bool? transferMoneyFromZed;
  final bool? settledByZed;
  final String? invoiceClassification;
  final String? regNo;
  final String? partnerRegion;
  final String? partnerBranch;
  final String? tripId;
  final List<dynamic>? seatNumbers;
  final String? routeId;
  final int? cardPresentCharge;
  final String? isSponsorInvoice;
  final String? isStudentSponsoredInvoice;
  final String? sendToSponsor;
  final bool? isKraInvoice;
  final String? creditNoteStatus;
  final bool? isZedCreditNote;
  final String? purchaseOrderNumber;
  final bool? isBillingInvoice;
  final bool? isChangePlan;
  final bool? isWithdrawal;
  final List<dynamic>? deletedItems;
  final List<dynamic>? deletions;
  final List<dynamic>? payments;
  final List<dynamic>? sponsoredBillableItems;
  final List<dynamic>? sponsoredBillableItemsInvoice;
  final String? createdAt;
  final String? updatedAt;
  final int? v;
  final int? amountPaid;
  final int? invoiceDiscountAmount;
  final int? total;

  Map<String, dynamic> toJson() => {
    '_id': id,
    'businessId': businessId,
    'businessNumber': businessNumber,
    // ... [Continue with all other fields]
  };
}

class InvoiceItem {

  InvoiceItem({
    this.productId,
    this.productName,
    this.productPrice,
    this.productCode,
    this.quantity,
    this.variationId,
    this.pricingId,
    this.variationKey,
    this.discountPercent,
    this.discount,
    this.priceStatus,
    this.taxType,
    this.taxTyCd,
    this.id,
    this.deletedDiscount,
    this.createdAt,
    this.updatedAt,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) return InvoiceItem();

    return InvoiceItem(
      productId: json['productId'] as String?,
      productName: json['productName'] as String?,
      productPrice: json['productPrice'] as int?,
      productCode: json['productCode'] as String?,
      quantity: json['quantity'] as int?,
      variationId: json['variationId'] as String?,
      pricingId: json['pricingId'] as String?,
      variationKey: json['variationKey'] as String?,
      discountPercent: json['discountPercent'] as int?,
      discount: json['discount'] as int?,
      priceStatus: json['priceStatus'] as String?,
      taxType: json['taxType'] as String?,
      taxTyCd: json['taxTyCd'] as String?,
      id: json['_id'] as String?,
      deletedDiscount: json['deletedDiscount'] as List<dynamic>?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }
  final String? productId;
  final String? productName;
  final int? productPrice;
  final String? productCode;
  final int? quantity;
  final String? variationId;
  final String? pricingId;
  final String? variationKey;
  final int? discountPercent;
  final int? discount;
  final String? priceStatus;
  final String? taxType;
  final String? taxTyCd;
  final String? id;
  final List<dynamic>? deletedDiscount;
  final String? createdAt;
  final String? updatedAt;

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'productName': productName,
    'productPrice': productPrice,
    'productCode': productCode,
    'quantity': quantity,
    'variationId': variationId,
    'pricingId': pricingId,
    'variationKey': variationKey,
    'discountPercent': discountPercent,
    'discount': discount,
    'priceStatus': priceStatus,
    'taxType': taxType,
    'taxTyCd': taxTyCd,
    '_id': id,
    'deletedDiscount': deletedDiscount,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
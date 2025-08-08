class GetBusinessInvoicesByStatusResponse {

  GetBusinessInvoicesByStatusResponse({
    this.status,
    this.message,
    this.data,
    this.count,
    this.invoiceSummary,
  });

  factory GetBusinessInvoicesByStatusResponse.fromJson(Map<String, dynamic> json) {
    return GetBusinessInvoicesByStatusResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BusinessInvoice.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: (json['count'] as num?)?.toInt(),
      invoiceSummary: json['invoiceSummary'] != null
          ? InvoiceSummary.fromJson(json['invoiceSummary'] as Map<String, dynamic>)
          : null,
    );
  }
  final String? status;
  final String? message;
  final List<BusinessInvoice>? data;
  final int? count;
  InvoiceSummary? invoiceSummary;

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
      'count': count,
    };
  }
}

class InvoiceSummary {

  InvoiceSummary({
    this.orderTotal,
    this.orderCount,
    this.currency,
  });

  factory InvoiceSummary.fromJson(Map<String, dynamic> json) {
    return InvoiceSummary(
      orderTotal: (json['orderTotal'] as num?)?.toDouble(),
      orderCount: (json['orderCount'] as num?)?.toInt(),
      currency: json['currency'] as String?,
    );
  }
  double? orderTotal;
  int? orderCount;
  String? currency;
}

class BusinessInvoice {

  BusinessInvoice({
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
    this.paymentId,
    this.sendToFirstName,
    this.invoiceDiscountAmount,
    this.paidAmount,
    this.currency,
  });

  factory BusinessInvoice.fromJson(Map<String, dynamic> json) {
    return BusinessInvoice(
      id: json['_id'] as String?,
      businessId: json['businessId'] as String?,
      businessNumber: json['businessNumber'] as String?,
      branchId: json['branchId'] as String?,
      invoiceNumberSequence: (json['invoiceNumberSequence'] as num?)?.toInt(),
      invoiceNumber: json['invoiceNumber'] as String?,
      customerId: json['customerId'] as String?,
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
      storeId: json['storeId'] as String?,
      invoiceType: json['invoiceType'] as String?,
      invoiceFrequency: json['invoiceFrequency'] as String?,
      invoiceStatus: json['invoiceStatus'] as String?,
      batchStatus: json['batchStatus'] as String?,
      invoiceBalance: (json['invoiceBalance'] as num?)?.toDouble(),
      invoiceAmount: (json['invoiceAmount'] as num?)?.toDouble(),
      invoiceOverPayment: (json['invoiceOverPayment'] as num?)?.toDouble(),
      sentTo: json['sentTo'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => InvoiceItem.fromJson(e as Map<String, dynamic>))
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
      discountAmount: (json['discountAmount'] as num?)?.toDouble(),
      discountPercent: (json['discountPercent'] as num?)?.toDouble(),
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
      seatNumbers: (json['seatNumbers'] as List<dynamic>?)?.cast<String>(),
      routeId: json['routeId'] as String?,
      cardPresentCharge: (json['cardPresentCharge'] as num?)?.toDouble(),
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
      v: (json['__v'] as num?)?.toInt(),
      paymentId: json['paymentId'] as String?,
      sendToFirstName: json['sendToFirstName'] as String?,
      invoiceDiscountAmount: (json['invoiceDiscountAmount'] as num?)?.toDouble(),
      paidAmount: (json['paidAmount'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
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
  final double? invoiceBalance;
  final double? invoiceAmount;
  final double? invoiceOverPayment;
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
  final double? discountAmount;
  final double? discountPercent;
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
  final List<String>? seatNumbers;
  final String? routeId;
  final double? cardPresentCharge;
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
  final String? paymentId;
  final String? sendToFirstName;
  final double? invoiceDiscountAmount;
  final double? paidAmount;
  final String? currency;

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'businessId': businessId,
      'businessNumber': businessNumber,
      'branchId': branchId,
      'invoiceNumberSequence': invoiceNumberSequence,
      'invoiceNumber': invoiceNumber,
      'customerId': customerId,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'storeId': storeId,
      'invoiceType': invoiceType,
      'invoiceFrequency': invoiceFrequency,
      'invoiceStatus': invoiceStatus,
      'batchStatus': batchStatus,
      'invoiceBalance': invoiceBalance,
      'invoiceAmount': invoiceAmount,
      'invoiceOverPayment': invoiceOverPayment,
      'sentTo': sentTo,
      'items': items?.map((e) => e.toJson()).toList(),
      'dueDate': dueDate,
      'isOriginal': isOriginal,
      'retailerInvoice': retailerInvoice,
      'distributorInvoice': distributorInvoice,
      'invoiceForSupplier': invoiceForSupplier,
      'zedPayItWallet': zedPayItWallet,
      'processStatus': processStatus,
      'discountName': discountName,
      'discountType': discountType,
      'discountAmount': discountAmount,
      'discountPercent': discountPercent,
      'checkInStatus': checkInStatus,
      'userId': userId,
      'terminalId': terminalId,
      'salesOrPurchaseInvoice': salesOrPurchaseInvoice,
      'accountOwner': accountOwner,
      'transferMoneyFromZed': transferMoneyFromZed,
      'settledByZed': settledByZed,
      'invoiceClassification': invoiceClassification,
      'regNo': regNo,
      'partnerRegion': partnerRegion,
      'partnerBranch': partnerBranch,
      'tripId': tripId,
      'seatNumbers': seatNumbers,
      'routeId': routeId,
      'cardPresentCharge': cardPresentCharge,
      'isSponsorInvoice': isSponsorInvoice,
      'isStudentSponsoredInvoice': isStudentSponsoredInvoice,
      'sendToSponsor': sendToSponsor,
      'isKraInvoice': isKraInvoice,
      'creditNoteStatus': creditNoteStatus,
      'isZedCreditNote': isZedCreditNote,
      'purchaseOrderNumber': purchaseOrderNumber,
      'isBillingInvoice': isBillingInvoice,
      'isChangePlan': isChangePlan,
      'isWithdrawal': isWithdrawal,
      'deletedItems': deletedItems,
      'deletions': deletions,
      'payments': payments,
      'sponsoredBillableItems': sponsoredBillableItems,
      'sponsoredBillableItemsInvoice': sponsoredBillableItemsInvoice,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'paymentId': paymentId,
      'sendToFirstName': sendToFirstName,
      'invoiceDiscountAmount': invoiceDiscountAmount,
      'paidAmount': paidAmount,
      'currency': currency,
    };
  }
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

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      productId: json['productId'] as String?,
      productName: json['productName'] as String?,
      productPrice: (json['productPrice'] as num?)?.toDouble(),
      productCode: json['productCode'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      variationId: json['variationId'] as String?,
      pricingId: json['pricingId'] as String?,
      variationKey: json['variationKey'] as String?,
      discountPercent: (json['discountPercent'] as num?)?.toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
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
  final double? productPrice;
  final String? productCode;
  final int? quantity;
  final String? variationId;
  final String? pricingId;
  final String? variationKey;
  final double? discountPercent;
  final double? discount;
  final String? priceStatus;
  final String? taxType;
  final String? taxTyCd;
  final String? id;
  final List<dynamic>? deletedDiscount;
  final String? createdAt;
  final String? updatedAt;

  Map<String, dynamic> toJson() {
    return {
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
}

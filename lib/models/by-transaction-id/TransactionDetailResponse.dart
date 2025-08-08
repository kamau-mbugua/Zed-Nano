class ByTransactionIdDetailResponse {

  ByTransactionIdDetailResponse({
    this.status,
    this.message,
    this.data,
    this.currency,
  });

  factory ByTransactionIdDetailResponse.fromJson(Map<String, dynamic> json) {
    return ByTransactionIdDetailResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] != null 
          ? ByTransactionIdDetailData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      currency: json['currency'] as String?,
    );
  }
  final String? status;
  final String? message;
  final ByTransactionIdDetailData? data;
  final String? currency;
}

class ByTransactionIdDetailData {

  ByTransactionIdDetailData({
    this.id,
    this.businessNo,
    this.businessName,
    this.serialNo,
    this.transactionType,
    this.transactionID,
    this.transtime,
    this.transamount,
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
    this.pushyTransactionId,
    this.userId,
    this.receiptNumber,
    this.items,
    this.settled,
    this.multiOrder,
    this.branchId,
    this.customerId,
    this.discountAmount,
    this.discountPercent,
    this.invoiceId,
    this.billableItemId,
    this.status,
    this.documentType,
    this.invoicesIds,
    this.refundAmount,
    this.transferredToSchool,
    this.regNo,
    this.approvedTransaction,
    this.seatNumbers,
    this.duplicatePrint,
    this.terminalSerialNumber,
    this.tellerId,
    this.isPreOrder,
    this.cardNumber,
    this.cardPresentSettlementStatus,
    this.cardPresentCharge,
    this.isSponsorpayment,
    this.isBillingPayment,
    this.transactionCreated,
    this.orders,
    this.paidOrders,
    this.invoices,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.voidRequestedBy,
    this.voidedBy,
    this.voidDeclinedBy,
    this.orderNo,
    this.type,
    this.subTotal,
    this.vat,
    this.voidStatus,
  });

  factory ByTransactionIdDetailData.fromJson(Map<String, dynamic> json) {
    return ByTransactionIdDetailData(
      id: json['_id'] as String?,
      businessNo: json['businessNo'] as String?,
      businessName: json['businessName'] as String?,
      serialNo: json['serialNo'] as String?,
      transactionType: json['transactionType'] as String?,
      transactionID: json['transactionID'] as String?,
      transtime: json['transtime'] as String?,
      transamount: (json['transamount'] as num?)?.toDouble(),
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
      pushyTransactionId: json['pushyTransactionId'] as List<dynamic>?,
      userId: json['userId'] as String?,
      receiptNumber: json['receiptNumber'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => TransactionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      settled: json['settled'] as bool?,
      multiOrder: json['multiOrder'] as bool?,
      branchId: json['branchId'] as String?,
      customerId: json['customerId'] as String?,
      discountAmount: (json['discountAmount'] as num?)?.toDouble(),
      discountPercent: (json['discountPercent'] as num?)?.toDouble(),
      invoiceId: json['invoiceId'] as String?,
      billableItemId: json['billableItemId'] as String?,
      status: json['status'] as String?,
      documentType: json['documentType'] as String?,
      invoicesIds: json['invoicesIds'] as List<dynamic>?,
      refundAmount: (json['refundAmount'] as num?)?.toDouble(),
      transferredToSchool: json['transferredToSchool'] as bool?,
      regNo: json['regNo'] as String?,
      approvedTransaction: json['approvedTransaction'] as bool?,
      seatNumbers: json['seatNumbers'] as List<dynamic>?,
      duplicatePrint: json['duplicatePrint'] as bool?,
      terminalSerialNumber: json['terminalSerialNumber'] as String?,
      tellerId: json['tellerId'] as String?,
      isPreOrder: json['isPreOrder'] as bool?,
      cardNumber: json['cardNumber'] as String?,
      cardPresentSettlementStatus: json['cardPresentSettlementStatus'] as String?,
      cardPresentCharge: (json['cardPresentCharge'] as num?)?.toDouble(),
      isSponsorpayment: json['isSponsorpayment'] as String?,
      isBillingPayment: json['isBillingPayment'] as bool?,
      transactionCreated: json['transactionCreated'] as String?,
      orders: json['orders'] as List<dynamic>?,
      paidOrders: json['paidOrders'] as List<dynamic>?,
      invoices: (json['invoices'] as List<dynamic>?)
          ?.map((e) => TransactionInvoice.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: (json['__v'] as num?)?.toDouble(),
      voidRequestedBy: json['voidRequestedBy'] as String?,
      voidedBy: json['voidedBy'] as String?,
      voidDeclinedBy: json['voidDeclinedBy'] as String?,
      orderNo: json['orderNo'] as String?,
      type: json['type'] as String?,
      voidStatus: json['voidStatus'] as String?,
      subTotal: (json['subTotal'] as num?)?.toDouble(),
      vat: (json['vat'] as num?)?.toDouble(),
    );
  }
  final String? id;
  final String? businessNo;
  final String? businessName;
  final String? serialNo;
  final String? transactionType;
  final String? transactionID;
  final String? transtime;
  final double? transamount;
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
  final List<dynamic>? pushyTransactionId;
  final String? userId;
  final String? receiptNumber;
  final List<TransactionItem>? items;
  final bool? settled;
  final bool? multiOrder;
  final String? branchId;
  final String? customerId;
  final double? discountAmount;
  final double? discountPercent;
  final String? invoiceId;
  final String? billableItemId;
  final String? status;
  final String? documentType;
  final List<dynamic>? invoicesIds;
  final double? refundAmount;
  final bool? transferredToSchool;
  final String? regNo;
  final bool? approvedTransaction;
  final List<dynamic>? seatNumbers;
  final bool? duplicatePrint;
  final String? terminalSerialNumber;
  final String? tellerId;
  final bool? isPreOrder;
  final String? cardNumber;
  final String? cardPresentSettlementStatus;
  final double? cardPresentCharge;
  final String? isSponsorpayment;
  final bool? isBillingPayment;
  final String? transactionCreated;
  final List<dynamic>? orders;
  final List<dynamic>? paidOrders;
  final List<TransactionInvoice>? invoices;
  final String? createdAt;
  final String? updatedAt;
  final double? v;
  final String? voidRequestedBy;
  final String? voidedBy;
  final String? voidDeclinedBy;
  final String? orderNo;
  final String? type;
  final String? voidStatus;
  final double? subTotal;
  final double? vat;
}

class TransactionItem {

  TransactionItem({
    this.itemAmount,
    this.itemCategory,
    this.itemCount,
    this.itemName,
    this.reciptNumber,
    this.totalAmount,
    this.productId,
    this.imagePath,
    this.currency,
    this.discount,
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
      imagePath: json['imagePath'] as String?,
      currency: json['currency'] as String?,
      discount: (json['discount'] as num?)?.toDouble(),

    );
  }
  final double? itemAmount;
  final String? itemCategory;
  final double? itemCount;
  final String? itemName;
  final String? reciptNumber;
  final double? totalAmount;
  final String? productId;
  final String? imagePath;
  final String? currency;
  final double? discount;
}

class TransactionInvoice {

  TransactionInvoice({
    this.isCustomPlan,
    this.customPlanId,
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
    this.requestReferenceId,
    this.paymentId,
  });

  factory TransactionInvoice.fromJson(Map<String, dynamic> json) {
    return TransactionInvoice(
      isCustomPlan: json['isCustomPlan'] as bool?,
      customPlanId: json['customPlanId'] as String?,
      id: json['_id'] as String?,
      businessId: json['businessId'] as String?,
      businessNumber: json['businessNumber'] as String?,
      branchId: json['branchId'] as String?,
      invoiceNumberSequence: (json['invoiceNumberSequence'] as num?)?.toDouble(),
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
      seatNumbers: json['seatNumbers'] as List<dynamic>?,
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
      payments: (json['payments'] as List<dynamic>?)
          ?.map((e) => InvoicePayment.fromJson(e as Map<String, dynamic>))
          .toList(),
      sponsoredBillableItems: json['sponsoredBillableItems'] as List<dynamic>?,
      sponsoredBillableItemsInvoice: json['sponsoredBillableItemsInvoice'] as List<dynamic>?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: (json['__v'] as num?)?.toDouble(),
      requestReferenceId: json['requestReferenceId'] as String?,
      paymentId: json['paymentId'] as String?,
    );
  }
  final bool? isCustomPlan;
  final String? customPlanId;
  final String? id;
  final String? businessId;
  final String? businessNumber;
  final String? branchId;
  final double? invoiceNumberSequence;
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
  final List<dynamic>? seatNumbers;
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
  final List<InvoicePayment>? payments;
  final List<dynamic>? sponsoredBillableItems;
  final List<dynamic>? sponsoredBillableItemsInvoice;
  final String? createdAt;
  final String? updatedAt;
  final double? v;
  final String? requestReferenceId;
  final String? paymentId;
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
    this.discountType,
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
      quantity: (json['quantity'] as num?)?.toDouble(),
      variationId: json['variationId'] as String?,
      pricingId: json['pricingId'] as String?,
      variationKey: json['variationKey'] as String?,
      discountType: json['discountType'] as String?,
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
  final double? quantity;
  final String? variationId;
  final String? pricingId;
  final String? variationKey;
  final String? discountType;
  final double? discountPercent;
  final double? discount;
  final String? priceStatus;
  final String? taxType;
  final String? taxTyCd;
  final String? id;
  final List<dynamic>? deletedDiscount;
  final String? createdAt;
  final String? updatedAt;
}

class InvoicePayment {

  InvoicePayment({
    this.paymentMethod,
    this.paymentAmount,
    this.paymentDate,
    this.paymentChannel,
    this.balance,
    this.cardNumber,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  factory InvoicePayment.fromJson(Map<String, dynamic> json) {
    return InvoicePayment(
      paymentMethod: json['paymentMethod'] as String?,
      paymentAmount: (json['paymentAmount'] as num?)?.toDouble(),
      paymentDate: json['paymentDate'] as String?,
      paymentChannel: json['paymentChannel'] as String?,
      balance: json['balance'] as String?,
      cardNumber: json['cardNumber'] as String?,
      id: json['_id'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }
  final String? paymentMethod;
  final double? paymentAmount;
  final String? paymentDate;
  final String? paymentChannel;
  final String? balance;
  final String? cardNumber;
  final String? id;
  final String? createdAt;
  final String? updatedAt;
}

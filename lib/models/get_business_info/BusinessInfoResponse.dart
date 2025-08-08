class BusinessInfoResponse {

  BusinessInfoResponse({
    this.status,
    this.message,
    this.data,
  });

  factory BusinessInfoResponse.fromJson(Map<String, dynamic> json) {
    return BusinessInfoResponse(
      status: json['Status'] as String?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? BusinessInfoData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
  final String? status;
  final String? message;
  final BusinessInfoData? data;

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class BusinessBillingDetails {

  BusinessBillingDetails({
    this.planId,
    this.customPlanId,
    this.subscriptionPlanName,
    this.subscriptionType,
    this.billingStatus,
    this.billingDueDate,
    this.billingRemainingDays,
    this.billingPeriodName,
    this.billableFeatures,
    this.billingType,
    this.nanoSubscription,
  });

  factory BusinessBillingDetails.fromJson(Map<String, dynamic> json) {
    return BusinessBillingDetails(
      planId: json['planId'] as String?,
      customPlanId: json['customPlanId'] as String?,
      subscriptionPlanName: json['subscriptionPlanName'] as String?,
      subscriptionType: json['subscriptionType'] as String?,
      billingStatus: json['billingStatus'] as String?,
      billingDueDate: json['billingDueDate'] as String?,
      billingRemainingDays: json['billingRemainingDays'] as int?,
      billingPeriodName: json['billingPeriodName'] as String?,
      billableFeatures: json['billableFeatures'] as List<dynamic>?,
      billingType: json['billingType'] as String?,
      nanoSubscription: json['nanoSubscription'] != null
          ? NanoBusinessSubscription.fromJson(json['nanoSubscription'] as Map<String, dynamic>)
          : null,
    );
  }
  final String? planId;
  final String? customPlanId;
  final String? subscriptionPlanName;
  final String? subscriptionType;
  final String? billingStatus;
  final String? billingDueDate;
  final int? billingRemainingDays;
  final String? billingPeriodName;
  final List<dynamic>? billableFeatures;
  final String? billingType;
  final NanoBusinessSubscription? nanoSubscription;

  Map<String, dynamic> toJson() {
    return {
      'planId': planId,
      'customPlanId': customPlanId,
      'subscriptionPlanName': subscriptionPlanName,
      'subscriptionType': subscriptionType,
      'billingStatus': billingStatus,
      'billingDueDate': billingDueDate,
      'billingRemainingDays': billingRemainingDays,
      'billingPeriodName': billingPeriodName,
      'billableFeatures': billableFeatures,
      'billingType': billingType,
      'nanoSubscription': nanoSubscription?.toJson(),
    };
  }
}

class NanoBusinessSubscription {

  NanoBusinessSubscription({
    this.data,
    this.freeTrialStatus,
    this.freeTrialPlanName,
    this.freeTrialEndTime,
    this.isFreeTrialTried,
    this.isFreeTrialEnded,
    this.isActiveBillingPackage,
    this.freeTrialPeriodRemainingdays,
  });

  factory NanoBusinessSubscription.fromJson(Map<String, dynamic> json) {
    return NanoBusinessSubscription(
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => NanoSubscriptionData.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
      freeTrialStatus: json['freeTrialStatus'] as String?,
      freeTrialPlanName: json['freeTrialPlanName'] as String?,
      freeTrialEndTime: json['freeTrialEndTime'] as String?,
      isFreeTrialTried: json['isFreeTrialTried'] as bool?,
      isFreeTrialEnded: json['isFreeTrialEnded'] as bool?,
      isActiveBillingPackage: json['isActiveBillingPackage'] as bool?,
      freeTrialPeriodRemainingdays: json['freeTrialPeriodRemainingdays'] as int?,
    );
  }
  final List<NanoSubscriptionData>? data;
  final String? freeTrialStatus;
  final String? freeTrialPlanName;
  final String? freeTrialEndTime;
  final bool? isFreeTrialTried;
  final bool? isFreeTrialEnded;
  final bool? isActiveBillingPackage;
  final int? freeTrialPeriodRemainingdays;

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((item) => item.toJson()).toList(),
      'freeTrialStatus': freeTrialStatus,
      'freeTrialPlanName': freeTrialPlanName,
      'freeTrialEndTime': freeTrialEndTime,
      'isFreeTrialTried': isFreeTrialTried,
      'isFreeTrialEnded': isFreeTrialEnded,
      'isActiveBillingPackage': isActiveBillingPackage,
      'freeTrialPeriodRemainingdays': freeTrialPeriodRemainingdays,
    };
  }
}

class NanoSubscriptionData {

  NanoSubscriptionData({
    this.planId,
    this.planName,
    this.planStatus,
    this.dateSubscribed,
    this.startDate,
    this.dueDate,
    this.billingPeriodName,
    this.totalBillingPlanAmount,
    this.planSetUpFee,
    this.isSetUpFeePaid,
    this.billingPeriodAmount,
  });

  factory NanoSubscriptionData.fromJson(Map<String, dynamic> json) {
    return NanoSubscriptionData(
      planId: json['planId'] as String?,
      planName: json['planName'] as String?,
      planStatus: json['planStatus'] as String?,
      dateSubscribed: json['dateSubscribed'] as String?,
      startDate: json['startDate'] as String?,
      dueDate: json['dueDate'] as String?,
      billingPeriodName: json['billingPeriodName'] as String?,
      totalBillingPlanAmount: _parseDouble(json['totalBillingPlanAmount']),
      planSetUpFee: _parseDouble(json['planSetUpFee']),
      isSetUpFeePaid: json['isSetUpFeePaid'] as bool?,
      billingPeriodAmount: _parseDouble(json['billingPeriodAmount']),
    );
  }
  final String? planId;
  final String? planName;
  final String? planStatus;
  final String? dateSubscribed;
  final String? startDate;
  final String? dueDate;
  final String? billingPeriodName;
  final double? totalBillingPlanAmount;
  final double? planSetUpFee;
  final bool? isSetUpFeePaid;
  final double? billingPeriodAmount;

  Map<String, dynamic> toJson() {
    return {
      'planId': planId,
      'planName': planName,
      'planStatus': planStatus,
      'dateSubscribed': dateSubscribed,
      'startDate': startDate,
      'dueDate': dueDate,
      'billingPeriodName': billingPeriodName,
      'totalBillingPlanAmount': totalBillingPlanAmount,
      'planSetUpFee': planSetUpFee,
      'isSetUpFeePaid': isSetUpFeePaid,
      'billingPeriodAmount': billingPeriodAmount,
    };
  }

  /// Helper method to safely parse double values
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }
}

class BusinessInfoData {

  BusinessInfoData({
    this.isNanoBusiness,
    this.id,
    this.businessNumber,
    this.businessName,
    this.businessOwnerName,
    this.businessOwnerUserName,
    this.businessOwnerEmail,
    this.businessOwnerAddress,
    this.businessOwnerGroup,
    this.businessOwnerPassword,
    this.businessCategory,
    this.businessCategoryType,
    this.passwordStatus,
    this.passwordExpiry,
    this.businessOwnerPhone,
    this.resetRequestTime,
    this.businessState,
    this.createdAt,
    this.createdBy,
    this.modifiedAt,
    this.schooltypeId,
    this.till,
    this.paybill,
    this.vooma,
    this.equitel,
    this.deviceCreatedOn,
    this.bulkTerminals,
    this.newImplementation,
    this.userId,
    this.businessLogo,
    this.localCurrency,
    this.country,
    this.branches,
    this.warehouseOn,
    this.mainStoreOn,
    this.secondaryStoreOn,
    this.viewSellingPrice,
    this.workflowState,
    this.businessType,
    this.paypalStatus,
    this.timezone,
    this.xeroAccountingEnabled,
    this.quickbooksAccountingEnabled,
    this.zohoAccountingEnabled,
    this.isOnlineBookingEnabled,
    this.sageAccountingEnabled,
    this.bookingConfig,
    this.hasDefaultSchoolDashbaord,
    this.hasConvenienceFee,
    this.accountNo,
    this.payablesStatus,
    this.transactionMode,
    this.isStudentPurchaseEnabled,
    this.isExpressOrderEnabled,
    this.numberOfFingerPrints,
    this.enableCashConfig,
    this.enrollFingerPrintQuality,
    this.verifyFingerPrintQuality,
    this.viewSummaryBeforePrinting,
    this.enableStartOrder,
    this.enablePOSStartOrder,
    this.enablePosCaptainsOrderOrder,
    this.zpmStartOrderBySelectingCategory,
    this.ledgerAccountsAdded,
    this.xeroLedgerAccountsAdded,
    this.qbLedgerAccountsAdded,
    this.autogenerateStudentNumber,
    this.ecitizenActivationStatus,
    this.proformaInvoiceStatus,
    this.shopifyStatus,
    this.recipeEnabled,
    this.additionalServicesEnabled,
    this.isDomainUrlSet,
    this.zedPayStatus,
    this.isSettleInvoiceEnabled,
    this.isEvoucherEnabled,
    this.isPumpManagementEnabled,
    this.airtelMoneyStatus,
    this.cardMerchantTypeGeneral,
    this.cardMerchantTypePocketMoney,
    this.reprintStatus,
    this.ecommerceVoucherEnabled,
    this.etimsStatus,
    this.freeTrialStatus,
    this.isFreeTrialTried,
    this.isFreeTrialEnded,
    this.isActiveBillingPackage,
    this.businessStatusBilling,
    this.stockTransferStatus,
    this.tockMoveTermsUpdateVersion,
    this.stockMoveTermsUpdatedComment,
    this.isKcbAgentEnabled,
    this.enforcedCollectionEnabled,
    this.isStudentWithdrawFundsEnabled,
    this.isQrCodeEnabled,
    this.canZedTransferToOutlet,
    this.schoolStreams,
    this.schoolCourses,
    this.courseUnits,
    this.kcbDarajaConfigIds,
    this.bookAppointment,
    this.timeOff,
    this.suppliers,
    this.payees,
    this.departments,
    this.unitMovement,
    this.noticeOfEviction,
    this.bookingTime,
    this.paymentModes,
    this.cardMerchant,
    this.mobileMoney,
    this.approveLevelsConfig,
    this.fundsTransferAmountRangeConfig,
    this.businessFundsTransferConfig,
    this.businessAccounts,
    this.xeroAccounts,
    this.quickbooksAccounts,
    this.partners,
    this.bankStatementAccounts,
    this.pocketMoneyAccounts,
    this.prefixPerGrade,
    this.listBusinessChanges,
    this.schoolSessions,
    this.proformaTimelines,
    this.routes,
    this.productsVariations,
    this.productTags,
    this.additionalServices,
    this.pickUpLocations,
    this.shippingRegions,
    this.joinBusinessRequests,
    this.zedPayConfig,
    this.accessBankConfigs,
    this.pumps,
    this.cardPresentAccounts,
    this.cardPresentTerminalConfig,
    this.merchantFeeConfig,
    this.onlineBookingEvoucher,
    this.merchantAccountConfig,
    this.merchantSettlement,
    this.zpmReconcileConfigs,
    this.creditAccountsSupplier,
    this.remindersConfig,
    this.discounts,
    this.subscribedBillingPlans,
    this.businessDocuments,
    this.outletAccounts,
    this.updatedAt,
    this.v,
    this.cashEnabledBy,
    this.cashStatus,
    this.dateCashEnabled,
    this.updatedBy,
    this.updatedComment,
    this.sessionToken,
    this.businessUsers,
    this.proformStatus,
    this.myRole,
    this.totalSales,
    this.isPayItYEnabled,
    this.is2factorEnabled,
    this.firstName,
    this.secondName,
    this.userName,
    this.accountingEnabled,
    this.ipsasEnabled,
    this.isTermlyFeePaid,
    this.termlyAmount,
    this.enableStudentSponsor,
    this.unReadNotificationsCount,
    this.isOpeningClosingStockEnabled,
    this.isStockOrderEnabled,
    this.sessionTimeout,
    this.businessBillingDetails,
  });

  factory BusinessInfoData.fromJson(Map<String, dynamic> json) {
    return BusinessInfoData(
      isNanoBusiness: json['isNanoBusiness'] as bool?,
      id: json['_id'] as String?,
      businessNumber: json['businessNumber'] as String?,
      businessName: json['businessName'] as String?,
      businessOwnerName: json['businessOwnerName'] as String?,
      businessOwnerUserName: json['businessOwnerUserName'] as String?,
      businessOwnerEmail: json['businessOwnerEmail'] as String?,
      businessOwnerAddress: json['businessOwnerAddress'] as String?,
      businessOwnerGroup: json['businessOwnerGroup'] as String?,
      businessOwnerPassword: json['businessOwnerPassword'] as String?,
      businessCategory: json['businessCategory'] as String?,
      businessCategoryType: json['businessCategoryType'] as String?,
      passwordStatus: json['passwordStatus'] as String?,
      passwordExpiry: json['passwordExpiry'] as String?,
      businessOwnerPhone: json['businessOwnerPhone'] as String?,
      resetRequestTime: json['resetRequestTime'] as String?,
      businessState: json['businessState'] as String?,
      createdAt: json['createdAt'] as String?,
      createdBy: json['createdBy'] as String?,
      modifiedAt: json['modifiedAt'] as String?,
      schooltypeId: json['schooltypeId'] as String?,
      till: json['Till'] as String?,
      paybill: json['Paybill'] as String?,
      vooma: json['Vooma'] as String?,
      equitel: json['Equitel'] as String?,
      deviceCreatedOn: json['deviceCreatedOn'] as String?,
      bulkTerminals: json['bulkTerminals'] as String?,
      newImplementation: json['newImplementation'] as bool?,
      userId: json['userId'] as String?,
      businessLogo: json['businessLogo'] as String?,
      localCurrency: json['localCurrency'] as String?,
      country: json['country'] as String?,
      branches: json['branches'] as String?,
      warehouseOn: json['warehouseOn'] as bool?,
      mainStoreOn: json['mainStoreOn'] as bool?,
      secondaryStoreOn: json['secondaryStoreOn'] as bool?,
      viewSellingPrice: json['viewSellingPrice'] as bool?,
      workflowState: json['workflowState'] as String?,
      businessType: json['businessType'] as String?,
      paypalStatus: json['paypalStatus'] as bool?,
      timezone: json['timezone'] as String?,
      xeroAccountingEnabled: json['xeroAccountingEnabled'] as String?,
      quickbooksAccountingEnabled: json['quickbooksAccountingEnabled'] as String?,
      zohoAccountingEnabled: json['zohoAccountingEnabled'] as String?,
      isOnlineBookingEnabled: json['isOnlineBookingEnabled'] as bool?,
      sageAccountingEnabled: json['sageAccountingEnabled'] as String?,
      bookingConfig: json['bookingConfig'] as bool?,
      hasDefaultSchoolDashbaord: json['hasDefaultSchoolDashbaord'] as bool?,
      hasConvenienceFee: json['hasConvenienceFee'] as bool?,
      accountNo: json['accountNo'] as int?,
      payablesStatus: json['payablesStatus'] as bool?,
      transactionMode: json['transactionMode'] as String?,
      isStudentPurchaseEnabled: json['isStudentPurchaseEnabled'] as bool?,
      isExpressOrderEnabled: json['isExpressOrderEnabled'] as bool?,
      numberOfFingerPrints: json['numberOfFingerPrints'] as int?,
      enableCashConfig: json['enableCashConfig'] as bool?,
      enrollFingerPrintQuality: json['enrollFingerPrintQuality'] as int?,
      verifyFingerPrintQuality: json['verifyFingerPrintQuality'] as int?,
      viewSummaryBeforePrinting: json['viewSummaryBeforePrinting'] as bool?,
      enableStartOrder: json['enableStartOrder'] as bool?,
      enablePOSStartOrder: json['enablePOSStartOrder'] as bool?,
      enablePosCaptainsOrderOrder: json['enablePosCaptainsOrderOrder'] as bool?,
      zpmStartOrderBySelectingCategory: json['zpmStartOrderBySelectingCategory'] as bool?,
      ledgerAccountsAdded: json['ledgerAccountsAdded'] as String?,
      xeroLedgerAccountsAdded: json['xeroLedgerAccountsAdded'] as String?,
      qbLedgerAccountsAdded: json['qbLedgerAccountsAdded'] as String?,
      autogenerateStudentNumber: json['autogenerateStudentNumber'] as bool?,
      ecitizenActivationStatus: json['ecitizenActivationStatus'] as bool?,
      proformaInvoiceStatus: json['proformaInvoiceStatus'] as String?,
      shopifyStatus: json['shopifyStatus'] as bool?,
      recipeEnabled: json['recipeEnabled'] as bool?,
      additionalServicesEnabled: json['additionalServicesEnabled'] as String?,
      isDomainUrlSet: json['isDomainUrlSet'] as bool?,
      zedPayStatus: json['zedPayStatus'] as bool?,
      isSettleInvoiceEnabled: json['isSettleInvoiceEnabled'] as bool?,
      isEvoucherEnabled: json['isEvoucherEnabled'] as bool?,
      isPumpManagementEnabled: json['isPumpManagementEnabled'] as bool?,
      airtelMoneyStatus: json['airtelMoneyStatus'] as bool?,
      cardMerchantTypeGeneral: json['cardMerchantTypeGeneral'] as bool?,
      cardMerchantTypePocketMoney: json['cardMerchantTypePocketMoney'] as bool?,
      reprintStatus: json['reprintStatus'] as bool?,
      ecommerceVoucherEnabled: json['ecommerceVoucherEnabled'] as bool?,
      etimsStatus: json['etimsStatus'] as bool?,
      freeTrialStatus: json['freeTrialStatus'] as String?,
      isFreeTrialTried: json['isFreeTrialTried'] as bool?,
      isFreeTrialEnded: json['isFreeTrialEnded'] as bool?,
      isActiveBillingPackage: json['isActiveBillingPackage'] as bool?,
      businessStatusBilling: json['businessStatusBilling'] as String?,
      stockTransferStatus: json['stockTransferStatus'] as String?,
      tockMoveTermsUpdateVersion: json['tockMoveTermsUpdateVersion'] as int?,
      stockMoveTermsUpdatedComment: json['stockMoveTermsUpdatedComment'] as String?,
      isKcbAgentEnabled: json['isKcbAgentEnabled'] as bool?,
      enforcedCollectionEnabled: json['enforcedCollectionEnabled'] as bool?,
      isStudentWithdrawFundsEnabled: json['isStudentWithdrawFundsEnabled'] as bool?,
      isQrCodeEnabled: json['isQrCodeEnabled'] as bool?,
      canZedTransferToOutlet: json['canZedTransferToOutlet'] as String?,
      schoolStreams: json['schoolStreams'] as List<dynamic>?,
      schoolCourses: json['schoolCourses'] as List<dynamic>?,
      courseUnits: json['courseUnits'] as List<dynamic>?,
      kcbDarajaConfigIds: json['kcbDarajaConfigIds'] as List<dynamic>?,
      bookAppointment: json['bookAppointment'] as List<dynamic>?,
      timeOff: json['timeOff'] as List<dynamic>?,
      suppliers: json['suppliers'] as List<dynamic>?,
      payees: json['payees'] as List<dynamic>?,
      departments: json['departments'] as List<dynamic>?,
      unitMovement: json['unitMovement'] as List<dynamic>?,
      noticeOfEviction: json['noticeOfEviction'] as List<dynamic>?,
      bookingTime: json['bookingTime'] as List<dynamic>?,
      paymentModes: json['paymentModes'] as List<dynamic>?,
      cardMerchant: json['cardMerchant'] as List<dynamic>?,
      mobileMoney: json['mobileMoney'] as List<dynamic>?,
      approveLevelsConfig: json['approveLevelsConfig'] as List<dynamic>?,
      fundsTransferAmountRangeConfig: json['fundsTransferAmountRangeConfig'] as List<dynamic>?,
      businessFundsTransferConfig: json['businessFundsTransferConfig'] as List<dynamic>?,
      businessAccounts: json['businessAccounts'] as List<dynamic>?,
      xeroAccounts: json['xeroAccounts'] as List<dynamic>?,
      quickbooksAccounts: json['quickbooksAccounts'] as List<dynamic>?,
      partners: json['partners'] as List<dynamic>?,
      bankStatementAccounts: json['bankStatementAccounts'] as List<dynamic>?,
      pocketMoneyAccounts: json['pocketMoneyAccounts'] as List<dynamic>?,
      prefixPerGrade: json['prefixPerGrade'] as List<dynamic>?,
      listBusinessChanges: json['listBusinessChanges'] as List<dynamic>?,
      schoolSessions: json['schoolSessions'] as List<dynamic>?,
      proformaTimelines: json['proformaTimelines'] as List<dynamic>?,
      routes: json['routes'] as List<dynamic>?,
      productsVariations: json['productsVariations'] as List<dynamic>?,
      productTags: json['productTags'] as List<dynamic>?,
      additionalServices: json['additionalServices'] as List<dynamic>?,
      pickUpLocations: json['pickUpLocations'] as List<dynamic>?,
      shippingRegions: json['shippingRegions'] as List<dynamic>?,
      joinBusinessRequests: json['joinBusinessRequests'] as List<dynamic>?,
      zedPayConfig: json['zedPayConfig'] as List<dynamic>?,
      accessBankConfigs: json['accessBankConfigs'] as List<dynamic>?,
      pumps: json['pumps'] as List<dynamic>?,
      cardPresentAccounts: json['cardPresentAccounts'] as List<dynamic>?,
      cardPresentTerminalConfig: json['cardPresentTerminalConfig'] as List<dynamic>?,
      merchantFeeConfig: json['merchantFeeConfig'] as List<dynamic>?,
      onlineBookingEvoucher: json['onlineBookingEvoucher'] as List<dynamic>?,
      merchantAccountConfig: json['merchantAccountConfig'] as List<dynamic>?,
      merchantSettlement: json['merchantSettlement'] as List<dynamic>?,
      zpmReconcileConfigs: json['zpmReconcileConfigs'] as List<dynamic>?,
      creditAccountsSupplier: json['creditAccountsSupplier'] as List<dynamic>?,
      remindersConfig: json['remindersConfig'] as List<dynamic>?,
      discounts: json['discounts'] as List<dynamic>?,
      subscribedBillingPlans: json['SubscribedBillingPlans'] as List<dynamic>?,
      businessDocuments: json['businessDocuments'] as List<dynamic>?,
      outletAccounts: json['outletAccounts'] as List<dynamic>?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
      cashEnabledBy: json['cashEnabledBy'] as String?,
      cashStatus: json['cashStatus'] as String?,
      dateCashEnabled: json['dateCashEnabled'] as String?,
      updatedBy: json['updatedBy'] as String?,
      updatedComment: json['updatedComment'] as String?,
      sessionToken: json['sessionToken'] as String?,
      businessUsers: json['businessUsers'] as String?,
      proformStatus: json['proformStatus'] as bool?,
      myRole: json['myRole'] as String?,
      totalSales: json['totalSales'] as int?,
      isPayItYEnabled: json['isPayItYEnabled'] as bool?,
      is2factorEnabled: json['is2factorEnabled'] as bool?,
      firstName: json['firstName'] as String?,
      secondName: json['secondName'] as String?,
      userName: json['userName'] as String?,
      accountingEnabled: json['accountingEnabled'] as bool?,
      ipsasEnabled: json['ipsasEnabled'] as bool?,
      isTermlyFeePaid: json['isTermlyFeePaid'] as bool?,
      termlyAmount: json['termlyAmount'] as int?,
      enableStudentSponsor: json['enableStudentSponsor'] as bool?,
      unReadNotificationsCount: json['unReadNotificationsCount'] as int?,
      isOpeningClosingStockEnabled: json['isOpeningClosingStockEnabled'] as bool?,
      isStockOrderEnabled: json['isStockOrderEnabled'] as bool?,
      sessionTimeout: json['sessionTimeout'] as String?,
      businessBillingDetails: json['businessBillingDetails'] != null
          ? BusinessBillingDetails.fromJson(json['businessBillingDetails'] as Map<String, dynamic>)
          : null,
    );
  }
  final bool? isNanoBusiness;
  final String? id;
  final String? businessNumber;
  final String? businessName;
  final String? businessOwnerName;
  final String? businessOwnerUserName;
  final String? businessOwnerEmail;
  final String? businessOwnerAddress;
  final String? businessOwnerGroup;
  final String? businessOwnerPassword;
  final String? businessCategory;
  final String? businessCategoryType;
  final String? passwordStatus;
  final String? passwordExpiry;
  final String? businessOwnerPhone;
  final String? resetRequestTime;
  final String? businessState;
  final String? createdAt;
  final String? createdBy;
  final String? modifiedAt;
  final String? schooltypeId;
  final String? till;
  final String? paybill;
  final String? vooma;
  final String? equitel;
  final String? deviceCreatedOn;
  final String? bulkTerminals;
  final bool? newImplementation;
  final String? userId;
  final String? businessLogo;
  final String? localCurrency;
  final String? country;
  final String? branches;
  final bool? warehouseOn;
  final bool? mainStoreOn;
  final bool? secondaryStoreOn;
  final bool? viewSellingPrice;
  final String? workflowState;
  final String? businessType;
  final bool? paypalStatus;
  final String? timezone;
  final String? xeroAccountingEnabled;
  final String? quickbooksAccountingEnabled;
  final String? zohoAccountingEnabled;
  final bool? isOnlineBookingEnabled;
  final String? sageAccountingEnabled;
  final bool? bookingConfig;
  final bool? hasDefaultSchoolDashbaord;
  final bool? hasConvenienceFee;
  final int? accountNo;
  final bool? payablesStatus;
  final String? transactionMode;
  final bool? isStudentPurchaseEnabled;
  final bool? isExpressOrderEnabled;
  final int? numberOfFingerPrints;
  final bool? enableCashConfig;
  final int? enrollFingerPrintQuality;
  final int? verifyFingerPrintQuality;
  final bool? viewSummaryBeforePrinting;
  final bool? enableStartOrder;
  final bool? enablePOSStartOrder;
  final bool? enablePosCaptainsOrderOrder;
  final bool? zpmStartOrderBySelectingCategory;
  final String? ledgerAccountsAdded;
  final String? xeroLedgerAccountsAdded;
  final String? qbLedgerAccountsAdded;
  final bool? autogenerateStudentNumber;
  final bool? ecitizenActivationStatus;
  final String? proformaInvoiceStatus;
  final bool? shopifyStatus;
  final bool? recipeEnabled;
  final String? additionalServicesEnabled;
  final bool? isDomainUrlSet;
  final bool? zedPayStatus;
  final bool? isSettleInvoiceEnabled;
  final bool? isEvoucherEnabled;
  final bool? isPumpManagementEnabled;
  final bool? airtelMoneyStatus;
  final bool? cardMerchantTypeGeneral;
  final bool? cardMerchantTypePocketMoney;
  final bool? reprintStatus;
  final bool? ecommerceVoucherEnabled;
  final bool? etimsStatus;
  final String? freeTrialStatus;
  final bool? isFreeTrialTried;
  final bool? isFreeTrialEnded;
  final bool? isActiveBillingPackage;
  final String? businessStatusBilling;
  final String? stockTransferStatus;
  final int? tockMoveTermsUpdateVersion;
  final String? stockMoveTermsUpdatedComment;
  final bool? isKcbAgentEnabled;
  final bool? enforcedCollectionEnabled;
  final bool? isStudentWithdrawFundsEnabled;
  final bool? isQrCodeEnabled;
  final String? canZedTransferToOutlet;
  final List<dynamic>? schoolStreams;
  final List<dynamic>? schoolCourses;
  final List<dynamic>? courseUnits;
  final List<dynamic>? kcbDarajaConfigIds;
  final List<dynamic>? bookAppointment;
  final List<dynamic>? timeOff;
  final List<dynamic>? suppliers;
  final List<dynamic>? payees;
  final List<dynamic>? departments;
  final List<dynamic>? unitMovement;
  final List<dynamic>? noticeOfEviction;
  final List<dynamic>? bookingTime;
  final List<dynamic>? paymentModes;
  final List<dynamic>? cardMerchant;
  final List<dynamic>? mobileMoney;
  final List<dynamic>? approveLevelsConfig;
  final List<dynamic>? fundsTransferAmountRangeConfig;
  final List<dynamic>? businessFundsTransferConfig;
  final List<dynamic>? businessAccounts;
  final List<dynamic>? xeroAccounts;
  final List<dynamic>? quickbooksAccounts;
  final List<dynamic>? partners;
  final List<dynamic>? bankStatementAccounts;
  final List<dynamic>? pocketMoneyAccounts;
  final List<dynamic>? prefixPerGrade;
  final List<dynamic>? listBusinessChanges;
  final List<dynamic>? schoolSessions;
  final List<dynamic>? proformaTimelines;
  final List<dynamic>? routes;
  final List<dynamic>? productsVariations;
  final List<dynamic>? productTags;
  final List<dynamic>? additionalServices;
  final List<dynamic>? pickUpLocations;
  final List<dynamic>? shippingRegions;
  final List<dynamic>? joinBusinessRequests;
  final List<dynamic>? zedPayConfig;
  final List<dynamic>? accessBankConfigs;
  final List<dynamic>? pumps;
  final List<dynamic>? cardPresentAccounts;
  final List<dynamic>? cardPresentTerminalConfig;
  final List<dynamic>? merchantFeeConfig;
  final List<dynamic>? onlineBookingEvoucher;
  final List<dynamic>? merchantAccountConfig;
  final List<dynamic>? merchantSettlement;
  final List<dynamic>? zpmReconcileConfigs;
  final List<dynamic>? creditAccountsSupplier;
  final List<dynamic>? remindersConfig;
  final List<dynamic>? discounts;
  final List<dynamic>? subscribedBillingPlans;
  final List<dynamic>? businessDocuments;
  final List<dynamic>? outletAccounts;
  final String? updatedAt;
  final int? v;
  final String? cashEnabledBy;
  final String? cashStatus;
  final String? dateCashEnabled;
  final String? updatedBy;
  final String? updatedComment;
  final String? sessionToken;
  final String? businessUsers;
  final bool? proformStatus;
  final String? myRole;
  final int? totalSales;
  final bool? isPayItYEnabled;
  final bool? is2factorEnabled;
  final String? firstName;
  final String? secondName;
  final String? userName;
  final bool? accountingEnabled;
  final bool? ipsasEnabled;
  final bool? isTermlyFeePaid;
  final int? termlyAmount;
  final bool? enableStudentSponsor;
  final int? unReadNotificationsCount;
  final bool? isOpeningClosingStockEnabled;
  final bool? isStockOrderEnabled;
  final String? sessionTimeout;
  final BusinessBillingDetails? businessBillingDetails;

  Map<String, dynamic> toJson() {
    return {
      'isNanoBusiness': isNanoBusiness,
      '_id': id,
      'businessNumber': businessNumber,
      'businessName': businessName,
      'businessOwnerName': businessOwnerName,
      'businessOwnerUserName': businessOwnerUserName,
      'businessOwnerEmail': businessOwnerEmail,
      'businessOwnerAddress': businessOwnerAddress,
      'businessOwnerGroup': businessOwnerGroup,
      'businessOwnerPassword': businessOwnerPassword,
      'businessCategory': businessCategory,
      'businessCategoryType': businessCategoryType,
      'passwordStatus': passwordStatus,
      'passwordExpiry': passwordExpiry,
      'businessOwnerPhone': businessOwnerPhone,
      'resetRequestTime': resetRequestTime,
      'businessState': businessState,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'modifiedAt': modifiedAt,
      'schooltypeId': schooltypeId,
      'Till': till,
      'Paybill': paybill,
      'Vooma': vooma,
      'Equitel': equitel,
      'deviceCreatedOn': deviceCreatedOn,
      'bulkTerminals': bulkTerminals,
      'newImplementation': newImplementation,
      'userId': userId,
      'businessLogo': businessLogo,
      'localCurrency': localCurrency,
      'country': country,
      'branches': branches,
      'warehouseOn': warehouseOn,
      'mainStoreOn': mainStoreOn,
      'secondaryStoreOn': secondaryStoreOn,
      'viewSellingPrice': viewSellingPrice,
      'workflowState': workflowState,
      'businessType': businessType,
      'paypalStatus': paypalStatus,
      'timezone': timezone,
      'xeroAccountingEnabled': xeroAccountingEnabled,
      'quickbooksAccountingEnabled': quickbooksAccountingEnabled,
      'zohoAccountingEnabled': zohoAccountingEnabled,
      'isOnlineBookingEnabled': isOnlineBookingEnabled,
      'sageAccountingEnabled': sageAccountingEnabled,
      'bookingConfig': bookingConfig,
      'hasDefaultSchoolDashbaord': hasDefaultSchoolDashbaord,
      'hasConvenienceFee': hasConvenienceFee,
      'accountNo': accountNo,
      'payablesStatus': payablesStatus,
      'transactionMode': transactionMode,
      'isStudentPurchaseEnabled': isStudentPurchaseEnabled,
      'isExpressOrderEnabled': isExpressOrderEnabled,
      'numberOfFingerPrints': numberOfFingerPrints,
      'enableCashConfig': enableCashConfig,
      'enrollFingerPrintQuality': enrollFingerPrintQuality,
      'verifyFingerPrintQuality': verifyFingerPrintQuality,
      'viewSummaryBeforePrinting': viewSummaryBeforePrinting,
      'enableStartOrder': enableStartOrder,
      'enablePOSStartOrder': enablePOSStartOrder,
      'enablePosCaptainsOrderOrder': enablePosCaptainsOrderOrder,
      'zpmStartOrderBySelectingCategory': zpmStartOrderBySelectingCategory,
      'ledgerAccountsAdded': ledgerAccountsAdded,
      'xeroLedgerAccountsAdded': xeroLedgerAccountsAdded,
      'qbLedgerAccountsAdded': qbLedgerAccountsAdded,
      'autogenerateStudentNumber': autogenerateStudentNumber,
      'ecitizenActivationStatus': ecitizenActivationStatus,
      'proformaInvoiceStatus': proformaInvoiceStatus,
      'shopifyStatus': shopifyStatus,
      'recipeEnabled': recipeEnabled,
      'additionalServicesEnabled': additionalServicesEnabled,
      'isDomainUrlSet': isDomainUrlSet,
      'zedPayStatus': zedPayStatus,
      'isSettleInvoiceEnabled': isSettleInvoiceEnabled,
      'isEvoucherEnabled': isEvoucherEnabled,
      'isPumpManagementEnabled': isPumpManagementEnabled,
      'airtelMoneyStatus': airtelMoneyStatus,
      'cardMerchantTypeGeneral': cardMerchantTypeGeneral,
      'cardMerchantTypePocketMoney': cardMerchantTypePocketMoney,
      'reprintStatus': reprintStatus,
      'ecommerceVoucherEnabled': ecommerceVoucherEnabled,
      'etimsStatus': etimsStatus,
      'freeTrialStatus': freeTrialStatus,
      'isFreeTrialTried': isFreeTrialTried,
      'isFreeTrialEnded': isFreeTrialEnded,
      'isActiveBillingPackage': isActiveBillingPackage,
      'businessStatusBilling': businessStatusBilling,
      'stockTransferStatus': stockTransferStatus,
      'tockMoveTermsUpdateVersion': tockMoveTermsUpdateVersion,
      'stockMoveTermsUpdatedComment': stockMoveTermsUpdatedComment,
      'isKcbAgentEnabled': isKcbAgentEnabled,
      'enforcedCollectionEnabled': enforcedCollectionEnabled,
      'isStudentWithdrawFundsEnabled': isStudentWithdrawFundsEnabled,
      'isQrCodeEnabled': isQrCodeEnabled,
      'canZedTransferToOutlet': canZedTransferToOutlet,
      'schoolStreams': schoolStreams,
      'schoolCourses': schoolCourses,
      'courseUnits': courseUnits,
      'kcbDarajaConfigIds': kcbDarajaConfigIds,
      'bookAppointment': bookAppointment,
      'timeOff': timeOff,
      'suppliers': suppliers,
      'payees': payees,
      'departments': departments,
      'unitMovement': unitMovement,
      'noticeOfEviction': noticeOfEviction,
      'bookingTime': bookingTime,
      'paymentModes': paymentModes,
      'cardMerchant': cardMerchant,
      'mobileMoney': mobileMoney,
      'approveLevelsConfig': approveLevelsConfig,
      'fundsTransferAmountRangeConfig': fundsTransferAmountRangeConfig,
      'businessFundsTransferConfig': businessFundsTransferConfig,
      'businessAccounts': businessAccounts,
      'xeroAccounts': xeroAccounts,
      'quickbooksAccounts': quickbooksAccounts,
      'partners': partners,
      'bankStatementAccounts': bankStatementAccounts,
      'pocketMoneyAccounts': pocketMoneyAccounts,
      'prefixPerGrade': prefixPerGrade,
      'listBusinessChanges': listBusinessChanges,
      'schoolSessions': schoolSessions,
      'proformaTimelines': proformaTimelines,
      'routes': routes,
      'productsVariations': productsVariations,
      'productTags': productTags,
      'additionalServices': additionalServices,
      'pickUpLocations': pickUpLocations,
      'shippingRegions': shippingRegions,
      'joinBusinessRequests': joinBusinessRequests,
      'zedPayConfig': zedPayConfig,
      'accessBankConfigs': accessBankConfigs,
      'pumps': pumps,
      'cardPresentAccounts': cardPresentAccounts,
      'cardPresentTerminalConfig': cardPresentTerminalConfig,
      'merchantFeeConfig': merchantFeeConfig,
      'onlineBookingEvoucher': onlineBookingEvoucher,
      'merchantAccountConfig': merchantAccountConfig,
      'merchantSettlement': merchantSettlement,
      'zpmReconcileConfigs': zpmReconcileConfigs,
      'creditAccountsSupplier': creditAccountsSupplier,
      'remindersConfig': remindersConfig,
      'discounts': discounts,
      'SubscribedBillingPlans': subscribedBillingPlans,
      'businessDocuments': businessDocuments,
      'outletAccounts': outletAccounts,
      'updatedAt': updatedAt,
      '__v': v,
      'cashEnabledBy': cashEnabledBy,
      'cashStatus': cashStatus,
      'dateCashEnabled': dateCashEnabled,
      'updatedBy': updatedBy,
      'updatedComment': updatedComment,
      'sessionToken': sessionToken,
      'businessUsers': businessUsers,
      'proformStatus': proformStatus,
      'myRole': myRole,
      'totalSales': totalSales,
      'isPayItYEnabled': isPayItYEnabled,
      'is2factorEnabled': is2factorEnabled,
      'firstName': firstName,
      'secondName': secondName,
      'userName': userName,
      'accountingEnabled': accountingEnabled,
      'ipsasEnabled': ipsasEnabled,
      'isTermlyFeePaid': isTermlyFeePaid,
      'termlyAmount': termlyAmount,
      'enableStudentSponsor': enableStudentSponsor,
      'unReadNotificationsCount': unReadNotificationsCount,
      'isOpeningClosingStockEnabled': isOpeningClosingStockEnabled,
      'isStockOrderEnabled': isStockOrderEnabled,
      'sessionTimeout': sessionTimeout,
      'businessBillingDetails': businessBillingDetails?.toJson(),
    };
  }
}
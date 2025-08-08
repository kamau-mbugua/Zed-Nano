class BillingPlanPackagesResponse {

  BillingPlanPackagesResponse({
    this.status,
    this.message,
    this.response,
    this.businessCategory,
    this.noOfFreeTrialDays,
  });

  factory BillingPlanPackagesResponse.fromJson(Map<String, dynamic> json) {
    return BillingPlanPackagesResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      response: (json['response'] as List<dynamic>?)
          ?.map((e) => BillingPlanPackageGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
      businessCategory: json['businessCategory'] as String?,
      noOfFreeTrialDays: json['noOfFreeTrialDays'] as int?,
    );
  }
  final String? status;
  final String? message;
  final List<BillingPlanPackageGroup>? response;
  final String? businessCategory;
  final int? noOfFreeTrialDays;

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'response': response?.map((e) => e.toJson()).toList(),
      'businessCategory': businessCategory,
      'noOfFreeTrialDays': noOfFreeTrialDays,
    };
  }
}

class BillingPlanPackageGroup {

  BillingPlanPackageGroup({
    this.id,
    this.plans,
    this.isRecommended,
  });

  factory BillingPlanPackageGroup.fromJson(Map<String, dynamic> json) {
    return BillingPlanPackageGroup(
      id: json['_id'] as String?,
      plans: (json['plans'] as List<dynamic>?)
          ?.map((e) => BillingPlan.fromJson(e as Map<String, dynamic>))
          .toList(),
      isRecommended: json['isRecommended'] as bool,
    );
  }
  final String? id;
  final List<BillingPlan>? plans;
  final bool? isRecommended;

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'plans': plans?.map((e) => e.toJson()).toList(),
      'isRecommended': isRecommended,
    };
  }
}

class BillingPlan {

  BillingPlan({
    this.billingPlanName,
    this.businessCategory,
    this.planSetUpFee,
    this.noOfBranches,
    this.extraBranchFee,
    this.createdBy,
    this.nofFreeTrialDays,
    this.billingPlanStatus,
    this.billableFeatures,
    this.packageId,
    this.billingPlanPaymentPlanId,
    this.billingPeriodAmount,
  });

  factory BillingPlan.fromJson(Map<String, dynamic> json) {
    return BillingPlan(
      billingPlanName: json['billingPlanName'] as String?,
      businessCategory: json['businessCategory'] as String?,
      planSetUpFee: json['planSetUpFee'] as int?,
      noOfBranches: json['noOfBranches'] as int?,
      extraBranchFee: json['extraBranchFee'] as int?,
      createdBy: json['createdBy'] as String?,
      nofFreeTrialDays: json['nofFreeTrialDays'] as int?,
      billingPlanStatus: json['billingPlanStatus'] as String?,
      billableFeatures: json['billableFeatures'] as List<dynamic>?,
      packageId: json['packageId'] as String?,
      billingPlanPaymentPlanId: json['billingPlanPaymentPlanId'] as String?,
      billingPeriodAmount: json['billingPeriodAmount'] as int?,
    );
  }
  final String? billingPlanName;
  final String? businessCategory;
  final int? planSetUpFee;
  final int? noOfBranches;
  final int? extraBranchFee;
  final String? createdBy;
  final int? nofFreeTrialDays;
  final String? billingPlanStatus;
  final List<dynamic>? billableFeatures;
  final String? packageId;
  final String? billingPlanPaymentPlanId;
  final int? billingPeriodAmount;

  Map<String, dynamic> toJson() {
    return {
      'billingPlanName': billingPlanName,
      'businessCategory': businessCategory,
      'planSetUpFee': planSetUpFee,
      'noOfBranches': noOfBranches,
      'extraBranchFee': extraBranchFee,
      'createdBy': createdBy,
      'nofFreeTrialDays': nofFreeTrialDays,
      'billingPlanStatus': billingPlanStatus,
      'billableFeatures': billableFeatures,
      'packageId': packageId,
      'billingPlanPaymentPlanId': billingPlanPaymentPlanId,
      'billingPeriodAmount': billingPeriodAmount,
    };
  }
}
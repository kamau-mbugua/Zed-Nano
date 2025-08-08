class SubscribedBillingPlansResponse {

  SubscribedBillingPlansResponse({
    this.status,
    this.message,
    this.data,
    this.freeTrialStatus,
    this.isFreeTrialTried,
    this.isFreeTrialEnded,
    this.isActiveBillingPackage,
    this.freeTrialPeriodRemainingdays,
  });

  factory SubscribedBillingPlansResponse.fromJson(Map<String, dynamic> json) {
    return SubscribedBillingPlansResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SubscribedBillingBillingPlan.fromJson(e as Map<String, dynamic>))
          .toList(),
      freeTrialStatus: json['freeTrialStatus'] as String?,
      isFreeTrialTried: json['isFreeTrialTried'] as bool?,
      isFreeTrialEnded: json['isFreeTrialEnded'] as bool?,
      isActiveBillingPackage: json['isActiveBillingPackage'] as bool?,
      freeTrialPeriodRemainingdays: json['freeTrialPeriodRemainingdays'] as int?,
    );
  }
  final String? status;
  final String? message;
  final List<SubscribedBillingBillingPlan>? data;
  final String? freeTrialStatus;
  final bool? isFreeTrialTried;
  final bool? isFreeTrialEnded;
  final bool? isActiveBillingPackage;
  final int? freeTrialPeriodRemainingdays;

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
      'freeTrialStatus': freeTrialStatus,
      'isFreeTrialTried': isFreeTrialTried,
      'isFreeTrialEnded': isFreeTrialEnded,
      'isActiveBillingPackage': isActiveBillingPackage,
      'freeTrialPeriodRemainingdays': freeTrialPeriodRemainingdays,
    };
  }
}

class SubscribedBillingBillingPlan {

  SubscribedBillingBillingPlan({
    this.planId,
    this.planName,
    this.planStatus,
    this.dateSubscribed,
    this.billingPeriodName,
    this.totalBillingPlanAmount,
    this.planSetUpFee,
    this.isSetUpFeePaid,
    this.billingPeriodAmount,
    this.dueDate,
  });

  factory SubscribedBillingBillingPlan.fromJson(Map<String, dynamic> json) {
    return SubscribedBillingBillingPlan(
      planId: json['planId'] as String?,
      planName: json['planName'] as String?,
      planStatus: json['planStatus'] as String?,
      dateSubscribed: json['dateSubscribed'] as String?,
      dueDate: json['dueDate'] as String?,
      billingPeriodName: json['billingPeriodName'] as String?,
      totalBillingPlanAmount: json['totalBillingPlanAmount'] as int?,
      planSetUpFee: json['planSetUpFee'] as int?,
      isSetUpFeePaid: json['isSetUpFeePaid'] as bool?,
      billingPeriodAmount: json['billingPeriodAmount'] as int?,
    );
  }
  final String? planId;
  final String? planName;
  final String? planStatus;
  final String? dateSubscribed;
  final String? dueDate;
  final String? billingPeriodName;
  final int? totalBillingPlanAmount;
  final int? planSetUpFee;
  final bool? isSetUpFeePaid;
  final int? billingPeriodAmount;

  Map<String, dynamic> toJson() {
    return {
      'planId': planId,
      'planName': planName,
      'planStatus': planStatus,
      'dateSubscribed': dateSubscribed,
      'dueDate': dueDate,
      'billingPeriodName': billingPeriodName,
      'totalBillingPlanAmount': totalBillingPlanAmount,
      'planSetUpFee': planSetUpFee,
      'isSetUpFeePaid': isSetUpFeePaid,
      'billingPeriodAmount': billingPeriodAmount,
    };
  }
}
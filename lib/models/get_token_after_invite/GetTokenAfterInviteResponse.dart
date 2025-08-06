import 'package:zed_nano/models/listsubscribed_billing_plans/SubscribedBillingPlansResponse.dart';

class GetTokenAfterInviteResponse {
  final Data? data;

  GetTokenAfterInviteResponse({this.data});

  factory GetTokenAfterInviteResponse.fromJson(Map<String, dynamic> json) {
    return GetTokenAfterInviteResponse(
      data: json['data'] != null
          ? Data.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
    };
  }
}

class Data {
  final String? token;
  final String? group;
  final String? userName;
  final String? email;
  final String? storeName;
  final bool? packagePaidStatus;
  final String? workflowState;
  final BusinessBillingDetails? businessBillingDetails;

  Data({
    this.token,
    this.group,
    this.userName,
    this.email,
    this.storeName,
    this.packagePaidStatus,
    this.workflowState,
    this.businessBillingDetails,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      token: json['token'] as String?,
      group: json['group'] as String?,
      userName: json['userName'] as String?,
      email: json['email'] as String?,
      storeName: json['storeName'] as String?,
      workflowState: json['workflowState'] as String?,
      packagePaidStatus: json['packagePaidStatus'] as bool?,
      businessBillingDetails: json['businessBillingDetails'] != null
          ? BusinessBillingDetails.fromJson(json['businessBillingDetails'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'group': group,
      'userName': userName,
      'email': email,
      'storeName': storeName,
      'workflowState': workflowState,
      'packagePaidStatus': packagePaidStatus,
      'businessBillingDetails': businessBillingDetails?.toJson(),
    };
  }
}

class NanoSubscription {
  final List<SubscribedBillingBillingPlan>? data;
  final String? freeTrialStatus;
  final String? freeTrialPlanName;
  final String? freeTrialEndTime;
  final bool? isFreeTrialTried;
  final bool? isFreeTrialEnded;
  final bool? isActiveBillingPackage;
  final String? freeTrialPeriodRemainingdays;

  NanoSubscription({
    this.data,
    this.freeTrialStatus,
    this.freeTrialPlanName,
    this.freeTrialEndTime,
    this.isFreeTrialTried,
    this.isFreeTrialEnded,
    this.isActiveBillingPackage,
    this.freeTrialPeriodRemainingdays,
  });

  factory NanoSubscription.fromJson(Map<String, dynamic> json) {
    return NanoSubscription(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SubscribedBillingBillingPlan.fromJson(e as Map<String, dynamic>))
          .toList(),
      freeTrialStatus: json['freeTrialStatus'] as String?,
      freeTrialPlanName: json['freeTrialPlanName'] as String?,
      freeTrialEndTime: json['freeTrialEndTime'] as String?,
      isFreeTrialTried: json['isFreeTrialTried'] as bool?,
      isFreeTrialEnded: json['isFreeTrialEnded'] as bool?,
      isActiveBillingPackage: json['isActiveBillingPackage'] as bool?,
      freeTrialPeriodRemainingdays: json['freeTrialPeriodRemainingdays'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((e) => e.toJson()).toList(),
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

class BusinessBillingDetails {
  final String? subscriptionPlanName;
  final String? subscriptionType;
  final String? billingStatus;
  final String? billingDueDate;
  final int? billingRemainingDays;
  final String? billingPeriodName;
  final List<BillableFeature>? billableFeatures;
  final String? billingType;
  final NanoSubscription? nanoSubscription;

  BusinessBillingDetails({
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
      subscriptionPlanName: json['subscriptionPlanName'] as String?,
      subscriptionType: json['subscriptionType'] as String?,
      billingStatus: json['billingStatus'] as String?,
      billingDueDate: json['billingDueDate'] as String?,
      billingRemainingDays: json['billingRemainingDays'] as int?,
      billingPeriodName: json['billingPeriodName'] as String?,
      billableFeatures: (json['billableFeatures'] as List<dynamic>?)
          ?.map((e) => BillableFeature.fromJson(e as Map<String, dynamic>))
          .toList(),
      billingType: json['billingType'] as String?,
      nanoSubscription: json['nanoSubscription'] != null
          ? NanoSubscription.fromJson(json['nanoSubscription'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subscriptionPlanName': subscriptionPlanName,
      'subscriptionType': subscriptionType,
      'billingStatus': billingStatus,
      'billingDueDate': billingDueDate,
      'billingRemainingDays': billingRemainingDays,
      'billingPeriodName': billingPeriodName,
      'billableFeatures': billableFeatures?.map((e) => e.toJson()).toList(),
      'billingType': billingType,
      'nanoSubscription': nanoSubscription?.toJson(),
    };
  }
}

class BillableFeature {
  final String? id;
  final String? slug;

  BillableFeature({
    this.id,
    this.slug,
  });

  factory BillableFeature.fromJson(Map<String, dynamic> json) {
    return BillableFeature(
      id: json['_id'] as String?,
      slug: json['slug'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'slug': slug,
    };
  }
}
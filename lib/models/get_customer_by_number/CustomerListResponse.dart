
class GetCustomerByNumberResponse {

  GetCustomerByNumberResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.count,
  });

  factory GetCustomerByNumberResponse.fromJson(Map<String, dynamic> json) {
    return GetCustomerByNumberResponse(
      status: json['Status'] as String,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => CustomerData.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: json['count'] as int,
    );
  }
  final String status;
  final String message;
  final List<CustomerData> data;
  final int count;

  Map<String, dynamic> toJson() => {
    'Status': status,
    'message': message,
    'data': data.map((e) => e.toJson()).toList(),
    'count': count,
  };
}


class CustomerData {

  CustomerData({
    this.id,
    this.businessId,
    this.customerNumber,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.studentAsParent,
    this.customerType,
    this.customerAddress,
    this.paymentType,
    this.isParentPrimary,
    this.parentType,
    this.localCurrency,
    this.country,
    this.limit,
    this.limitType,
    this.beneficiaries,
    this.vehicles,
    this.amountReceived,
    this.limitInstrument,
    this.branchId,
    this.status,
    this.createdBy,
    this.createdNameBy,
    this.userId,
    this.billableItems,
    this.servicesAttached,
    this.extraServices,
    this.operatorProducts,
    this.fromBusinessNumber,
    this.sponsorStatus,
    this.courseUnits,
    this.emergencyContacts,
    this.createdByName,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.activatedBy,
    this.activatedNameBy,
    this.totalCredits,
    this.totalExpense,
    this.totalBalance,
    this.businessName,
    this.itemsCount,
    this.pendingAmount,
    this.pendingInvoicesCount,
    this.totalPaymentAmount,
    this.courseCount,
    this.courses,
    this.unitsCount,
    this.hasSecondaryParent,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      id: json['_id'] as String?,
      businessId: json['businessId'] as String?,
      customerNumber: json['customerNumber'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      studentAsParent: json['studentAsParent'] as bool?,
      customerType: json['customerType'] as String?,
      customerAddress: json['customerAddress'] as String?,
      paymentType: json['paymentType'] as String?,
      isParentPrimary: json['isParentPrimary'] as bool?,
      parentType: json['parentType'] as String?,
      localCurrency: json['localCurrency'] as String?,
      country: json['country'] as String?,
      limit: json['limit'] as int?,
      limitType: json['limitType'] as String?,
      beneficiaries: json['beneficiaries'] as List<dynamic>?,
      vehicles: json['vehicles'] as List<dynamic>?,
      amountReceived: json['amountReceived'] as int?,
      limitInstrument: json['limitInstrument'] as String?,
      branchId: json['branchId'] as String?,
      status: json['status'] as String?,
      createdBy: json['createdBy'] as String?,
      createdNameBy: json['createdNameBy'] as String?,
      userId: json['userId'] as String?,
      billableItems: json['billableItems'] as List<dynamic>?,
      servicesAttached: json['servicesAttached'] as List<dynamic>?,
      extraServices: json['extraServices'] as List<dynamic>?,
      operatorProducts: json['operatorProducts'] as List<dynamic>?,
      fromBusinessNumber: json['fromBusinessNumber'] as String?,
      sponsorStatus: json['SponsorStatus'] as String?,
      createdByName: json['createdByName'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      courseUnits: json['courseUnits'] as List<dynamic>?,
      emergencyContacts: json['emergencyContacts'] as List<dynamic>?,
      v: json['__v'] as int?,
      activatedBy: json['activatedBy'] as String?,
      activatedNameBy: json['activatedNameBy'] as String?,
      totalCredits: json['totalCredits'] as int?,
      totalExpense: json['totalExpense'] as int?,
      totalBalance: json['totalBalance'] as int?,
      businessName: json['businessName'] as String?,
      itemsCount: json['itemsCount'] as int?,
      pendingAmount: json['pendingAmount'] as int?,
      pendingInvoicesCount: json['pendingInvoicesCount'] as int?,
      totalPaymentAmount: json['totalPaymentAmount'] as int?,
      courseCount: json['courseCount'] as int?,
      courses: json['courses'] as List<dynamic>?,
      unitsCount: json['unitsCount'] as int?,
      hasSecondaryParent: json['hasSecondaryParent'] as bool?,
    );
  }
  final String? id;
  final String? businessId;
  final String? customerNumber;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final bool? studentAsParent;
  final String? customerType;
  final String? customerAddress;
  final String? paymentType;
  final bool? isParentPrimary;
  final String? parentType;
  final String? localCurrency;
  final String? country;
  final int? limit;
  final String? limitType;
  final List<dynamic>? beneficiaries;
  final List<dynamic>? vehicles;
  final int? amountReceived;
  final String? limitInstrument;
  final String? branchId;
  final String? status;
  final String? createdBy;
  final String? createdNameBy;
  final String? userId;
  final List<dynamic>? billableItems;
  final List<dynamic>? servicesAttached;
  final List<dynamic>? extraServices;
  final List<dynamic>? operatorProducts;
  final String? fromBusinessNumber;
  final String? sponsorStatus;
  final List<dynamic>? courseUnits;
  final List<dynamic>? emergencyContacts;
  final String? createdAt;
  final String? createdByName;
  final String? updatedAt;
  final int? v;
  final String? activatedBy;
  final String? activatedNameBy;
  final int? totalCredits;
  final int? totalExpense;
  final int? totalBalance;
  final String? businessName;
  final int? itemsCount;
  final int? pendingAmount;
  final int? pendingInvoicesCount;
  final int? totalPaymentAmount;
  final int? courseCount;
  final List<dynamic>? courses;
  final int? unitsCount;
  final bool? hasSecondaryParent;

  Map<String, dynamic> toJson() => {
    '_id': id,
    'businessId': businessId,
    'customerNumber': customerNumber,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phone': phone,
    'studentAsParent': studentAsParent,
    'customerType': customerType,
    'customerAddress': customerAddress,
    'paymentType': paymentType,
    'isParentPrimary': isParentPrimary,
    'parentType': parentType,
    'localCurrency': localCurrency,
    'country': country,
    'limit': limit,
    'limitType': limitType,
    'beneficiaries': beneficiaries,
    'vehicles': vehicles,
    'amountReceived': amountReceived,
    'limitInstrument': limitInstrument,
    'branchId': branchId,
    'status': status,
    'createdBy': createdBy,
    'createdNameBy': createdNameBy,
    'userId': userId,
    'billableItems': billableItems,
    'servicesAttached': servicesAttached,
    'extraServices': extraServices,
    'operatorProducts': operatorProducts,
    'fromBusinessNumber': fromBusinessNumber,
    'SponsorStatus': sponsorStatus,
    'courseUnits': courseUnits,
    'emergencyContacts': emergencyContacts,
    'createdByName': createdByName,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    '__v': v,
    'activatedBy': activatedBy,
    'activatedNameBy': activatedNameBy,
    'totalCredits': totalCredits,
    'totalExpense': totalExpense,
    'totalBalance': totalBalance,
    'businessName': businessName,
    'itemsCount': itemsCount,
    'pendingAmount': pendingAmount,
    'pendingInvoicesCount': pendingInvoicesCount,
    'totalPaymentAmount': totalPaymentAmount,
    'courseCount': courseCount,
    'courses': courses,
    'unitsCount': unitsCount,
    'hasSecondaryParent': hasSecondaryParent,
  };
}

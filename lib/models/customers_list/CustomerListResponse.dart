// CustomerListResponse class to handle the main response structure
class CustomerListResponse {

  CustomerListResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.count,
  });

  factory CustomerListResponse.fromJson(Map<String, dynamic> json) {
    return CustomerListResponse(
      status: json['Status'] as String,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => Customer.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: json['count'] as int,
    );
  }
  final String status;
  final String message;
  final List<Customer> data;
  final int count;

  Map<String, dynamic> toJson() => {
    'Status': status,
    'message': message,
    'data': data.map((e) => e.toJson()).toList(),
    'count': count,
  };
}

// Customer class to handle individual customer data
class Customer {

  Customer({
    required this.id,
    required this.customerType,
    required this.paymentType,
    required this.isParentPrimary,
    required this.parentType,
    required this.limit,
    required this.amountReceived,
    required this.status,
    required this.billableItems,
    required this.customerName,
    required this.physicalAddress,
    required this.mobileNumber,
    required this.email,
    required this.createdOn,
    required this.userId,
    required this.servicesCount,
    required this.services,
    required this.pendingInvoices,
    required this.pendingAmount,
    required this.numberOfActiveHouses,
    this.createdByName,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['_id'] as String,
      customerType: json['customerType'] as String,
      paymentType: json['paymentType'] as String,
      isParentPrimary: json['isParentPrimary'] as bool,
      parentType: json['parentType'] as String,
      limit: json['limit'] as int,
      amountReceived: json['amountReceived'] as int,
      status: json['status'] as String,
      billableItems: json['billableItems'] as List<dynamic>,
      customerName: json['customerName'] as String,
      physicalAddress: json['physicalAddress'] as String,
      mobileNumber: json['mobileNumber'] as String,
      email: json['email'] as String,
      createdOn: DateTime.parse(json['createdOn'] as String),
      userId: json['userId'] as String,
      createdByName: json['createdByName'] as String?,
      servicesCount: json['servicesCount'] as int,
      services: json['services'] as List<dynamic>,
      pendingInvoices: json['pendingInvoices'] as int,
      pendingAmount: json['pendingAmount'] as int,
      numberOfActiveHouses: json['numberOfActiveHouses'] as int,
    );
  }
  final String id;
  final String customerType;
  final String paymentType;
  final bool isParentPrimary;
  final String parentType;
  final int limit;
  final int amountReceived;
  final String status;
  final List<dynamic> billableItems;
  final String customerName;
  final String physicalAddress;
  final String mobileNumber;
  final String email;
  final String? createdByName;
  final DateTime createdOn;
  final String userId;
  final int servicesCount;
  final List<dynamic> services;
  final int pendingInvoices;
  final int pendingAmount;
  final int numberOfActiveHouses;

  Map<String, dynamic> toJson() => {
    '_id': id,
    'customerType': customerType,
    'paymentType': paymentType,
    'isParentPrimary': isParentPrimary,
    'parentType': parentType,
    'limit': limit,
    'amountReceived': amountReceived,
    'status': status,
    'billableItems': billableItems,
    'customerName': customerName,
    'physicalAddress': physicalAddress,
    'mobileNumber': mobileNumber,
    'email': email,
    'createdOn': createdOn.toIso8601String(),
    'userId': userId,
    'servicesCount': servicesCount,
    'services': services,
    'pendingInvoices': pendingInvoices,
    'pendingAmount': pendingAmount,
    'numberOfActiveHouses': numberOfActiveHouses,
    if (createdByName != null) 'createdByName': createdByName,
  };
}
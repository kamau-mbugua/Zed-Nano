class PostBusinessResponse {
  final String? status;
  final String? message;
  final String? businessId;
  final String? businessNumber;
  final PostBusinessData? data;

  PostBusinessResponse({
    this.status,
    this.message,
    this.businessId,
    this.businessNumber,
    this.data,
  });

  factory PostBusinessResponse.fromJson(Map<String, dynamic> json) {
    return PostBusinessResponse(
      status: json['Status'] as String?,
      message: json['message'] as String?,
      businessId: json['businessId'] as String?,
      businessNumber: json['businessNumber'] as String?,
      data: json['data'] != null
          ? PostBusinessData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'message': message,
      'businessId': businessId,
      'businessNumber': businessNumber,
      'data': data?.toJson(),
    };
  }
}

class PostBusinessData {
  final String? token;
  final String? group;
  final String? defaultBusinessId;
  final String? businessNumber;
  final String? businessCategory;
  final String? username;
  final String? email;
  final String? state;
  final String? branchId;
  final String? businessName;
  final String? storeName;
  final String? localCurrency;
  final String? xeroAccountingEnabled;
  final String? quickbooksAccountingEnabled;
  final String? zohoAccountingEnabled;

  PostBusinessData({
    this.token,
    this.group,
    this.defaultBusinessId,
    this.businessNumber,
    this.businessCategory,
    this.username,
    this.email,
    this.state,
    this.branchId,
    this.businessName,
    this.storeName,
    this.localCurrency,
    this.xeroAccountingEnabled,
    this.quickbooksAccountingEnabled,
    this.zohoAccountingEnabled,
  });

  factory PostBusinessData.fromJson(Map<String, dynamic> json) {
    return PostBusinessData(
      token: json['token'] as String?,
      group: json['group'] as String?,
      defaultBusinessId: json['defaultBusinessId'] as String?,
      businessNumber: json['businessNumber'] as String?,
      businessCategory: json['businessCategory'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      state: json['state'] as String?,
      branchId: json['branchId'] as String?,
      businessName: json['businessName'] as String?,
      storeName: json['storeName'] as String?,
      localCurrency: json['localCurrency'] as String?,
      xeroAccountingEnabled: json['xeroAccountingEnabled'] as String?,
      quickbooksAccountingEnabled: json['quickbooksAccountingEnabled'] as String?,
      zohoAccountingEnabled: json['zohoAccountingEnabled'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'group': group,
      'defaultBusinessId': defaultBusinessId,
      'businessNumber': businessNumber,
      'businessCategory': businessCategory,
      'username': username,
      'email': email,
      'state': state,
      'branchId': branchId,
      'businessName': businessName,
      'storeName': storeName,
      'localCurrency': localCurrency,
      'xeroAccountingEnabled': xeroAccountingEnabled,
      'quickbooksAccountingEnabled': quickbooksAccountingEnabled,
      'zohoAccountingEnabled': zohoAccountingEnabled,
    };
  }
}
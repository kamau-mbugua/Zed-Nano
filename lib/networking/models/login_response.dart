/// Model class for login response data
class LoginResponse {
  final String? status;
  final String? statusCapital;
  final String? message;
  final bool? is2FAEnabled;
  final String? partnerbusinessType;
  final String? token;
  final String? group;
  final String? username;
  final String? email;
  final String? state;
  final String? businessName;
  final String? userId;
  final dynamic branchId;
  final String? customerClassification;
  final LoginResponseData? data;

  LoginResponse({
    this.status,
    this.statusCapital,
    this.message,
    this.is2FAEnabled,
    this.partnerbusinessType,
    this.token,
    this.group,
    this.username,
    this.email,
    this.state,
    this.businessName,
    this.userId,
    this.branchId,
    this.customerClassification,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] as String?,
      statusCapital: json['Status'] as String?,
      message: json['message'] as String?,
      is2FAEnabled: json['is2FAEnabled'] as bool?,
      partnerbusinessType: json['partnerbusinessType'] as String?,
      token: json['token'] as String?,
      group: json['group'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      state: json['state'] as String?,
      businessName: json['businessName'] as String?,
      userId: json['userId'] as String?,
      branchId: json['branchId'],
      customerClassification: json['customerClassification'] as String?,
      data: json['data'] != null 
          ? LoginResponseData.fromJson(json['data'] as Map<String, dynamic>) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'Status': statusCapital,
      'message': message,
      'is2FAEnabled': is2FAEnabled,
      'partnerbusinessType': partnerbusinessType,
      'token': token,
      'group': group,
      'username': username,
      'email': email,
      'state': state,
      'businessName': businessName,
      'userId': userId,
      'branchId': branchId,
      'customerClassification': customerClassification,
      'data': data?.toJson(),
    };
  }
}

/// Data class for the data field in login response
class LoginResponseData {
  final LoginUserDetails? userDetails;
  final bool? passwordExpired;
  final bool? reset;
  final TokenDetails? tokenDetails;

  LoginResponseData({
    this.userDetails,
    this.passwordExpired,
    this.reset,
    this.tokenDetails,
  });

  factory LoginResponseData.fromJson(Map<String, dynamic> json) {
    return LoginResponseData(
      userDetails: json['userDetails'] != null 
          ? LoginUserDetails.fromJson(json['userDetails'] as Map<String, dynamic>) 
          : null,
      passwordExpired: json['passwordExpired'] as bool?,
      reset: json['reset'] as bool?,
      tokenDetails: json['tokenDetails'] != null 
          ? TokenDetails.fromJson(json['tokenDetails'] as Map<String, dynamic>) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userDetails': userDetails?.toJson(),
      'passwordExpired': passwordExpired,
      'reset': reset,
      'tokenDetails': tokenDetails?.toJson(),
    };
  }
}

/// User details from login response
class LoginUserDetails {
  final String? phoneNumber;
  final String? name;
  final int? institutionId;
  final String? institution;
  final int? shopId;
  final String? id;
  final String? usertype;

  LoginUserDetails({
    this.phoneNumber,
    this.name,
    this.institutionId,
    this.institution,
    this.shopId,
    this.id,
    this.usertype,
  });

  factory LoginUserDetails.fromJson(Map<String, dynamic> json) {
    return LoginUserDetails(
      phoneNumber: json['phoneNumber'] as String?,
      name: json['name'] as String?,
      institutionId: json['institutionId'] as int?,
      institution: json['institution'] as String?,
      shopId: json['shopId'] as int?,
      id: json['id'] as String?,
      usertype: json['usertype'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'name': name,
      'institutionId': institutionId,
      'institution': institution,
      'shopId': shopId,
      'id': id,
      'usertype': usertype,
    };
  }
}

/// Token details from login response
class TokenDetails {
  final String? accessToken;
  final String? expiry;

  TokenDetails({
    this.accessToken,
    this.expiry,
  });

  factory TokenDetails.fromJson(Map<String, dynamic> json) {
    return TokenDetails(
      accessToken: json['accessToken'] as String?,
      expiry: json['expiry'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'expiry': expiry,
    };
  }
}

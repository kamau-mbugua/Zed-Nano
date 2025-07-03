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

  Data({
    this.token,
    this.group,
    this.userName,
    this.email,
    this.storeName,
    this.packagePaidStatus,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      token: json['token'] as String?,
      group: json['group'] as String?,
      userName: json['userName'] as String?,
      email: json['email'] as String?,
      storeName: json['storeName'] as String?,
      packagePaidStatus: json['packagePaidStatus'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'group': group,
      'userName': userName,
      'email': email,
      'storeName': storeName,
      'packagePaidStatus': packagePaidStatus,
    };
  }
}
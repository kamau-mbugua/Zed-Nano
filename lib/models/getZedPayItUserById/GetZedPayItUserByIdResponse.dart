class GetZedPayItUserByIdResponse {
  final String status;
  final String message;
  final ZedPayItUserData data;

  GetZedPayItUserByIdResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetZedPayItUserByIdResponse.fromJson(Map<String, dynamic> json) {
    return GetZedPayItUserByIdResponse(
      status: json['status'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: ZedPayItUserData.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }

  bool get isSuccess => status.toLowerCase() == 'success';
}

class ZedPayItUserData {
  final String id;
  final String userEmail;
  final String userPhone;
  final String firstName;
  final String secondName;
  final String userName;
  final String schoolLogoPath;
  final String userRole;
  final String dateAdded;
  final String userStatus;
  final bool allowedReceiptReprinting;

  ZedPayItUserData({
    required this.id,
    required this.userEmail,
    required this.userPhone,
    required this.firstName,
    required this.secondName,
    required this.userName,
    required this.schoolLogoPath,
    required this.userRole,
    required this.dateAdded,
    required this.userStatus,
    required this.allowedReceiptReprinting,
  });

  factory ZedPayItUserData.fromJson(Map<String, dynamic> json) {
    return ZedPayItUserData(
      id: json['_id'] as String? ?? '',
      userEmail: json['userEmail'] as String? ?? '',
      userPhone: json['userPhone'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      secondName: json['secondName'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      schoolLogoPath: json['schoolLogoPath'] as String? ?? '',
      userRole: json['userRole'] as String? ?? '',
      dateAdded: json['dateAdded'] as String? ?? '',
      userStatus: json['userStatus'] as String? ?? '',
      allowedReceiptReprinting: json['allowedReceiptReprinting'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'firstName': firstName,
      'secondName': secondName,
      'userName': userName,
      'schoolLogoPath': schoolLogoPath,
      'userRole': userRole,
      'dateAdded': dateAdded,
      'userStatus': userStatus,
      'allowedReceiptReprinting': allowedReceiptReprinting,
    };
  }

  /// Get full name by combining first and second name
  String get fullName => '${firstName} $secondName'.trim();

  /// Get display name (userName if available, otherwise full name)
  String get displayName => userName.isNotEmpty ? userName : fullName;

  /// Check if user has a profile image
  bool get hasProfileImage => schoolLogoPath.isNotEmpty;
}

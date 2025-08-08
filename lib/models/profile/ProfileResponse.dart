class ProfileResponse {

  ProfileResponse({
    this.status,
    this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      status: json['Status'] as String?,
      data: json['data'] != null 
          ? ProfileData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
  final String? status;
  final ProfileData? data;
}

class ProfileData {

  ProfileData({
    this.firstName,
    this.secondName,
    this.userName,
    this.email,
    this.phoneNumber,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      firstName: json['first_name'] as String?,
      secondName: json['seconde_name'] as String?,
      userName: json['user_name'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
    );
  }
  final String? firstName;
  final String? secondName;
  final String? userName;
  final String? email;
  final String? phoneNumber;

  String get fullName => '${firstName ?? ''} ${secondName ?? ''}'.trim();
  String get displayUserName => '@${userName ?? ''}';
}

class GetBusinessRolesResponse {

  GetBusinessRolesResponse({
    this.status,
    this.message,
    this.data,
  });

  factory GetBusinessRolesResponse.fromJson(Map<String, dynamic> json) {
    return GetBusinessRolesResponse(
      status: json['Status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BusinessRole.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  final String? status;
  final String? message;
  final List<BusinessRole>? data;

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class BusinessRole {

  BusinessRole({
    this.type,
    this.name,
  });

  factory BusinessRole.fromJson(Map<String, dynamic> json) {
    return BusinessRole(
      type: json['type'] as String?,
      name: json['name'] as String?,
    );
  }
  final String? type;
  final String? name;

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'name': name,
    };
  }
}

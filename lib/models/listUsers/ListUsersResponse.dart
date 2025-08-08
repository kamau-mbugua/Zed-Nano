class ListUsersResponse {

  ListUsersResponse({
    this.status,
    this.message,
    this.data,
    this.count,
    this.page,
    this.limit,
  });

  factory ListUsersResponse.fromJson(Map<String, dynamic> json) {
    return ListUsersResponse(
      status: json['Status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ListUserData.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: json['count'] as int?,
      page: json['page'] as int?,
      limit: json['limit'] as int?,
    );
  }
  final String? status;
  final String? message;
  final List<ListUserData>? data;
  final int? count;
  final int? page;
  final int? limit;

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
      'count': count,
      'page': page,
      'limit': limit,
    };
  }
}

class ListUserData {

  ListUserData({
    this.id,
    this.userId,
    this.userRole,
    this.userStatus,
    this.dateAdded,
    this.addedBy,
    this.firstName,
    this.secondName,
    this.userName,
    this.userEmail,
    this.userPhone,
    this.createdAt,
    this.updatedAt,
    this.branches,
    this.branchCount,
    this.storeName,
    this.createdByName,
    this.assignedModules,
  });

  factory ListUserData.fromJson(Map<String, dynamic> json) {
    return ListUserData(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      userRole: json['userRole'] as String?,
      userStatus: json['userStatus'] as String?,
      dateAdded: json['dateAdded'] as String?,
      addedBy: json['addedBy'] as String?,
      firstName: json['firstName'] as String?,
      secondName: json['secondName'] as String?,
      userName: json['userName'] as String?,
      userEmail: json['userEmail'] as String?,
      userPhone: json['userPhone'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      branches: (json['branches'] as List<dynamic>?)
          ?.map((e) => UserBranch.fromJson(e as Map<String, dynamic>))
          .toList(),
      branchCount: json['branchCount'] as int?,
      storeName: json['storeName'] as String?,
      createdByName: json['addedBy'] as String?,
      assignedModules: json['assignedModules'] as List<dynamic>?,
    );
  }
  final String? id;
  final String? userId;
  final String? userRole;
  final String? userStatus;
  final String? dateAdded;
  final String? addedBy;
  final String? firstName;
  final String? secondName;
  final String? userName;
  final String? userEmail;
  final String? userPhone;
  final String? createdAt;
  final String? updatedAt;
  final List<UserBranch>? branches;
  final int? branchCount;
  final String? storeName;
  final String? createdByName;
  final List<dynamic>? assignedModules;

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'userRole': userRole,
      'userStatus': userStatus,
      'dateAdded': dateAdded,
      'addedBy': addedBy,
      'firstName': firstName,
      'secondName': secondName,
      'userName': userName,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'branches': branches?.map((e) => e.toJson()).toList(),
      'branchCount': branchCount,
      'storeName': storeName,
      'createdByName': createdByName,
      'assignedModules': assignedModules,
    };
  }

  String get fullName => '$firstName $secondName';

}

class UserBranch {

  UserBranch({
    this.id,
    this.branchName,
  });

  factory UserBranch.fromJson(Map<String, dynamic> json) {
    return UserBranch(
      id: json['_id'] as String?,
      branchName: json['branchName'] as String?,
    );
  }
  final String? id;
  final String? branchName;

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'branchName': branchName,
    };
  }
}

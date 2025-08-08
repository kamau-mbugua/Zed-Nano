class BranchTerminalsResponse {

  BranchTerminalsResponse({
    this.data,
  });

  factory BranchTerminalsResponse.fromJson(Map<String, dynamic> json) {
    return BranchTerminalsResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BranchTerminalsData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  final List<BranchTerminalsData>? data;

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class BranchTerminalsData {

  BranchTerminalsData({
    this.alias,
    this.approvedBy,
    this.branchCode,
    this.branchId,
    this.branchName,
    this.businessID,
    this.businessName,
    this.createdAt,
    this.createdBy,
    this.dateCreated,
    this.dateDeactivated,
    this.dateModified,
    this.deAssignedBy,
    this.deactivationCode,
    this.deactivationDescription,
    this.deviceModel,
    this.equitel,
    this.id,
    this.modifiedBy,
    this.payIt,
    this.paybill,
    this.pushyToken,
    this.requestedBy,
    this.storeId,
    this.terminalSerialNumber,
    this.terminalStatus,
    this.till,
    this.tillPaybill,
    this.transferredBy,
    this.updatedAt,
    this.userId,
    this.v,
    this.vooma,
  });

  factory BranchTerminalsData.fromJson(Map<String, dynamic> json) {
    return BranchTerminalsData(
      alias: json['alias'] as String?,
      approvedBy: json['approvedBy'] as String?,
      branchCode: json['branchCode'] as String?,
      branchId: json['branchId'] as String?,
      branchName: json['branchName'] as String?,
      businessID: json['businessID'] as String?,
      businessName: json['businessName'] as String?,
      createdAt: json['createdAt'] as String?,
      createdBy: json['createdBy'] as String?,
      dateCreated: json['dateCreated'] as String?,
      dateDeactivated: json['dateDeactivated'] as String?,
      dateModified: json['dateModified'] as String?,
      deAssignedBy: json['deAssignedBy'] as String?,
      deactivationCode: json['deactivationCode'] as String?,
      deactivationDescription: json['deactivationDescription'] as String?,
      deviceModel: json['deviceModel'] as String?,
      equitel: json['Equitel'] as String?,
      id: json['_id'] as String?,
      modifiedBy: json['modifiedBy'] as String?,
      payIt: json['payIt'] as bool?,
      paybill: json['Paybill'] as String?,
      pushyToken: json['pushyToken'] as String?,
      requestedBy: json['requestedBy'] as String?,
      storeId: json['storeId'] as String?,
      terminalSerialNumber: json['terminalSerialNumber'] as String?,
      terminalStatus: json['terminalStatus'] as String?,
      till: json['Till'] as String?,
      tillPaybill: json['till_paybill'] as String?,
      transferredBy: json['transferredBy'] as String?,
      updatedAt: json['updatedAt'] as String?,
      userId: json['userId'] as String?,
      v: json['__v'] as int?,
      vooma: json['Vooma'] as String?,
    );
  }
  final String? alias;
  final String? approvedBy;
  final String? branchCode;
  final String? branchId;
  final String? branchName;
  final String? businessID;
  final String? businessName;
  final String? createdAt;
  final String? createdBy;
  final String? dateCreated;
  final String? dateDeactivated;
  final String? dateModified;
  final String? deAssignedBy;
  final String? deactivationCode;
  final String? deactivationDescription;
  final String? deviceModel;
  final String? equitel;
  final String? id;
  final String? modifiedBy;
  final bool? payIt;
  final String? paybill;
  final String? pushyToken;
  final String? requestedBy;
  final String? storeId;
  final String? terminalSerialNumber;
  final String? terminalStatus;
  final String? till;
  final String? tillPaybill;
  final String? transferredBy;
  final String? updatedAt;
  final String? userId;
  final int? v;
  final String? vooma;

  Map<String, dynamic> toJson() {
    return {
      'alias': alias,
      'approvedBy': approvedBy,
      'branchCode': branchCode,
      'branchId': branchId,
      'branchName': branchName,
      'businessID': businessID,
      'businessName': businessName,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'dateCreated': dateCreated,
      'dateDeactivated': dateDeactivated,
      'dateModified': dateModified,
      'deAssignedBy': deAssignedBy,
      'deactivationCode': deactivationCode,
      'deactivationDescription': deactivationDescription,
      'deviceModel': deviceModel,
      'Equitel': equitel,
      '_id': id,
      'modifiedBy': modifiedBy,
      'payIt': payIt,
      'Paybill': paybill,
      'pushyToken': pushyToken,
      'requestedBy': requestedBy,
      'storeId': storeId,
      'terminalSerialNumber': terminalSerialNumber,
      'terminalStatus': terminalStatus,
      'Till': till,
      'till_paybill': tillPaybill,
      'transferredBy': transferredBy,
      'updatedAt': updatedAt,
      'userId': userId,
      '__v': v,
      'Vooma': vooma,
    };
  }
}

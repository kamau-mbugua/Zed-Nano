class ListBusinessCategoryResponse {

  ListBusinessCategoryResponse({
    this.status,
    this.message,
    this.categories,
  });

  factory ListBusinessCategoryResponse.fromJson(Map<String, dynamic> json) {
    return ListBusinessCategoryResponse(
      status: json['Status'] as String?,
      message: json['message'] as String?,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => BusinessCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  final String? status;
  final String? message;
  final List<BusinessCategory>? categories;

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'message': message,
      'categories': categories?.map((e) => e.toJson()).toList(),
    };
  }
}

class BusinessCategory {

  BusinessCategory({
    this.id,
    this.categoryId,
    this.categoryName,
    this.categoryDescription,
    this.categoryStatus,
    this.dateCreated,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory BusinessCategory.fromJson(Map<String, dynamic> json) {
    return BusinessCategory(
      id: json['_id'] as String?,
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
      categoryDescription: json['categoryDescription'] as String?,
      categoryStatus: json['categoryStatus'] as String?,
      dateCreated: json['dateCreated'] as String?,
      createdBy: json['createdBy'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
    );
  }
  final String? id;
  final String? categoryId;
  final String? categoryName;
  final String? categoryDescription;
  final String? categoryStatus;
  final String? dateCreated;
  final String? createdBy;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryDescription': categoryDescription,
      'categoryStatus': categoryStatus,
      'dateCreated': dateCreated,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}
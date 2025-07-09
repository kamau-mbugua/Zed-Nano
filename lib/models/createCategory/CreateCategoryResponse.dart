class CreateCategoryResponse {
  final String? status;
  final String? message;
  final CategoryData? data;

  CreateCategoryResponse({
    this.status,
    this.message,
    this.data,
  });

  factory CreateCategoryResponse.fromJson(Map<String, dynamic> json) {
    return CreateCategoryResponse(
      status: json['Status'] as String?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? CategoryData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class CategoryData {
  final String? businessID;
  final String? categoryCode;
  final String? categoryName;
  final String? categoryDescription;
  final String? productService;
  final bool? subCategory;
  final List<dynamic>? subCategories;
  final String? dateCreated;
  final String? categoryState;
  final String? createdAt;
  final String? createdBy;
  final String? modifiedAt;
  final String? id;
  final String? dateUpdated;
  final String? updatedAt;
  final int? v;

  CategoryData({
    this.businessID,
    this.categoryCode,
    this.categoryName,
    this.categoryDescription,
    this.productService,
    this.subCategory,
    this.subCategories,
    this.dateCreated,
    this.categoryState,
    this.createdAt,
    this.createdBy,
    this.modifiedAt,
    this.id,
    this.dateUpdated,
    this.updatedAt,
    this.v,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      businessID: json['businessID'] as String?,
      categoryCode: json['categoryCode'] as String?,
      categoryName: json['categoryName'] as String?,
      categoryDescription: json['categoryDescription'] as String?,
      productService: json['productService'] as String?,
      subCategory: json['subCategory'] as bool?,
      subCategories: json['subCategories'] as List<dynamic>?,
      dateCreated: json['dateCreated'] as String?,
      categoryState: json['categoryState'] as String?,
      createdAt: json['createdAt'] as String?,
      createdBy: json['createdBy'] as String?,
      modifiedAt: json['modifiedAt'] as String?,
      id: json['_id'] as String?,
      dateUpdated: json['dateUpdated'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'businessID': businessID,
      'categoryCode': categoryCode,
      'categoryName': categoryName,
      'categoryDescription': categoryDescription,
      'productService': productService,
      'subCategory': subCategory,
      'subCategories': subCategories,
      'dateCreated': dateCreated,
      'categoryState': categoryState,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'modifiedAt': modifiedAt,
      '_id': id,
      'dateUpdated': dateUpdated,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}
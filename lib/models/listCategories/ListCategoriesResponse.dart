class ListCategoriesResponse {
  final String? status;
  final String? message;
  final List<ProductCategoryData>? data;
  final int? count;

  ListCategoriesResponse({
    this.status,
    this.message,
    this.data,
    this.count,
  });

  factory ListCategoriesResponse.fromJson(Map<String, dynamic> json) {
    return ListCategoriesResponse(
      status: json['Status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ProductCategoryData.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: json['count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
      'count': count,
    };
  }
}

class ProductCategoryData {
  final String? id;
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
  final String? dateUpdated;
  final String? updatedAt;
  final int? v;
  final String? imagePath;
  final String? thumbailImagePath;
  final String? modifiedByName;

  ProductCategoryData({
    this.id,
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
    this.dateUpdated,
    this.updatedAt,
    this.v,
    this.imagePath,
    this.thumbailImagePath,
    this.modifiedByName,
  });

  factory ProductCategoryData.fromJson(Map<String, dynamic> json) {
    return ProductCategoryData(
      id: json['_id'] as String?,
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
      dateUpdated: json['dateUpdated'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
      imagePath: json['imagePath'] as String?,
      thumbailImagePath: json['thumbailImagePath'] as String?,
      modifiedByName: json['modifiedByName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
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
      'dateUpdated': dateUpdated,
      'updatedAt': updatedAt,
      '__v': v,
      'imagePath': imagePath,
      'thumbailImagePath': thumbailImagePath,
      'modifiedByName': modifiedByName,
    };
  }
}
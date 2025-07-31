class ListProductsResponse {
  final String? status;
  final String? message;
  final int? count;
  final List<ProductData>? data;

  ListProductsResponse({
    this.status,
    this.message,
    this.count,
    this.data,
  });

  factory ListProductsResponse.fromJson(Map<String, dynamic> json) {
    return ListProductsResponse(
      status: json['Status'] as String?,
      message: json['message'] as String?,
      count: json['count'] as int?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ProductData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'message': message,
      'count': count,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class ProductData {
  final String? businessID;
  final String? productCode;
  final String? productCategory;
  final String? productService;
  final String? productDescription;
  final int? reorderLevel;
  final String? createdAt;
  final String? createdBy;
  final String? priceStatus;
  final String? unitOfMeasure;
  final String? serviceType;
  final bool? isWeightedProduct;
  final bool? consumable;
  final bool? requireSettlement;
  final List<dynamic>? settlements;
  final bool? isRawMaterial;
  final List<dynamic>? additionalImages;
  final bool? saccoCollects;
  final bool? canBeBookedOnline;
  final List<dynamic>? additionalServices;
  final String? updatedAt;
  final int? v;
  final String? id;
  final String? productId;
  final String? variationKeyId;
  final String? productName;
  final String? productState;
  final num? buyingPrice;
  final int? productPrice;
  final num? discountedPrice;
  final String? variationKey;
  final String? variantCode;
  final String? currency;
  final String? createdByName;
  final String? modifiedBy;
  final String? modifiedByName;
  final String? accountId;
  final String? glAccountName;
  final String? imagePath;
  final String? thumbailImagePath;
  final double? quantityInStock;

  ProductData({
    this.businessID,
    this.productCode,
    this.productCategory,
    this.productService,
    this.productDescription,
    this.reorderLevel,
    this.createdAt,
    this.createdBy,
    this.priceStatus,
    this.unitOfMeasure,
    this.serviceType,
    this.isWeightedProduct,
    this.consumable,
    this.requireSettlement,
    this.settlements,
    this.isRawMaterial,
    this.additionalImages,
    this.saccoCollects,
    this.canBeBookedOnline,
    this.additionalServices,
    this.updatedAt,
    this.v,
    this.id,
    this.productId,
    this.variationKeyId,
    this.productName,
    this.productState,
    this.buyingPrice,
    this.productPrice,
    this.discountedPrice,
    this.variationKey,
    this.variantCode,
    this.currency,
    this.createdByName,
    this.modifiedBy,
    this.modifiedByName,
    this.accountId,
    this.glAccountName,
    this.imagePath,
    this.thumbailImagePath,
    this.quantityInStock,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      businessID: json['businessID'] as String?,
      productCode: json['productCode'] as String?,
      productCategory: json['productCategory'] as String?,
      productService: json['productService'] as String?,
      productDescription: json['productDescription'] as String?,
      reorderLevel: json['reorderLevel'] as int?,
      createdAt: json['createdAt'] as String?,
      createdBy: json['createdBy'] as String?,
      priceStatus: json['priceStatus'] as String?,
      unitOfMeasure: json['unitOfMeasure'] as String?,
      serviceType: json['serviceType'] as String?,
      isWeightedProduct: json['isWeightedProduct'] as bool?,
      consumable: json['consumable'] as bool?,
      requireSettlement: json['require_settlement'] as bool?,
      settlements: json['settlements'] as List<dynamic>?,
      isRawMaterial: json['isRawMaterial'] as bool?,
      additionalImages: json['additionalImages'] as List<dynamic>?,
      saccoCollects: json['saccoCollects'] as bool?,
      canBeBookedOnline: json['canBeBookedOnline'] as bool?,
      additionalServices: json['additionalServices'] as List<dynamic>?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
      id: json['_id'] as String?,
      productId: json['productId'] as String?,
      variationKeyId: json['variationKeyId'] as String?,
      productName: json['productName'] as String?,
      productState: json['productState'] as String?,
      buyingPrice: json['buyingPrice'] as num?,
      productPrice: json['productPrice'] != null ? (json['productPrice'] as num).toInt() : null,
      discountedPrice: json['discountedPrice'] as num?,
      variationKey: json['variationKey'] as String?,
      variantCode: json['variantCode'] as String?,
      currency: json['currency'] as String?,
      createdByName: json['createdByName'] as String?,
      modifiedBy: json['modifiedBy'] as String?,
      modifiedByName: json['modifiedByName'] as String?,
      accountId: json['accountId'] as String?,
      glAccountName: json['glAccountName'] as String?,
      imagePath: json['imagePath'] as String?,
      thumbailImagePath: json['thumbailImagePath'] as String?,
      quantityInStock: (json['quantityInStock'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'businessID': businessID,
      'productCode': productCode,
      'productCategory': productCategory,
      'productService': productService,
      'productDescription': productDescription,
      'reorderLevel': reorderLevel,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'priceStatus': priceStatus,
      'unitOfMeasure': unitOfMeasure,
      'serviceType': serviceType,
      'isWeightedProduct': isWeightedProduct,
      'consumable': consumable,
      'require_settlement': requireSettlement,
      'settlements': settlements,
      'isRawMaterial': isRawMaterial,
      'additionalImages': additionalImages,
      'saccoCollects': saccoCollects,
      'canBeBookedOnline': canBeBookedOnline,
      'additionalServices': additionalServices,
      'updatedAt': updatedAt,
      '__v': v,
      '_id': id,
      'productId': productId,
      'variationKeyId': variationKeyId,
      'productName': productName,
      'productState': productState,
      'buyingPrice': buyingPrice,
      'productPrice': productPrice,
      'discountedPrice': discountedPrice,
      'variationKey': variationKey,
      'variantCode': variantCode,
      'currency': currency,
      'createdByName': createdByName,
      'modifiedBy': modifiedBy,
      'modifiedByName': modifiedByName,
      'accountId': accountId,
      'glAccountName': glAccountName,
      'imagePath': imagePath,
      'thumbailImagePath': thumbailImagePath,
      'quantityInStock': quantityInStock,
    };
  }
}
class GetActiveStockTakeResponse {

  GetActiveStockTakeResponse({
    this.status,
    this.message,
    this.data,
    this.count,
  });

  factory GetActiveStockTakeResponse.fromJson(Map<String, dynamic> json) {
    return GetActiveStockTakeResponse(
      status: json['Status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => StockTakeProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: json['count'] as int?,
    );
  }
  final String? status;
  final String? message;
  final List<StockTakeProduct>? data;
  final int? count;

  Map<String, dynamic> toJson() => {
    'Status': status,
    'message': message,
    'data': data?.map((e) => e.toJson()).toList(),
    'count': count,
  };
}


class StockTakeProduct {

  StockTakeProduct({
    this.businessID,
    this.productCategory,
    this.productService,
    this.productDescription,
    this.productState,
    this.createdAt,
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
    this.branchTotals,
    this.storeTotals,
    this.additionalServices,
    this.updatedAt,
    this.v,
    this.id,
    this.productId,
    this.variationKeyId,
    this.productName,
    this.pricingStatus,
    this.initialStock,
    this.buyingPrice,
    this.productPrice,
    this.discountedPrice,
    this.variationKey,
    this.variantCode,
    this.expectedQuantity,
    this.actualQuantity,
    this.soldQuantity,
    this.varianceQuantity,
    this.imagePath,
  });

  factory StockTakeProduct.fromJson(Map<String, dynamic> json) {
    return StockTakeProduct(
      businessID: json['businessID'] as String?,
      productCategory: json['productCategory'] as String?,
      productService: json['productService'] as String?,
      productDescription: json['productDescription'] as String?,
      productState: json['productState'] as String?,
      createdAt: json['createdAt'] as String?,
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
      branchTotals: (json['branchTotals'] as List<dynamic>?)
          ?.map((e) => BranchTotal.fromJson(e as Map<String, dynamic>))
          .toList(),
      storeTotals: (json['storeTotals'] as List<dynamic>?)
          ?.map((e) => StoreTotal.fromJson(e as Map<String, dynamic>))
          .toList(),
      additionalServices: json['additionalServices'] as List<dynamic>?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
      id: json['_id'] as String?,
      productId: json['productId'] as String?,
      variationKeyId: json['variationKeyId'] as String?,
      productName: json['productName'] as String?,
      pricingStatus: json['pricingStatus'] as String?,
      initialStock: json['InitialStock'] as int?,
      buyingPrice: json['buyingPrice'] as int?,
      productPrice: json['productPrice'] as int?,
      discountedPrice: json['discountedPrice'] as int?,
      variationKey: json['variationKey'] as String?,
      variantCode: json['variantCode'] as String?,
      expectedQuantity: json['expectedQuantity'] as int?,
      actualQuantity: json['actualQuantity'] as int?,
      soldQuantity: json['soldQuantity'] as int?,
      varianceQuantity: json['varianceQuantity'] as int?,
      imagePath: json['imagePath'] as String?,
    );
  }
  final String? businessID;
  final String? productCategory;
  final String? productService;
  final String? productDescription;
  final String? productState;
  final String? createdAt;
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
  final List<BranchTotal>? branchTotals;
  final List<StoreTotal>? storeTotals;
  final List<dynamic>? additionalServices;
  final String? updatedAt;
  final int? v;
  final String? id;
  final String? productId;
  final String? variationKeyId;
  final String? productName;
  final String? pricingStatus;
  final int? initialStock;
  final int? buyingPrice;
  final int? productPrice;
  final int? discountedPrice;
  final String? variationKey;
  final String? variantCode;
  final int? expectedQuantity;
  final int? actualQuantity;
  final int? soldQuantity;
  final int? varianceQuantity;
  final String? imagePath;

  Map<String, dynamic> toJson() => {
    'businessID': businessID,
    'productCategory': productCategory,
    'productService': productService,
    'productDescription': productDescription,
    'productState': productState,
    'createdAt': createdAt,
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
    'branchTotals': branchTotals?.map((e) => e.toJson()).toList(),
    'storeTotals': storeTotals?.map((e) => e.toJson()).toList(),
    'additionalServices': additionalServices,
    'updatedAt': updatedAt,
    '__v': v,
    '_id': id,
    'productId': productId,
    'variationKeyId': variationKeyId,
    'productName': productName,
    'pricingStatus': pricingStatus,
    'InitialStock': initialStock,
    'buyingPrice': buyingPrice,
    'productPrice': productPrice,
    'discountedPrice': discountedPrice,
    'variationKey': variationKey,
    'variantCode': variantCode,
    'expectedQuantity': expectedQuantity,
    'actualQuantity': actualQuantity,
    'soldQuantity': soldQuantity,
    'varianceQuantity': varianceQuantity,
    'imagePath': imagePath,
  };
}

class BranchTotal {

  BranchTotal({
    this.branchId,
    this.total,
    this.doNotCalculate,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  factory BranchTotal.fromJson(Map<String, dynamic> json) {
    return BranchTotal(
      branchId: json['branchId'] as String?,
      total: json['total'] as int?,
      doNotCalculate: json['doNotCalculate'] as bool?,
      id: json['_id'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }
  final String? branchId;
  final int? total;
  final bool? doNotCalculate;
  final String? id;
  final String? createdAt;
  final String? updatedAt;

  Map<String, dynamic> toJson() => {
    'branchId': branchId,
    'total': total,
    'doNotCalculate': doNotCalculate,
    '_id': id,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}

class StoreTotal {

  StoreTotal({
    this.storeId,
    this.total,
    this.doNotCalculate,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  factory StoreTotal.fromJson(Map<String, dynamic> json) {
    return StoreTotal(
      storeId: json['storeId'] as String?,
      total: json['total'] as int?,
      doNotCalculate: json['doNotCalculate'] as bool?,
      id: json['_id'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }
  final String? storeId;
  final int? total;
  final bool? doNotCalculate;
  final String? id;
  final String? createdAt;
  final String? updatedAt;

  Map<String, dynamic> toJson() => {
    'storeId': storeId,
    'total': total,
    'doNotCalculate': doNotCalculate,
    '_id': id,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
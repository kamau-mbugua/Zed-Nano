class GetAllActiveStockResponse {
  final String? status;
  final String? message;
  final StockStatusSummary? stockStatusSummary;
  final List<ActiveStockProduct>? data;
  final List<ActiveStockProduct>? inStockProducts;
  final List<ActiveStockProduct>? lowStockProducts;
  final List<ActiveStockProduct>? outOfStockProducts;
  final int? count;
  final int? inStockProductsCount;
  final int? lowStockProductsCount;
  final int? outOfStockProductsCount;

  GetAllActiveStockResponse({
    this.status,
    this.message,
    this.stockStatusSummary,
    this.data,
    this.count,
    this.inStockProducts,
    this.lowStockProducts,
    this.outOfStockProducts,
    this.inStockProductsCount,
    this.lowStockProductsCount,
    this.outOfStockProductsCount,
  });

  factory GetAllActiveStockResponse.fromJson(Map<String, dynamic> json) {
    return GetAllActiveStockResponse(
      status: json['Status'] as String?,
      message: json['message'] as String?,
      stockStatusSummary: json['stockStatusSummary'] != null
          ? StockStatusSummary.fromJson(json['stockStatusSummary'] as Map<String, dynamic>)
          : null,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ActiveStockProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      inStockProducts: (json['inStockProducts'] as List<dynamic>?)
          ?.map((e) => ActiveStockProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      lowStockProducts: (json['lowStockProducts'] as List<dynamic>?)
          ?.map((e) => ActiveStockProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      outOfStockProducts: (json['outOfStockProducts'] as List<dynamic>?)
          ?.map((e) => ActiveStockProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: json['count'] as int?,
      inStockProductsCount: json['inStockProductsCount'] as int?,
      lowStockProductsCount: json['lowStockProductsCount'] as int?,
      outOfStockProductsCount: json['outOfStockProductsCount'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'Status': status,
    'message': message,
    'stockStatusSummary': stockStatusSummary?.toJson(),
    'data': data?.map((e) => e.toJson()).toList(),
    'inStockProducts': inStockProducts?.map((e) => e.toJson()).toList(),
    'lowStockProducts': lowStockProducts?.map((e) => e.toJson()).toList(),
    'outOfStockProducts': outOfStockProducts?.map((e) => e.toJson()).toList(),
    'count': count,
    'inStockProductsCount': count,
    'lowStockProductsCount': count,
    'outOfStockProductsCount': count,
  };
}

class ActiveStockProduct {
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
  final String? currency;
  final int? inStockQuantity;
  final int? newStock;
  final String? status;
  final int? totalStock;
  final int? sellingPrice;
  final String? lastUpdated;
  final String? stockStatus;

  ActiveStockProduct({
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
    this.currency,
    this.inStockQuantity,
    this.newStock,
    this.status,
    this.totalStock,
    this.sellingPrice,
    this.lastUpdated,
    this.stockStatus,
  });

  factory ActiveStockProduct.fromJson(Map<String, dynamic> json) {
    return ActiveStockProduct(
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
      currency: json['currency'] as String?,
      inStockQuantity: json['inStockQuantity'] as int?,
      newStock: json['newStock'] as int?,
      status: json['status'] as String?,
      totalStock: json['totalStock'] as int?,
      sellingPrice: json['sellingPrice'] as int?,
      lastUpdated: json['lastUpdated'] as String?,
      stockStatus: json['stockStatus'] as String?,
    );
  }

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
    'currency': currency,
    'inStockQuantity': inStockQuantity,
    'newStock': newStock,
    'status': status,
    'totalStock': totalStock,
    'sellingPrice': sellingPrice,
    'lastUpdated': lastUpdated,
    'stockStatus': stockStatus,
  };
}


class StoreTotal {
  final String? storeId;
  final int? total;
  final bool? doNotCalculate;
  final String? id;
  final String? createdAt;
  final String? updatedAt;

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

  Map<String, dynamic> toJson() => {
    'storeId': storeId,
    'total': total,
    'doNotCalculate': doNotCalculate,
    '_id': id,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
class BranchTotal {
  final String? branchId;
  final int? total;
  final bool? doNotCalculate;
  final String? id;
  final String? createdAt;
  final String? updatedAt;

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

  Map<String, dynamic> toJson() => {
    'branchId': branchId,
    'total': total,
    'doNotCalculate': doNotCalculate,
    '_id': id,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}

class StockStatusSummary {
  final int? totalProductsInLowStock;
  final int? totalProductsOutOfStock;

  StockStatusSummary({
    this.totalProductsInLowStock,
    this.totalProductsOutOfStock,
  });

  factory StockStatusSummary.fromJson(Map<String, dynamic> json) {
    return StockStatusSummary(
      totalProductsInLowStock: json['totalProductsInLowStock'] as int?,
      totalProductsOutOfStock: json['totalProductsOutOfStock'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'totalProductsInLowStock': totalProductsInLowStock,
    'totalProductsOutOfStock': totalProductsOutOfStock,
  };
}
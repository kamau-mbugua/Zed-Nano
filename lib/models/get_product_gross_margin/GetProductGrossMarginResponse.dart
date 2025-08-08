class GetProductGrossMarginResponse {

  GetProductGrossMarginResponse({
    this.status,
    this.message,
    this.data,
    this.currency,
    this.count,
    this.totalSales,
    this.quantitiesSoldTotals,
    this.totalCost,
    this.grossMargin,
  });

  factory GetProductGrossMarginResponse.fromJson(Map<String, dynamic> json) {
    return GetProductGrossMarginResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => GetProductGrossMarginData.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
      currency: json['currency'] as String?,
      count: json['count'] as int?,
      totalSales: _parseDouble(json['totalSales']),
      quantitiesSoldTotals: _parseDouble(json['quantitiesSoldTotals']),
      totalCost: _parseDouble(json['totalCost']),
      grossMargin: _parseDouble(json['grossMargin']),
    );
  }
  final String? status;
  final String? message;
  final List<GetProductGrossMarginData>? data;
  final String? currency;
  final int? count;
  final double? totalSales;
  final double? quantitiesSoldTotals;
  final double? totalCost;
  final double? grossMargin;

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((item) => item.toJson()).toList(),
      'currency': currency,
      'count': count,
      'totalSales': totalSales,
      'quantitiesSoldTotals': quantitiesSoldTotals,
      'totalCost': totalCost,
      'grossMargin': grossMargin,
    };
  }

  // Helper method to safely parse numbers to double
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

class GetProductGrossMarginData {

  GetProductGrossMarginData({
    this.totalSales,
    this.quantitySold,
    this.discount,
    this.productId,
    this.sellingPrice,
    this.productName,
    this.buyingPrice,
    this.totalCost,
    this.grossMargin,
    this.imageUrl,
  });

  factory GetProductGrossMarginData.fromJson(Map<String, dynamic> json) {
    return GetProductGrossMarginData(
      totalSales: _parseDouble(json['totalSales']),
      quantitySold: _parseDouble(json['quantitySold']),
      discount: _parseDouble(json['discount']),
      productId: json['productId'] as String?,
      sellingPrice: _parseDouble(json['sellingPrice']),
      productName: json['productName'] as String?,
      buyingPrice: _parseDouble(json['buyingPrice']),
      totalCost: _parseDouble(json['totalCost']),
      grossMargin: _parseDouble(json['grossMargin']),
      imageUrl: json['imageUrl'] as String?,
    );
  }
  final double? totalSales;
  final double? quantitySold;
  final double? discount;
  final String? productId;
  final double? sellingPrice;
  final String? productName;
  final double? buyingPrice;
  final double? totalCost;
  final double? grossMargin;
  final String? imageUrl;

  Map<String, dynamic> toJson() {
    return {
      'totalSales': totalSales,
      'quantitySold': quantitySold,
      'discount': discount,
      'productId': productId,
      'sellingPrice': sellingPrice,
      'productName': productName,
      'buyingPrice': buyingPrice,
      'totalCost': totalCost,
      'grossMargin': grossMargin,
      'imageUrl': imageUrl,
    };
  }

  // Helper method to safely parse numbers to double
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  // Helper method to calculate gross margin percentage
  double get grossMarginPercentage {
    if (totalSales == null || totalSales == 0) return 0;
    return ((grossMargin ?? 0) / (totalSales ?? 1)) * 100;
  }

  // Helper method to check if the product is profitable
  bool get isProfitable => (grossMargin ?? 0) > 0;
}

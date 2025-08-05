class ProductTotalCostResponse {
  final String? status;
  final String? message;
  final List<ProductTotalCostData>? data;
  final String? currency;
  final double? quantitiesSoldTotals;
  final double? totalSales;

  ProductTotalCostResponse({
    this.status,
    this.message,
    this.data,
    this.currency,
    this.quantitiesSoldTotals,
    this.totalSales,
  });

  factory ProductTotalCostResponse.fromJson(Map<String, dynamic> json) {
    return ProductTotalCostResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => ProductTotalCostData.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
      currency: json['currency'] as String?,
        quantitiesSoldTotals: json['quantitiesSoldTotals'] as double?,
        totalSales: json['totalSales'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((item) => item.toJson()).toList(),
      'currency': currency,
    };
  }
}

class ProductTotalCostData {
  final double? totalSales;
  final double? quantitySold;
  final String? productName;
  final double? sellingPrice;
  final double? buyingPrice;
  final double? totalCost;
  final String? imageUrl;

  ProductTotalCostData({
    this.totalSales,
    this.quantitySold,
    this.productName,
    this.sellingPrice,
    this.buyingPrice,
    this.totalCost,
    this.imageUrl,
  });

  factory ProductTotalCostData.fromJson(Map<String, dynamic> json) {
    return ProductTotalCostData(
      totalSales: _parseDouble(json['totalSales']),
      quantitySold: _parseDouble(json['quantitySold']),
      productName: json['productName'] as String?,
      sellingPrice: _parseDouble(json['sellingPrice']),
      buyingPrice: _parseDouble(json['buyingPrice']),
      totalCost: _parseDouble(json['totalCost']),
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalSales': totalSales,
      'quantitySold': quantitySold,
      'productName': productName,
      'sellingPrice': sellingPrice,
      'buyingPrice': buyingPrice,
      'totalCost': totalCost,
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
}

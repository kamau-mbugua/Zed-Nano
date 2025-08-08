class QuantitiesSoldResponse {

  QuantitiesSoldResponse({
    this.status,
    this.message,
    this.data,
    this.quantityInStockTotal,
    this.quantitiesSoldTotals,
  });

  factory QuantitiesSoldResponse.fromJson(Map<String, dynamic> json) {
    return QuantitiesSoldResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => QuantitiesSoldData.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
        quantityInStockTotal: (json['quantityInStockTotal'] as num?)?.toDouble(),
        quantitiesSoldTotals: (json['quantitiesSoldTotals']as num?)?.toDouble(),
    );
  }
  final String? status;
  final String? message;
  final double? quantityInStockTotal;
  final double? quantitiesSoldTotals;
  final List<QuantitiesSoldData>? data;

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class QuantitiesSoldData {

  QuantitiesSoldData({
    this.totalSales,
    this.quantitySold,
    this.productName,
    this.sellingPrice,
    this.inStock,
    this.imageUrl,
  });

  factory QuantitiesSoldData.fromJson(Map<String, dynamic> json) {
    return QuantitiesSoldData(
      totalSales: _parseDouble(json['totalSales']),
      quantitySold: _parseDouble(json['quantitySold']),
      productName: json['productName'] as String?,
      sellingPrice: _parseDouble(json['sellingPrice']),
      inStock: json['inStock'] as int?,
      imageUrl: json['imageUrl'] as String?,
    );
  }
  final double? totalSales;
  final double? quantitySold;
  final String? productName;
  final double? sellingPrice;
  final int? inStock;
  final String? imageUrl;

  Map<String, dynamic> toJson() {
    return {
      'totalSales': totalSales,
      'quantitySold': quantitySold,
      'productName': productName,
      'sellingPrice': sellingPrice,
      'inStock': inStock,
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

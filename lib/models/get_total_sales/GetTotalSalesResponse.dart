class GetTotalSalesResponse {

  GetTotalSalesResponse({
    this.status,
    this.message,
    this.quantitiesSoldTotals,
    this.totalSales,
    this.data,
  });

  factory GetTotalSalesResponse.fromJson(Map<String, dynamic> json) {
    return GetTotalSalesResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      quantitiesSoldTotals: _parseDouble(json['quantitiesSoldTotals']),
      totalSales: _parseDouble(json['totalSales']),
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => GetTotalSalesData.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
  final String? status;
  final String? message;
  final double? quantitiesSoldTotals;
  final double? totalSales;
  final List<GetTotalSalesData>? data;

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'quantitiesSoldTotals': quantitiesSoldTotals,
      'totalSales': totalSales,
      'data': data?.map((item) => item.toJson()).toList(),
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

class GetTotalSalesData {

  GetTotalSalesData({
    this.totalSales,
    this.quantitySold,
    this.discount,
    this.productName,
    this.imageUrl,
    this.sellingPrice,
  });

  factory GetTotalSalesData.fromJson(Map<String, dynamic> json) {
    return GetTotalSalesData(
      totalSales: _parseDouble(json['totalSales']),
      quantitySold: _parseDouble(json['quantitySold']),
      discount: _parseDouble(json['discount']),
      productName: json['productName'] as String?,
      imageUrl: json['imageUrl'] as String?,
      sellingPrice: _parseDouble(json['sellingPrice']),
    );
  }
  final double? totalSales;
  final double? quantitySold;
  final double? discount;
  final String? productName;
  final String? imageUrl;
  final double? sellingPrice;

  Map<String, dynamic> toJson() {
    return {
      'totalSales': totalSales,
      'quantitySold': quantitySold,
      'discount': discount,
      'productName': productName,
      'sellingPrice': sellingPrice,
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

class OpeningClosingResponse {

  OpeningClosingResponse({
    this.message,
    this.data,
    this.pageNumber,
    this.totalItems,
    this.totalPages,
    this.totalOpeningStock,
    this.totalClosingStock,
  });

  factory OpeningClosingResponse.fromJson(Map<String, dynamic> json) {
    return OpeningClosingResponse(
      message: json['message'] as String?,
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => OpeningClosingData.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
      pageNumber: json['pageNumber'] as int?,
      totalItems: json['totalItems'] as int?,
      totalPages: json['totalPages'] as int?,
      totalOpeningStock: _parseDouble(json['totalOpeningStock']),
      totalClosingStock: _parseDouble(json['totalClosingStock']),
    );
  }
  final String? message;
  final List<OpeningClosingData>? data;
  final int? pageNumber;
  final int? totalItems;
  final int? totalPages;
  final double? totalOpeningStock;
  final double? totalClosingStock;

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data?.map((item) => item.toJson()).toList(),
      'pageNumber': pageNumber,
      'totalItems': totalItems,
      'totalPages': totalPages,
      'totalOpeningStock': totalOpeningStock,
      'totalClosingStock': totalClosingStock,
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

class OpeningClosingData {

  OpeningClosingData({
    this.productId,
    this.productName,
    this.variationKey,
    this.variationKeyId,
    this.openingStock,
    this.quantitySold,
    this.closingStock,
    this.quantityReceived,
    this.quantityVariance,
    this.imageUrl,
  });

  factory OpeningClosingData.fromJson(Map<String, dynamic> json) {
    return OpeningClosingData(
      productId: json['productId'] as String?,
      productName: json['productName'] as String?,
      variationKey: json['variationKey'] as String?,
      variationKeyId: json['variationKeyId'] as String?,
      openingStock: _parseDouble(json['openingStock']),
      quantitySold: _parseDouble(json['quantitySold']),
      closingStock: _parseDouble(json['closingStock']),
      quantityReceived: _parseDouble(json['quantityReceived']),
      quantityVariance: _parseDouble(json['quantityVariance']),
      imageUrl: json['imageUrl'] as String?,
    );
  }
  final String? productId;
  final String? productName;
  final String? variationKey;
  final String? variationKeyId;
  final double? openingStock;
  final double? quantitySold;
  final double? closingStock;
  final double? quantityReceived;
  final double? quantityVariance;
  final String? imageUrl;

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'variationKey': variationKey,
      'variationKeyId': variationKeyId,
      'openingStock': openingStock,
      'quantitySold': quantitySold,
      'closingStock': closingStock,
      'quantityReceived': quantityReceived,
      'quantityVariance': quantityVariance,
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

  // Helper method to get clean product name (removes extra spaces)
  String get cleanProductName {
    return productName?.trim() ?? 'Unknown Product';
  }

  // Helper method to calculate stock movement
  double get stockMovement {
    return (quantityReceived ?? 0) - (quantitySold ?? 0);
  }

  // Helper method to check if there's a stock variance
  bool get hasVariance {
    return (quantityVariance ?? 0) != 0;
  }

  // Helper method to check if stock is balanced
  bool get isStockBalanced {
    final expectedClosing = (openingStock ?? 0) + (quantityReceived ?? 0) - (quantitySold ?? 0);
    return expectedClosing == (closingStock ?? 0);
  }

  // Helper method to get variance status
  String get varianceStatus {
    final variance = quantityVariance ?? 0;
    if (variance > 0) return 'Surplus';
    if (variance < 0) return 'Shortage';
    return 'Balanced';
  }
}

class SalesReportSummaryResponse {
  final String? status;
  final String? message;
  final SalesReportSummaryData? data;

  SalesReportSummaryResponse({
    this.status,
    this.message,
    this.data,
  });

  factory SalesReportSummaryResponse.fromJson(Map<String, dynamic> json) {
    return SalesReportSummaryResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] != null ? SalesReportSummaryData.fromJson(json['data'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class SalesReportSummaryData {
  final double? soldQuantity;
  final double? totalSales;
  final double? totalDiscount;
  final double? totalCostOfGoodsSold;
  final double? grossMargin;
  final String? currency;

  SalesReportSummaryData({
    this.soldQuantity,
    this.totalSales,
    this.totalDiscount,
    this.totalCostOfGoodsSold,
    this.grossMargin,
    this.currency,
  });

  factory SalesReportSummaryData.fromJson(Map<String, dynamic> json) {
    return SalesReportSummaryData(
      soldQuantity: (json['soldQuantity'] as num?)?.toDouble(),
      totalSales: (json['totalSales'] as num?)?.toDouble(),
      totalDiscount: (json['totalDiscount'] as num?)?.toDouble(),
      totalCostOfGoodsSold: (json['totalCostOfGoodsSold'] as num?)?.toDouble(),
      grossMargin: (json['grossMargin'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'soldQuantity': soldQuantity,
      'totalSales': totalSales,
      'totalDiscount': totalDiscount,
      'totalCostOfGoodsSold': totalCostOfGoodsSold,
      'grossMargin': grossMargin,
      'currency': currency,
    };
  }
}

class SalesReportTotalSalesResponse {
  final String? status;
  final String? message;
  final List<SalesReportTotalSalesData>? data;

  SalesReportTotalSalesResponse({
    this.status,
    this.message,
    this.data,
  });

  factory SalesReportTotalSalesResponse.fromJson(Map<String, dynamic> json) {
    return SalesReportTotalSalesResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? (json['data'] as List).map((item) => SalesReportTotalSalesData.fromJson(item as Map<String, dynamic>)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class SalesReportTotalSalesData {
  final double? totalSales;
  final double? quantitySold;
  final double? discount;
  final String? productName;
  final double? sellingPrice;
  final String? imageUrl;

  SalesReportTotalSalesData({
    this.totalSales,
    this.quantitySold,
    this.discount,
    this.productName,
    this.sellingPrice,
    this.imageUrl,
  });

  factory SalesReportTotalSalesData.fromJson(Map<String, dynamic> json) {
    return SalesReportTotalSalesData(
      totalSales: (json['totalSales'] as num?)?.toDouble(),
      quantitySold: (json['quantitySold'] as num?)?.toDouble(),
      discount: (json['discount']as num?)?.toDouble(),
      productName: json['productName'] as String?,
      sellingPrice: (json['sellingPrice'] as num?)?.toDouble(),
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalSales': totalSales,
      'quantitySold': quantitySold,
      'discount': discount,
      'productName': productName,
      'sellingPrice': sellingPrice,
      'imageUrl': imageUrl,
    };
  }
}

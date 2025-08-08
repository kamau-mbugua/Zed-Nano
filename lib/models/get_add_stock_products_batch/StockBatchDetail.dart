class StockBatchDetail {

  StockBatchDetail({
    this.status,
    this.message,
    this.data,
    this.count,
    this.batchHeader,
  });

  factory StockBatchDetail.fromJson(Map<String, dynamic> json) {
    return StockBatchDetail(
      status: json['Status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => StockItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: json['count'] as int?,
      batchHeader: json['batchHeader'] != null
          ? BatchHeader.fromJson(json['batchHeader'] as Map<String, dynamic>)
          : null,
    );
  }
  final String? status;
  final String? message;
  final List<StockItem>? data;
  final int? count;
  final BatchHeader? batchHeader;
}


class StockItem {

  StockItem({
    this.productId,
    this.productName,
    this.imagePath,
    this.category,
    this.inStockQuantity,
    this.newQuantity,
    this.expectedQuantity,
    this.soldQuantity,
    this.buyingPrice,
    this.variance,
    this.newStock,
    this.addedStock,
    this.currency,
  });

  factory StockItem.fromJson(Map<String, dynamic> json) {
    return StockItem(
      productId: json['productId'] as String?,
      productName: json['productName'] as String?,
      imagePath: json['imagePath'] as String?,
      category: json['categoryName'] as String?,
      inStockQuantity: json['inStockQuantity'] as int?,
      newQuantity: json['newQuantity'] as int?,
      expectedQuantity: json['expectedQuantity'] as int?,
      soldQuantity: json['soldQuantity'] as int?,
      buyingPrice: json['buyingPrice'] as int?,
      variance: json['variance'] as int?,
      newStock: json['newStock'] as int?,
      addedStock: json['addedStock'] as int?,
      currency: json['currency'] as String?,
    );
  }
  final String? productId;
  final String? productName;
  final String? imagePath;
  final String? category;
  final int? inStockQuantity;
  final int? newQuantity;
  final int? expectedQuantity;
  final int? soldQuantity;
  final int? buyingPrice;
  final int? variance;
  final int? newStock;
  final int? addedStock;
  final String? currency;
}

// batch_header.dart
class BatchHeader {

  BatchHeader({
    required this.to,
    required this.stockStatus,
    required this.dateCreated,
    required this.createdByName,
    required this.approvedBy,
    required this.dateApproved,
    required this.batchNumber,
  });

  factory BatchHeader.fromJson(Map<String, dynamic> json) {
    return BatchHeader(
      to: json['to'] as String,
      stockStatus: json['stockStatus'] as String?,
      dateCreated: json['dateCreated'] as String?,
      createdByName: json['createdByName'] as String?,
      approvedBy: json['approvedBy'] as String?,
      dateApproved: json['dateApproved'] as String?,
      batchNumber: json['batchNumber'] as String?,
    );
  }
  final String? to;
  final String? stockStatus;
  final String? dateCreated;
  final String? createdByName;
  final String? approvedBy;
  final String? dateApproved;
  final String? batchNumber;
}
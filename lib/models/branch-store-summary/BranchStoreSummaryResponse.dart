class BranchStoreSummaryResponse {

  BranchStoreSummaryResponse({
    this.status,
    this.message,
    this.data,
  });

  factory BranchStoreSummaryResponse.fromJson(Map<String, dynamic> json) {
    return BranchStoreSummaryResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? BranchStoreSummaryData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
  final String? status;
  final String? message;
  final BranchStoreSummaryData? data;
}

class BranchStoreSummaryData {

  BranchStoreSummaryData({
    this.totalSales,
    this.branch,
    this.totalPosSales,
    this.totalInvoicesSales,
    this.customerCount,
    this.soldStock,
    this.unpaidTotals,
  });

  factory BranchStoreSummaryData.fromJson(Map<String, dynamic> json) {
    return BranchStoreSummaryData(
      totalSales: json['totalSales'] != null
          ? TotalSales.fromJson(json['totalSales']  as Map<String, dynamic>)
          : null,
      branch: json['branch'] != null
          ? BranchInfo.fromJson(json['branch'] as Map<String, dynamic>)
          : null,
      totalPosSales: json['totalPosSales'] != null
          ? TotalPosSales.fromJson(json['totalPosSales'] as Map<String, dynamic>)
          : null,
      totalInvoicesSales: json['totalInvoicesSales'] != null
          ? TotalInvoicesSales.fromJson(json['totalInvoicesSales'] as Map<String, dynamic>)
          : null,
      customerCount: json['customerCount'] != null
          ? CustomerCount.fromJson(json['customerCount'] as Map<String, dynamic>)
          : null,
      soldStock: json['soldStock'] != null
          ? SoldStock.fromJson(json['soldStock'] as Map<String, dynamic>)
          : null,
      unpaidTotals: json['unpaidTotals'] != null
          ? UnpaidTotals.fromJson(json['unpaidTotals'] as Map<String, dynamic>)
          : null,
    );
  }
  final TotalSales? totalSales;
  final BranchInfo? branch;
  final TotalPosSales? totalPosSales;
  final TotalInvoicesSales? totalInvoicesSales;
  final CustomerCount? customerCount;
  final SoldStock? soldStock;
  final UnpaidTotals? unpaidTotals;
}

class TotalSales {

  TotalSales({
    this.amount,
    this.currency,
    this.numberOfTransactions,
  });

  factory TotalSales.fromJson(Map<String, dynamic> json) {
    return TotalSales(
      amount: json['amount'] as int?,
      currency: json['currency'] as String?,
      numberOfTransactions: json['numberOfTransactions'] as int?,
    );
  }
  final int? amount;
  final String? currency;
  final int? numberOfTransactions;
}

class BranchInfo {

  BranchInfo({
    this.numberOfStores,
    this.numberOfStoresUsers,
  });

  factory BranchInfo.fromJson(Map<String, dynamic> json) {
    return BranchInfo(
      numberOfStores: json['numberOfStores'] as int?,
      numberOfStoresUsers: json['numberOfStoresUsers'] as int?,
    );
  }
  final int? numberOfStores;
  final int? numberOfStoresUsers;
}
class TotalPosSales {

  TotalPosSales({
    this.posTransactionsAmount,
    this.currency,
    this.numberOfPosTransactions,
  });

  factory TotalPosSales.fromJson(Map<String, dynamic> json) {
    return TotalPosSales(
      posTransactionsAmount: json['posTransactionsAmount'] as int?,
      currency: json['currency'] as String?,
      numberOfPosTransactions: json['numberOfPosTransactions'] as int?,
    );
  }
  final int? posTransactionsAmount;
  final String? currency;
  final int? numberOfPosTransactions;
}
class TotalInvoicesSales {

  TotalInvoicesSales({
    this.invoiceTransactionsAmount,
    this.currency,
    this.numberOfInvoiceTransactions,
  });

  factory TotalInvoicesSales.fromJson(Map<String, dynamic> json) {
    return TotalInvoicesSales(
      invoiceTransactionsAmount: json['invoiceTransactionsAmount'] as int?,
      currency: json['currency'] as String?,
      numberOfInvoiceTransactions: json['numberOfInvoiceTransactions'] as int?,
    );
  }
  final int? invoiceTransactionsAmount;
  final String? currency;
  final int? numberOfInvoiceTransactions;
}

class CustomerCount {

  CustomerCount({this.totalCustomers});

  factory CustomerCount.fromJson(Map<String, dynamic> json) {
    return CustomerCount(
      totalCustomers: json['totalCustomers'] as int?,
    );
  }
  final int? totalCustomers;
}

class SoldStock {

  SoldStock({this.businessSoldStockQuantity});

  factory SoldStock.fromJson(Map<String, dynamic> json) {
    return SoldStock(
      businessSoldStockQuantity: json['businessSoldStockQuantity'] as int?,
    );
  }
  final int? businessSoldStockQuantity;
}

class UnpaidTotals {

  UnpaidTotals({
    this.totalUnpaidOrders,
    this.totalUnpaidInvoices,
    this.totalUnpaid,
  });

  factory UnpaidTotals.fromJson(Map<String, dynamic> json) {
    return UnpaidTotals(
      totalUnpaidOrders: json['totalUnpaidOrders'] as int?,
      totalUnpaidInvoices: json['totalUnpaidInvoices'] as int?,
      totalUnpaid: json['totalUnpaid'] as int?,
    );
  }
  final int? totalUnpaidOrders;
  final int? totalUnpaidInvoices;
  final int? totalUnpaid;
}
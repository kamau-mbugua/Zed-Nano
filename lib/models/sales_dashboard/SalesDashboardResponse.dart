class SalesDashboardResponse {
  final String? status;
  final SalesDashboardData? data;

  SalesDashboardResponse({
    this.status,
    this.data,
  });

  factory SalesDashboardResponse.fromJson(Map<String, dynamic> json) {
    return SalesDashboardResponse(
      status: json['status'] as String?,
      data: json['data'] != null 
          ? SalesDashboardData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.toJson(),
    };
  }

  bool get isSuccess => status == 'SUCCESS';
}

class SalesDashboardData {
  final KeyMetrics? keyMetrics;
  final OrderSummary? orderSummary;
  final InvoiceSummary? invoiceSummary;
  final SalesTrend? salesTrend;

  SalesDashboardData({
    this.keyMetrics,
    this.orderSummary,
    this.invoiceSummary,
    this.salesTrend,
  });

  factory SalesDashboardData.fromJson(Map<String, dynamic> json) {
    return SalesDashboardData(
      keyMetrics: json['keyMetrics'] != null
          ? KeyMetrics.fromJson(json['keyMetrics'] as Map<String, dynamic>)
          : null,
      orderSummary: json['orderSummary'] != null
          ? OrderSummary.fromJson(json['orderSummary'] as Map<String, dynamic>)
          : null,
      invoiceSummary: json['invoiceSummary'] != null
          ? InvoiceSummary.fromJson(json['invoiceSummary'] as Map<String, dynamic>)
          : null,
      salesTrend: json['salesTrend'] != null
          ? SalesTrend.fromJson(json['salesTrend'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'keyMetrics': keyMetrics?.toJson(),
      'orderSummary': orderSummary?.toJson(),
      'invoiceSummary': invoiceSummary?.toJson(),
      'salesTrend': salesTrend?.toJson(),
    };
  }
}

class KeyMetrics {
  final double? totalSales;
  final int? totalTransactions;
  final double? quantitiesSold;

  KeyMetrics({
    this.totalSales,
    this.totalTransactions,
    this.quantitiesSold,
  });

  factory KeyMetrics.fromJson(Map<String, dynamic> json) {
    return KeyMetrics(
      totalSales: (json['totalSales'] as num?)?.toDouble(),
      totalTransactions: (json['totalTransactions'] as num?)?.toInt(),
      quantitiesSold: (json['quantitiesSold'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalSales': totalSales,
      'totalTransactions': totalTransactions,
      'quantitiesSold': quantitiesSold,
    };
  }
}

class OrderSummary {
  final SummaryItem? unpaid;
  final SummaryItem? paid;
  final SummaryItem? partial;

  OrderSummary({
    this.unpaid,
    this.paid,
    this.partial,
  });

  factory OrderSummary.fromJson(Map<String, dynamic> json) {
    return OrderSummary(
      unpaid: json['unpaid'] != null
          ? SummaryItem.fromJson(json['unpaid'] as Map<String, dynamic>)
          : null,
      paid: json['paid'] != null
          ? SummaryItem.fromJson(json['paid'] as Map<String, dynamic>)
          : null,
      partial: json['partial'] != null
          ? SummaryItem.fromJson(json['partial'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unpaid': unpaid?.toJson(),
      'paid': paid?.toJson(),
      'partial': partial?.toJson(),
    };
  }
}

class InvoiceSummary {
  final SummaryItem? unpaid;
  final SummaryItem? paid;
  final SummaryItem? partial;

  InvoiceSummary({
    this.unpaid,
    this.paid,
    this.partial,
  });

  factory InvoiceSummary.fromJson(Map<String, dynamic> json) {
    return InvoiceSummary(
      unpaid: json['unpaid'] != null
          ? SummaryItem.fromJson(json['unpaid'] as Map<String, dynamic>)
          : null,
      paid: json['paid'] != null
          ? SummaryItem.fromJson(json['paid'] as Map<String, dynamic>)
          : null,
      partial: json['partial'] != null
          ? SummaryItem.fromJson(json['partial'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unpaid': unpaid?.toJson(),
      'paid': paid?.toJson(),
      'partial': partial?.toJson(),
    };
  }
}

class SummaryItem {
  final double? total;
  final int? transactions;

  SummaryItem({
    this.total,
    this.transactions,
  });

  factory SummaryItem.fromJson(Map<String, dynamic> json) {
    return SummaryItem(
      total: (json['total'] as num?)?.toDouble(),
      transactions: (json['transactions'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'transactions': transactions,
    };
  }
}

class SalesTrend {
  final MonthData? jan;
  final MonthData? feb;
  final MonthData? mar;
  final MonthData? apr;
  final MonthData? may;
  final MonthData? jun;
  final MonthData? jul;
  final MonthData? aug;
  final MonthData? sep;
  final MonthData? oct;
  final MonthData? nov;
  final MonthData? dec;

  SalesTrend({
    this.jan,
    this.feb,
    this.mar,
    this.apr,
    this.may,
    this.jun,
    this.jul,
    this.aug,
    this.sep,
    this.oct,
    this.nov,
    this.dec,
  });

  factory SalesTrend.fromJson(Map<String, dynamic> json) {
    return SalesTrend(
      jan: json['Jan'] != null
          ? MonthData.fromJson(json['Jan'] as Map<String, dynamic>)
          : null,
      feb: json['Feb'] != null
          ? MonthData.fromJson(json['Feb'] as Map<String, dynamic>)
          : null,
      mar: json['Mar'] != null
          ? MonthData.fromJson(json['Mar'] as Map<String, dynamic>)
          : null,
      apr: json['Apr'] != null
          ? MonthData.fromJson(json['Apr'] as Map<String, dynamic>)
          : null,
      may: json['May'] != null
          ? MonthData.fromJson(json['May'] as Map<String, dynamic>)
          : null,
      jun: json['Jun'] != null
          ? MonthData.fromJson(json['Jun'] as Map<String, dynamic>)
          : null,
      jul: json['Jul'] != null
          ? MonthData.fromJson(json['Jul'] as Map<String, dynamic>)
          : null,
      aug: json['Aug'] != null
          ? MonthData.fromJson(json['Aug'] as Map<String, dynamic>)
          : null,
      sep: json['Sep'] != null
          ? MonthData.fromJson(json['Sep'] as Map<String, dynamic>)
          : null,
      oct: json['Oct'] != null
          ? MonthData.fromJson(json['Oct'] as Map<String, dynamic>)
          : null,
      nov: json['Nov'] != null
          ? MonthData.fromJson(json['Nov'] as Map<String, dynamic>)
          : null,
      dec: json['Dec'] != null
          ? MonthData.fromJson(json['Dec'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Jan': jan?.toJson(),
      'Feb': feb?.toJson(),
      'Mar': mar?.toJson(),
      'Apr': apr?.toJson(),
      'May': may?.toJson(),
      'Jun': jun?.toJson(),
      'Jul': jul?.toJson(),
      'Aug': aug?.toJson(),
      'Sep': sep?.toJson(),
      'Oct': oct?.toJson(),
      'Nov': nov?.toJson(),
      'Dec': dec?.toJson(),
    };
  }

  List<MonthData> getMonthsData() {
    return [
      jan ?? MonthData(totalSales: 0, totalTransactions: 0),
      feb ?? MonthData(totalSales: 0, totalTransactions: 0),
      mar ?? MonthData(totalSales: 0, totalTransactions: 0),
      apr ?? MonthData(totalSales: 0, totalTransactions: 0),
      may ?? MonthData(totalSales: 0, totalTransactions: 0),
      jun ?? MonthData(totalSales: 0, totalTransactions: 0),
      jul ?? MonthData(totalSales: 0, totalTransactions: 0),
      aug ?? MonthData(totalSales: 0, totalTransactions: 0),
      sep ?? MonthData(totalSales: 0, totalTransactions: 0),
      oct ?? MonthData(totalSales: 0, totalTransactions: 0),
      nov ?? MonthData(totalSales: 0, totalTransactions: 0),
      dec ?? MonthData(totalSales: 0, totalTransactions: 0),
    ];
  }

  List<String> getMonthLabels() {
    return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  }
}

class MonthData {
  final double? totalSales;
  final int? totalTransactions;

  MonthData({
    this.totalSales,
    this.totalTransactions,
  });

  factory MonthData.fromJson(Map<String, dynamic> json) {
    return MonthData(
      totalSales: (json['totalSales'] as num?)?.toDouble(),
      totalTransactions: (json['totalTransactions'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalSales': totalSales,
      'totalTransactions': totalTransactions,
    };
  }
}

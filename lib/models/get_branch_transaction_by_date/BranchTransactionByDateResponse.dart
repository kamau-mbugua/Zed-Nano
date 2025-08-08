class BranchTransactionByDateResponse {

  BranchTransactionByDateResponse({
    this.total,
    this.currency,
    this.data,
  });

  factory BranchTransactionByDateResponse.fromJson(Map<String, dynamic> json) {
    return BranchTransactionByDateResponse(
      total: json['total'] as int?,
      currency: json['currency'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => TransactionBreakdown.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  final int? total;
  final String? currency;
  final List<TransactionBreakdown>? data;
}

class TransactionBreakdown {

  TransactionBreakdown({
    this.transationType,
    this.currency,
    this.amount,
    this.percentageOfTotal,
    this.numberOfTransactions,
  });

  factory TransactionBreakdown.fromJson(Map<String, dynamic> json) {
    return TransactionBreakdown(
      transationType: json['transationType'] as String?,
      currency: json['currency'] as String?,
      amount: json['amount'] as int?,
      percentageOfTotal: (json['percentageOfTotal'] as num?)?.toDouble(),
      numberOfTransactions: json['numberOfTransactions'] as int?,
    );
  }
  final String? transationType;
  final String? currency;
  final int? amount;
  final double? percentageOfTotal;
  final int? numberOfTransactions;
}
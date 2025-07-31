import 'approval_data.dart';

class ApprovalResponse {
  final List<ApprovalData>? data;

  ApprovalResponse({
    this.data,
  });

  factory ApprovalResponse.fromJson(Map<String, dynamic> json) {
    return ApprovalResponse(
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => ApprovalData.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'ApprovalResponse(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApprovalResponse && 
        _listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}

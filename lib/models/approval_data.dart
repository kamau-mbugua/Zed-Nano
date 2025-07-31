class ApprovalData {
  final String? name;
  final String? count;

  ApprovalData({
    this.name,
    this.count,
  });

  factory ApprovalData.fromJson(Map<String, dynamic> json) {
    return ApprovalData(
      name: json['name'] as String?,
      count: json['count'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'count': count,
    };
  }

  @override
  String toString() {
    return 'ApprovalData(name: $name, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApprovalData &&
        other.name == name &&
        other.count == count;
  }

  @override
  int get hashCode => name.hashCode ^ count.hashCode;
}

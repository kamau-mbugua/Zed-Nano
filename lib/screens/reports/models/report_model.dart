import 'package:flutter/foundation.dart';

/// Model representing a report in the application
class ReportModel {
  final String id;
  final String title;
  final String description;
  final DateTime generatedDate;
  final ReportType type;
  final String filePath;

  /// Creates a new report instance
  ReportModel({
    required this.id,
    required this.title,
    required this.description,
    required this.generatedDate,
    required this.type,
    required this.filePath,
  });

  /// Creates a report from JSON data
  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      generatedDate: DateTime.parse(json['generatedDate'] as String),
      type: ReportType.values.firstWhere(
        (e) => e.toString() == 'ReportType.${json['type']}',
        orElse: () => ReportType.sales,
      ),
      filePath: json['filePath'] as String,
    );
  }

  /// Converts report to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'generatedDate': generatedDate.toIso8601String(),
      'type': type.toString().split('.').last,
      'filePath': filePath,
    };
  }

  /// Creates a copy of this report with the given fields replaced with new values
  ReportModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? generatedDate,
    ReportType? type,
    String? filePath,
  }) {
    return ReportModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      generatedDate: generatedDate ?? this.generatedDate,
      type: type ?? this.type,
      filePath: filePath ?? this.filePath,
    );
  }
}

/// Types of reports available in the application
enum ReportType {
  sales,
  inventory,
  customers,
  financial,
}
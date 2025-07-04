import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class BusinessDetails {
  final String businessId;
  final String businessNumber;
  final String group;
  final String branchId;
  final String localCurrency;
  final String businessCategory;

  BusinessDetails({
    required this.businessId,
    required this.businessNumber,
    required this.group,
    required this.branchId,
    required this.localCurrency,
    required this.businessCategory,
  });

  Map<String, dynamic> toJson() {
    return {
      'businessId': businessId,
      'businessNumber': businessNumber,
      'group': group,
      'branchId': branchId,
      'localCurrency': localCurrency,
      'localCurrency': businessCategory,
    };
  }

  factory BusinessDetails.fromJson(Map<String, dynamic> json) {
    return BusinessDetails(
      businessId: json['businessId'] as String,
      businessNumber: json['businessNumber'] as String,
      group: json['group'] as String,
      branchId: json['branchId'] as String,
      localCurrency: json['localCurrency'] as String,
      businessCategory: json['businessCategory'] as String,
    );
  }

  String get json => jsonEncode(toJson());

  static Future<void> saveToSharedPreferences(BusinessDetails details) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('businessDetails', details.json);
  }

  static Future<BusinessDetails?> loadFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('businessDetails');
    return jsonString != null ? BusinessDetails.fromJsonString(jsonString) : null;
  }

  static BusinessDetails? fromJsonString(String jsonString) {
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return BusinessDetails.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}

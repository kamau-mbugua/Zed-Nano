import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/services/business_setup_service.dart';

/// Extension methods to make BusinessSetupService easier to use throughout the app
extension BusinessSetupContext on BuildContext {
  /// Get BusinessSetupService instance from context
  BusinessSetupService get businessSetup => Provider.of<BusinessSetupService>(this, listen: false);
  
  /// Get BusinessSetupService instance with listen parameter
  BusinessSetupService businessSetupWith({bool listen = true}) => Provider.of<BusinessSetupService>(this, listen: listen);
  
  /// Check if business setup is required
  bool get requiresBusinessSetup => businessSetup.requiresBusinessSetup;
  
  /// Check if business is configured
  bool get isBusinessConfigured => businessSetup.isBusinessConfigured;
  
  /// Get business display name
  String get businessDisplayName => businessSetup.getBusinessDisplayName();
  
  /// Get business currency
  String get businessCurrency => businessSetup.getBusinessCurrency();
  
  /// Get business category
  String get businessCategory => businessSetup.getBusinessCategory();
  
  /// Get setup completion percentage
  double get setupCompletionPercentage => businessSetup.getSetupCompletionPercentage();
  
  /// Get missing business fields
  List<String> get missingBusinessFields => businessSetup.getMissingFields();
  
  /// Check if business profile is complete
  bool get hasCompleteBusinessProfile => businessSetup.hasCompleteBusinessProfile();
}
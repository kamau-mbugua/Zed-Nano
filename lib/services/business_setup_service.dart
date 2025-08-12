import 'dart:convert';
import 'package:flutter/widgets.dart'; // Import Widgets to use WidgetsBinding
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/models/business/BusinessDetails.dart';

/// Service to manage business setup state and validation
/// 
/// This service provides a centralized way to:
/// - Check if business setup is required
/// - Validate business details
/// - Listen to business setup state changes
/// - Manage business setup flow
class BusinessSetupService extends ChangeNotifier {
  factory BusinessSetupService() => _instance;
  BusinessSetupService._internal();
  static final BusinessSetupService _instance = BusinessSetupService._internal();

  // Private state
  BusinessDetails? _businessDetails;
  bool _isInitialized = false;
  bool _isLoading = false;

  // Getters
  BusinessDetails? get businessDetails => _businessDetails;
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  
  /// Returns true if business setup is required
  bool get requiresBusinessSetup {
    if (!_isInitialized) return false;
    return _businessDetails == null || 
           _businessDetails!.businessNumber?.isEmpty == true ||
           _businessDetails!.businessNumber == null;
  }

  /// Returns true if business is properly configured
  bool get isBusinessConfigured {
    return !requiresBusinessSetup && _businessDetails != null;
  }

  /// Initialize the service by loading business details from SharedPreferences
  Future<void> initialize() async {
    // if (_isInitialized) return;
    
    _isLoading = true;
    _safeNotifyListeners();

    try {
      _businessDetails = await BusinessDetails.loadFromSharedPreferences();
      logger.i('BusinessSetupService: Loaded business details - ${_businessDetails?.toJson()}');
    } catch (e) {
      logger.e('BusinessSetupService: Failed to load business details - $e');
      _businessDetails = null;
    } finally {
      _isInitialized = true;
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  /// Update business details and save to SharedPreferences
  Future<void> updateBusinessDetails(BusinessDetails details) async {
    try {
      await BusinessDetails.saveToSharedPreferences(details);
      _businessDetails = details;
      logger.i('BusinessSetupService: Updated business details - ${details.toJson()}');
      _safeNotifyListeners();
    } catch (e) {
      logger.e('BusinessSetupService: Failed to update business details - $e');
      rethrow;
    }
  }

  /// Update business details from AuthenticatedAppProviders
  /// This method should be called when business details are updated via API
  void syncBusinessDetailsFromProvider(BusinessDetails? details) {
    if (details != _businessDetails) {
      _businessDetails = details;
      logger.i('BusinessSetupService: Synced business details from provider - ${details?.toJson()}');
      _safeNotifyListeners();
    }
  }

  /// Clear business details (useful for logout)
  Future<void> clearBusinessDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('businessDetails');
      _businessDetails = null;
      logger.i('BusinessSetupService: Cleared business details');
      _safeNotifyListeners();
    } catch (e) {
      logger.e('BusinessSetupService: Failed to clear business details - $e');
      rethrow;
    }
  }

  /// Reset service state (useful for testing)
  Future<void> resetForTesting() async {
    _businessDetails = null;
    _isInitialized = false;
    _isLoading = false;
    
    // Also clear SharedPreferences for complete reset
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('businessDetails');
    } catch (e) {
      // Ignore errors during testing reset
    }
    
    _safeNotifyListeners();
  }

  /// Complete logout - clears all business data and resets service state
  /// This should be called during user logout to ensure clean state for next user
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Clear all business-related SharedPreferences keys
      await prefs.remove('businessDetails');
      
      // Reset all internal state
      _businessDetails = null;
      _isInitialized = false;
      _isLoading = false;
      
      logger.i('💡 BusinessSetupService: Complete logout - all data cleared');
      _safeNotifyListeners();
    } catch (e) {
      logger.e('⛔ BusinessSetupService: Failed to logout completely - $e');
      rethrow;
    }
  }

  /// Force refresh and reinitialize from SharedPreferences
  /// Useful when switching users or after login
  Future<void> refresh() async {
    try {
      _isLoading = true;
      _safeNotifyListeners();
      
      final prefs = await SharedPreferences.getInstance();
      final businessData = prefs.getString('businessDetails');
      
      if (businessData != null) {
        final businessJson = jsonDecode(businessData) as Map<String, dynamic>;
        _businessDetails = BusinessDetails.fromJson(businessJson);
        logger.i('💡 BusinessSetupService: Refreshed business details - ${_businessDetails?.toJson()}');
      } else {
        _businessDetails = null;
        logger.i('💡 BusinessSetupService: No business details found during refresh');
      }
      
      _isInitialized = true;
      _isLoading = false;
      _safeNotifyListeners();
    } catch (e) {
      _isLoading = false;
      _isInitialized = true; // Mark as initialized even if failed
      logger.e('⛔ BusinessSetupService: Failed to refresh - $e');
      _safeNotifyListeners();
      rethrow;
    }
  }

  /// Initialize for a new user session
  /// This method should be called after successful login
  Future<void> initializeForNewUser() async {
    try {
      // First clear any existing state
      _businessDetails = null;
      _isInitialized = false;
      _isLoading = true;
      _safeNotifyListeners();
      
      // Then initialize fresh
      await initialize();
      
      logger.i('💡 BusinessSetupService: Initialized for new user session');
    } catch (e) {
      logger.e('⛔ BusinessSetupService: Failed to initialize for new user - $e');
      rethrow;
    }
  }

  /// Validate if business details are complete
  bool validateBusinessDetails(BusinessDetails? details) {
    if (details == null) return false;
    
    // Check required fields
    if (details.businessNumber?.isEmpty == true || details.businessNumber == null) {
      return false;
    }
    
    if (details.businessName?.isEmpty == true || details.businessName == null) {
      return false;
    }
    
    if (details.businessId?.isEmpty == true || details.businessId == null) {
      return false;
    }

    return true;
  }

  /// Get business display name (fallback to business number if name is empty)
  String getBusinessDisplayName() {
    if (_businessDetails?.businessName?.isNotEmpty == true) {
      return _businessDetails!.businessName!;
    }
    if (_businessDetails?.businessNumber?.isNotEmpty == true) {
      return _businessDetails!.businessNumber!;
    }
    return 'Business';
  }
  /// Get business display name (fallback to business number if name is empty)
  String getUserRoleName() {
    if (_businessDetails?.group?.isNotEmpty == true) {
      return _businessDetails!.group!;
    }
    if (_businessDetails?.businessNumber?.isNotEmpty == true) {
      return _businessDetails!.businessNumber!;
    }
    return '';
  }

  /// Safe method to call notifyListeners that avoids calling during build phase
  void _safeNotifyListeners() {
    // Check if we're currently in a build phase
    try {
      // If WidgetsBinding is not initialized, call directly
      if (WidgetsBinding.instance.lifecycleState == null) {
        notifyListeners();
        return;
      }
      
      // Use post frame callback to avoid calling during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    } catch (e) {
      // Fallback to direct call if there's any issue
      notifyListeners();
    }
  }

  /// Get business currency or default
  String getBusinessCurrency() {
    return _businessDetails?.localCurrency ?? 'USD';
  }

  /// Get business category or default
  String getBusinessCategory() {
    return _businessDetails?.businessCategory ?? 'General';
  }

  /// Check if business has all required fields for specific features
  bool hasCompleteBusinessProfile() {
    if (_businessDetails == null) return false;
    
    return hasValidBusinessNumber() &&
           hasValidBusinessName() &&
           hasValidBusinessId() &&
           hasValidBranchId() &&
           _businessDetails!.localCurrency?.isNotEmpty == true &&
           _businessDetails!.businessCategory?.isNotEmpty == true;
  }

  /// Get business setup completion percentage
  double getSetupCompletionPercentage() {
    if (_businessDetails == null) return 0;
    
    var completedFields = 0;
    const totalFields = 6;
    
    if (hasValidBusinessNumber()) completedFields++;
    if (hasValidBusinessName()) completedFields++;
    if (hasValidBusinessId()) completedFields++;
    if (hasValidBranchId()) completedFields++;
    if (_businessDetails!.localCurrency?.isNotEmpty == true) completedFields++;
    if (_businessDetails!.businessCategory?.isNotEmpty == true) completedFields++;
    
    return completedFields / totalFields;
  }

  /// Get missing business setup fields
  List<String> getMissingFields() {
    final missing = <String>[];
    
    if (!hasValidBusinessNumber()) missing.add('Business Number');
    if (!hasValidBusinessName()) missing.add('Business Name');
    if (!hasValidBusinessId()) missing.add('Business ID');
    if (!hasValidBranchId()) missing.add('Branch ID');
    if (_businessDetails?.localCurrency?.isEmpty != false) missing.add('Currency');
    if (_businessDetails?.businessCategory?.isEmpty != false) missing.add('Category');
    
    return missing;
  }

  /// Check if specific business fields are valid
  bool hasValidBusinessNumber() {
    return _businessDetails?.businessNumber?.isNotEmpty == true;
  }

  bool hasValidBusinessName() {
    return _businessDetails?.businessName?.isNotEmpty == true;
  }

  bool hasValidBusinessId() {
    return _businessDetails?.businessId?.isNotEmpty == true;
  }

  bool hasValidBranchId() {
    return _businessDetails?.branchId?.isNotEmpty == true;
  }
}

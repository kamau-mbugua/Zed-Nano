import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/di_container.dart' as di;
import 'package:zed_nano/services/push_notification_service.dart';

/// Utility class for managing push notifications
class NotificationUtils {
  static final PushNotificationService _notificationService = di.sl<PushNotificationService>();

  /// Subscribe user to relevant topics based on their profile
  static Future<void> subscribeToUserTopics({
    required String userId,
    String? businessId,
    List<String>? customTopics,
  }) async {
    try {
      // Subscribe to user-specific topic
      await _notificationService.subscribeToTopic('user_$userId');
      
      // Subscribe to business-specific topic if available
      if (businessId != null) {
        await _notificationService.subscribeToTopic('business_$businessId');
      }
      
      // Subscribe to general topics
      await _notificationService.subscribeToTopic('general_announcements');
      await _notificationService.subscribeToTopic('app_updates');
      
      // Subscribe to custom topics
      if (customTopics != null) {
        for (final topic in customTopics) {
          await _notificationService.subscribeToTopic(topic);
        }
      }
      
      logger.i('Successfully subscribed to user topics');
    } catch (e) {
      logger.e('Failed to subscribe to user topics: $e');
    }
  }

  /// Unsubscribe user from topics (usually on logout)
  static Future<void> unsubscribeFromUserTopics({
    required String userId,
    String? businessId,
    List<String>? customTopics,
  }) async {
    try {
      // Unsubscribe from user-specific topic
      await _notificationService.unsubscribeFromTopic('user_$userId');
      
      // Unsubscribe from business-specific topic if available
      if (businessId != null) {
        await _notificationService.unsubscribeFromTopic('business_$businessId');
      }
      
      // Keep general topics (user might want to receive them even when logged out)
      // await _notificationService.unsubscribeFromTopic('general_announcements');
      // await _notificationService.unsubscribeFromTopic('app_updates');
      
      // Unsubscribe from custom topics
      if (customTopics != null) {
        for (final topic in customTopics) {
          await _notificationService.unsubscribeFromTopic(topic);
        }
      }
      
      logger.i('Successfully unsubscribed from user topics');
    } catch (e) {
      logger.e('Failed to unsubscribe from user topics: $e');
    }
  }

  /// Subscribe to business-related topics
  static Future<void> subscribeToBusinessTopics({
    required String businessId,
    List<String>? businessTypes,
  }) async {
    try {
      await _notificationService.subscribeToTopic('business_$businessId');
      await _notificationService.subscribeToTopic('business_notifications');
      
      // Subscribe to business type specific topics
      if (businessTypes != null) {
        for (final type in businessTypes) {
          await _notificationService.subscribeToTopic('business_type_$type');
        }
      }
      
      logger.i('Successfully subscribed to business topics');
    } catch (e) {
      logger.e('Failed to subscribe to business topics: $e');
    }
  }

  /// Get current FCM token
  static String? getCurrentToken() {
    return _notificationService.fcmToken;
  }

  /// Send FCM token to backend server
  static Future<void> updateTokenOnServer({
    required String userId,
    String? businessId,
  }) async {
    try {
      await _notificationService.sendTokenToServer(userId);
      logger.i('FCM token updated on server for user: $userId');
    } catch (e) {
      logger.e('Failed to update FCM token on server: $e');
    }
  }

  /// Clear all notifications
  static Future<void> clearAllNotifications() async {
    await _notificationService.clearAllNotifications();
  }

  /// Check if notification service is initialized
  static bool isInitialized() {
    return _notificationService.isInitialized;
  }

  /// Common notification topics
  static const String topicGeneralAnnouncements = 'general_announcements';
  static const String topicAppUpdates = 'app_updates';
  static const String topicBusinessNotifications = 'business_notifications';
  static const String topicOrderUpdates = 'order_updates';
  static const String topicPaymentUpdates = 'payment_updates';
  static const String topicInventoryAlerts = 'inventory_alerts';
  static const String topicPromotions = 'promotions';
}

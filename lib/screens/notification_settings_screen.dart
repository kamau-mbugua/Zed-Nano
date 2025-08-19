import 'package:flutter/material.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/di_container.dart' as di;
import 'package:zed_nano/services/push_notification_service.dart';
import 'package:zed_nano/utils/notification_utils.dart';

/// Screen for managing notification settings
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  late final PushNotificationService _notificationService;
  String? _fcmToken;
  bool _isLoading = false;
  
  // Topic subscription states
  bool _generalAnnouncements = false;
  bool _appUpdates = false;
  bool _businessNotifications = false;
  bool _orderUpdates = false;
  bool _paymentUpdates = false;
  bool _inventoryAlerts = false;
  bool _promotions = false;

  @override
  void initState() {
    super.initState();
    _notificationService = di.sl<PushNotificationService>();
    _loadCurrentSettings();
  }

  void _loadCurrentSettings() {
    setState(() {
      _fcmToken = _notificationService.fcmToken;
    });
  }

  Future<void> _toggleTopic(String topic, bool subscribe) async {
    setState(() => _isLoading = true);
    
    try {
      if (subscribe) {
        await _notificationService.subscribeToTopic(topic);
        _showSnackBar('Subscribed to $topic notifications');
      } else {
        await _notificationService.unsubscribeFromTopic(topic);
        _showSnackBar('Unsubscribed from $topic notifications');
      }
    } catch (e) {
      _showSnackBar('Failed to update subscription: $e');
      logger.e('Failed to toggle topic $topic: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _testNotification() async {
    // This would typically be done from your backend
    // Here we just show a local notification for testing
    _showSnackBar('Test notification feature would be implemented with backend integration');
  }

  Future<void> _clearAllNotifications() async {
    await NotificationUtils.clearAllNotifications();
    _showSnackBar('All notifications cleared');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // FCM Token Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Device Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Notification Service: ${NotificationUtils.isInitialized() ? "Initialized" : "Not Initialized"}',
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'FCM Token: ${_fcmToken != null ? "Available" : "Not Available"}',
                          ),
                          if (_fcmToken != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Token: ${_fcmToken!.substring(0, 20)}...',
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Notification Topics Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Notification Topics',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Choose which types of notifications you want to receive:',
                            style: TextStyle(color: Colors.grey, fontFamily: 'Poppins',),
                          ),
                          const SizedBox(height: 16),
                          
                          SwitchListTile(
                            title: const Text('General Announcements'),
                            subtitle: const Text('Important app-wide announcements'),
                            value: _generalAnnouncements,
                            onChanged: (value) {
                              setState(() => _generalAnnouncements = value);
                              _toggleTopic(NotificationUtils.topicGeneralAnnouncements, value);
                            },
                          ),
                          
                          SwitchListTile(
                            title: const Text('App Updates'),
                            subtitle: const Text('New features and app updates'),
                            value: _appUpdates,
                            onChanged: (value) {
                              setState(() => _appUpdates = value);
                              _toggleTopic(NotificationUtils.topicAppUpdates, value);
                            },
                          ),
                          
                          SwitchListTile(
                            title: const Text('Business Notifications'),
                            subtitle: const Text('Business-related updates'),
                            value: _businessNotifications,
                            onChanged: (value) {
                              setState(() => _businessNotifications = value);
                              _toggleTopic(NotificationUtils.topicBusinessNotifications, value);
                            },
                          ),
                          
                          SwitchListTile(
                            title: const Text('Order Updates'),
                            subtitle: const Text('Order status and delivery updates'),
                            value: _orderUpdates,
                            onChanged: (value) {
                              setState(() => _orderUpdates = value);
                              _toggleTopic(NotificationUtils.topicOrderUpdates, value);
                            },
                          ),
                          
                          SwitchListTile(
                            title: const Text('Payment Updates'),
                            subtitle: const Text('Payment confirmations and alerts'),
                            value: _paymentUpdates,
                            onChanged: (value) {
                              setState(() => _paymentUpdates = value);
                              _toggleTopic(NotificationUtils.topicPaymentUpdates, value);
                            },
                          ),
                          
                          SwitchListTile(
                            title: const Text('Inventory Alerts'),
                            subtitle: const Text('Low stock and inventory updates'),
                            value: _inventoryAlerts,
                            onChanged: (value) {
                              setState(() => _inventoryAlerts = value);
                              _toggleTopic(NotificationUtils.topicInventoryAlerts, value);
                            },
                          ),
                          
                          SwitchListTile(
                            title: const Text('Promotions'),
                            subtitle: const Text('Special offers and promotions'),
                            value: _promotions,
                            onChanged: (value) {
                              setState(() => _promotions = value);
                              _toggleTopic(NotificationUtils.topicPromotions, value);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Action Buttons
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Actions',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _testNotification,
                              icon: const Icon(Icons.notifications_active),
                              label: const Text('Test Notification'),
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _clearAllNotifications,
                              icon: const Icon(Icons.clear_all),
                              label: const Text('Clear All Notifications'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Information Card
                  Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info, color: Colors.blue.shade700),
                              const SizedBox(width: 8),
                              Text(
                                'How it works',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '• Notifications work in foreground, background, and when app is closed\n'
                            '• Topics allow you to receive relevant notifications\n'
                            '• Your notification token is automatically synced with our servers\n'
                            '• You can change these settings anytime',
                            style: TextStyle(fontSize: 14, fontFamily: 'Poppins',),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

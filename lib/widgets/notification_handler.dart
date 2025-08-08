import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/di_container.dart' as di;
import 'package:zed_nano/services/push_notification_service.dart';

/// Widget that handles push notification events and navigation
class NotificationHandler extends StatefulWidget {
  final Widget child;
  
  const NotificationHandler({
    super.key,
    required this.child,
  });

  @override
  State<NotificationHandler> createState() => _NotificationHandlerState();
}

class _NotificationHandlerState extends State<NotificationHandler> {
  late final PushNotificationService _notificationService;
  StreamSubscription<RemoteMessage>? _messageSubscription;
  StreamSubscription<String>? _tokenSubscription;

  @override
  void initState() {
    super.initState();
    _notificationService = di.sl<PushNotificationService>();
    _setupNotificationListeners();
  }

  void _setupNotificationListeners() {
    // Listen to incoming messages
    _messageSubscription = _notificationService.messageStream.listen(
      (RemoteMessage message) {
        _handleNotificationMessage(message);
      },
    );

    // Listen to token updates
    _tokenSubscription = _notificationService.tokenStream.listen(
      (String token) {
        _handleTokenUpdate(token);
      },
    );
  }

  void _handleNotificationMessage(RemoteMessage message) {
    logger.i('Received notification in handler: ${message.messageId}');
    
    // Extract notification data
    final data = message.data;
    final notification = message.notification;
    
    // Show a snackbar for foreground notifications (optional)
    if (mounted && notification != null) {
      _showNotificationSnackBar(notification);
    }
    
    // Handle navigation based on notification data
    _handleNotificationNavigation(data);
  }

  void _handleTokenUpdate(String token) {
    logger.i('FCM Token updated: $token');
    
    // Send token to your backend server
    // You can implement this based on your authentication state
    // Example:
    // final authProvider = context.read<AuthenticatedAppProviders>();
    // if (authProvider.isAuthenticated) {
    //   _notificationService.sendTokenToServer(authProvider.currentUser?.uid);
    // }
  }

  void _showNotificationSnackBar(RemoteNotification notification) {
    final context = Get.context;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (notification.title != null)
                Text(
                  notification.title!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              if (notification.body != null)
                Text(notification.body!),
            ],
          ),
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'View',
            onPressed: () {
              // Handle notification tap
            },
          ),
        ),
      );
    }
  }

  void _handleNotificationNavigation(Map<String, dynamic> data) {
    if (data.isEmpty) return;
    
    final context = Get.context;
    if (context == null) return;
    
    // Extract navigation parameters
    final screen = data['screen'] as String?;
    final id = data['id'] as String?;
    final route = data['route'] as String?;
    
    // Navigate based on notification data
    if (route != null) {
      // Direct route navigation
      Navigator.pushNamed(context, route, arguments: data);
    } else if (screen != null) {
      // Screen-based navigation
      _navigateToScreen(context, screen, id, data);
    }
  }

  void _navigateToScreen(BuildContext context, String screen, String? id, Map<String, dynamic> data) {
    switch (screen.toLowerCase()) {
      case 'home':
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        break;
      case 'profile':
        Navigator.pushNamed(context, '/profile', arguments: {'userId': id});
        break;
      case 'chat':
        Navigator.pushNamed(context, '/chat', arguments: {'chatId': id});
        break;
      case 'order':
        Navigator.pushNamed(context, '/order', arguments: {'orderId': id});
        break;
      case 'business':
        Navigator.pushNamed(context, '/business', arguments: {'businessId': id});
        break;
      default:
        logger.w('Unknown notification screen: $screen');
        // Navigate to home as fallback
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _tokenSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

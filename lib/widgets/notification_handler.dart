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
    
    // For data-only notifications, create a synthetic notification for display
    RemoteNotification? displayNotification = notification;
    if (notification == null && data.isNotEmpty) {
      // Create notification from data for snackbar display
      final title = data['title'] as String? ?? 'New Notification';
      final body = data['message'] as String? ?? data['body'] as String?;
      
      if (title.isNotEmpty || (body != null && body.isNotEmpty)) {
        // We can't create RemoteNotification directly, so we'll handle this in the snackbar method
        // _showDataNotificationSnackBar(title, body);
      }
    } else if (mounted && notification != null) {
      // _showNotificationSnackBar(notification);
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
    _showDataNotificationSnackBar(notification.title, notification.body);
  }
  
  void _showDataNotificationSnackBar(String? title, String? body) {
    final context = Get.context;
    if (context != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF1F2024),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null && title.isNotEmpty)
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              if (body != null && body.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    body,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'View',
            textColor: const Color(0xFF4CAF50),
            onPressed: () {
              // Check for pending navigation from notification service
              final pendingNav = _notificationService.getPendingNavigation();
              if (pendingNav != null) {
                final screen = pendingNav['screen'] as String?;
                final id = pendingNav['id'] as String?;
                final data = pendingNav['data'] as Map<String, dynamic>? ?? {};
                if (screen != null) {
                  // _navigateToScreen(context, screen, id, data);
                }
              }
            },
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
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
      // _navigateToScreen(context, screen, id, data);
    }
  }

  void _navigateToScreen(BuildContext context, String screen, String? id, Map<String, dynamic> data) {
    logger.i('Navigating to screen: $screen with id: $id');
    
    switch (screen.toLowerCase()) {
      case 'home':
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        break;
      case 'invoice':
        // Navigate to invoices list or specific invoice
        if (id != null) {
          Navigator.pushNamed(context, '/invoices', arguments: {'invoiceId': id});
        } else {
          Navigator.pushNamed(context, '/invoices');
        }
        break;
      case 'order':
        // Navigate to orders list or specific order
        if (id != null) {
          Navigator.pushNamed(context, '/orders', arguments: {'orderId': id});
        } else {
          Navigator.pushNamed(context, '/orders');
        }
        break;
      case 'inventory':
        Navigator.pushNamed(context, '/inventory');
        break;
      case 'payments':
        Navigator.pushNamed(context, '/payments');
        break;
      case 'dashboard':
        Navigator.pushNamed(context, '/dashboard');
        break;
      case 'profile':
        Navigator.pushNamed(context, '/profile', arguments: {'userId': id});
        break;
      case 'business':
        Navigator.pushNamed(context, '/business', arguments: {'businessId': id});
        break;
      case 'approvals':
        Navigator.pushNamed(context, '/approvals');
        break;
      case 'reports':
        Navigator.pushNamed(context, '/reports');
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

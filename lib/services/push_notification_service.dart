import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:zed_nano/app/app_initializer.dart';

/// Global function to handle background messages
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  logger.i('Handling a background message: ${message.messageId}');
  logger.i('Background message data: ${message.data}');
  
  // You can perform background tasks here like updating local storage
  // or showing notifications
}

/// Service to handle push notifications using Firebase Cloud Messaging
/// and local notifications
class PushNotificationService {
  static final PushNotificationService _instance = PushNotificationService._internal();
  factory PushNotificationService() => _instance;
  PushNotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  String? _fcmToken;
  bool _isInitialized = false;
  
  // Stream controllers for handling notification events
  final StreamController<RemoteMessage> _messageStreamController = StreamController<RemoteMessage>.broadcast();
  final StreamController<String> _tokenStreamController = StreamController<String>.broadcast();
  
  // Getters for streams
  Stream<RemoteMessage> get messageStream => _messageStreamController.stream;
  Stream<String> get tokenStream => _tokenStreamController.stream;
  
  String? get fcmToken => _fcmToken;
  bool get isInitialized => _isInitialized;

  /// Initialize the push notification service
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      logger.i('Initializing Push Notification Service...');
      
      // Initialize local notifications
      await _initializeLocalNotifications();
      
      // Request permissions
      await _requestPermissions();
      
      // Get FCM token
      await _getFCMToken();
      
      // Set up message handlers
      _setupMessageHandlers();
      
      // Set background message handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      
      _isInitialized = true;
      logger.i('Push Notification Service initialized successfully');
      
    } catch (e, stackTrace) {
      logger.e('Failed to initialize Push Notification Service: $e $stackTrace');
      rethrow;
    }
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    
    // Create notification channel for Android
    if (Platform.isAndroid) {
      await _createNotificationChannel();
    }
  }

  /// Create notification channel for Android
  Future<void> _createNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      playSound: true,
    );
    
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Request notification permissions
  Future<NotificationSettings> _requestPermissions() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    
    logger.i('Notification permission status: ${settings.authorizationStatus}');
    
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      logger.i('User granted notification permissions');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      logger.i('User granted provisional notification permissions');
    } else {
      logger.w('User declined or has not accepted notification permissions');
    }
    
    return settings;
  }

  /// Get FCM token
  Future<void> _getFCMToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();
      logger.i('FCM Token: $_fcmToken');
      
      if (_fcmToken != null) {
        _tokenStreamController.add(_fcmToken!);
      }
      
      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        logger.i('FCM Token refreshed: $newToken');
        _fcmToken = newToken;
        _tokenStreamController.add(newToken);
      });
      
    } catch (e) {
      logger.e('Failed to get FCM token: $e');
    }
  }

  /// Set up message handlers for different app states
  void _setupMessageHandlers() {
    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.i('Received foreground message: ${message.messageId}');
      logger.i('Message data: ${message.data}');
      logger.i('Message notification: ${message.notification?.title}');
      
      _messageStreamController.add(message);
      
      // Show local notification when app is in foreground
      _showLocalNotification(message);
    });

    // Handle notification taps when app is in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logger.i('Message clicked from background: ${message.messageId}');
      _handleNotificationTap(message);
    });

    // Handle notification tap when app is terminated
    _handleInitialMessage();
  }

  /// Handle initial message when app is opened from terminated state
  Future<void> _handleInitialMessage() async {
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    
    if (initialMessage != null) {
      logger.i('App opened from terminated state via notification: ${initialMessage.messageId}');
      _handleNotificationTap(initialMessage);
    }
  }

  /// Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;
    
    // Extract title and body from notification or data
    String? title;
    String? body;
    
    if (notification != null) {
      // Use notification field if available
      title = notification.title;
      body = notification.body;
    } else {
      // Extract from data field for data-only notifications
      title = data['title'] as String? ?? 'New Notification';
      body = data['message'] as String? ?? data['body'] as String?;
      
      // Handle business-specific notification formatting
      if (data.containsKey('documentName') && data.containsKey('businessName')) {
        final docName = data['documentName'] as String?;
        final businessName = data['businessName'] as String?;
        
        if (docName == 'INVOICEPAID') {
          title = 'Invoice Payment Received';
          // body is already set from data['message']
        } else if (docName == 'ORDERPLACED') {
          title = 'New Order Placed';
        } else if (docName == 'STOCKLOW') {
          title = 'Low Stock Alert';
        }
        
        // Add business name to title if available
        if (businessName != null && businessName.isNotEmpty) {
          title = '$title - $businessName';
        }
      }
    }
    
    // Only show notification if we have at least a title or body
    if (title != null || body != null) {
      const androidDetails = AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        icon: '@mipmap/ic_launcher',
        color: Color(0xFF1F2024), // App primary color
        enableVibration: true,
        playSound: true,
        autoCancel: true,
      );
      
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        badgeNumber: 1,
        subtitle: 'Zed Nano',
      );
      
      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );
      
      // Generate unique notification ID
      final notificationId = DateTime.now().millisecondsSinceEpoch.remainder(100000);
      
      await _localNotifications.show(
        notificationId,
        title ?? 'Notification',
        body ?? 'You have a new notification',
        notificationDetails,
        payload: jsonEncode(message.data),
      );
      
      logger.i('Local notification displayed: $title - $body');
    } else {
      logger.w('No title or body found for notification, skipping display');
    }
  }

  /// Handle notification tap from local notifications
  void _onNotificationTapped(NotificationResponse response) {
    logger.i('Local notification tapped: ${response.payload}');
    
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        _handleNotificationData(data as Map<String, dynamic>);
      } catch (e) {
        logger.e('Error parsing notification payload: $e');
      }
    }
  }

  /// Handle notification tap from Firebase messages
  void _handleNotificationTap(RemoteMessage message) {
    logger.i('Firebase notification tapped: ${message.data}');
    _handleNotificationData(message.data);
  }

  /// Handle notification data and navigate accordingly
  void _handleNotificationData(Map<String, dynamic> data) {
    logger.i('Handling notification data: $data');
    
    // Extract navigation data
    final screen = data['screen'] as String?;
    final id = data['id'] as String?;
    final documentName = data['documentName'] as String?;
    final documentId = data['documentId'] as String?;
    final businessId = data['businessId'] as String?;
    
    // Determine navigation based on document type or screen
    String? targetScreen = screen;
    String? targetId = id;
    
    // Map document types to screens
    if (documentName != null && targetScreen == null) {
      switch (documentName.toUpperCase()) {
        case 'INVOICEPAID':
        case 'INVOICEDUE':
          targetScreen = 'invoice';
          targetId = documentId;
          break;
        case 'ORDERPLACED':
        case 'ORDERCANCELLED':
          targetScreen = 'order';
          targetId = documentId;
          break;
        case 'STOCKLOW':
          targetScreen = 'inventory';
          break;
        case 'PAYMENTRECEIVED':
          targetScreen = 'payments';
          break;
        default:
          targetScreen = 'home';
      }
    }
    
    // Navigate based on notification data
    if (targetScreen != null) {
      _navigateToScreen(targetScreen, targetId, data);
    }
  }

  /// Navigate to specific screen based on notification data
  void _navigateToScreen(String screen, String? id, [Map<String, dynamic>? data]) {
    logger.i('Navigating to screen: $screen with id: $id');
    
    // Store navigation data for the notification handler
    _pendingNavigation = {
      'screen': screen,
      'id': id,
      'data': data ?? {},
    };
    
    // The actual navigation will be handled by NotificationHandler
    // which has access to the proper BuildContext
  }
  
  // Store pending navigation data
  Map<String, dynamic>? _pendingNavigation;
  
  /// Get and clear pending navigation data
  Map<String, dynamic>? getPendingNavigation() {
    final navigation = _pendingNavigation;
    _pendingNavigation = null;
    return navigation;
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      logger.i('Subscribed to topic: $topic');
    } catch (e) {
      logger.e('Failed to subscribe to topic $topic: $e');
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      logger.i('Unsubscribed from topic: $topic');
    } catch (e) {
      logger.e('Failed to unsubscribe from topic $topic: $e');
    }
  }

  /// Send FCM token to your backend server
  Future<void> sendTokenToServer(String? userId) async {
    if (_fcmToken == null) {
      logger.w('FCM token is null, cannot send to server');
      return;
    }
    
    try {
      // Implement your API call to send token to backend
      // Example:
      // await ApiService().updateFCMToken(userId, _fcmToken!);
      logger.i('FCM token sent to server for user: $userId');
    } catch (e) {
      logger.e('Failed to send FCM token to server: $e');
    }
  }

  /// Clear all notifications
  Future<void> clearAllNotifications() async {
    await _localNotifications.cancelAll();
    logger.i('All notifications cleared');
  }

  /// Dispose resources
  void dispose() {
    _messageStreamController.close();
    _tokenStreamController.close();
  }
}

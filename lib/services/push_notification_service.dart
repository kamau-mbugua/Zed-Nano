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
    final android = message.notification?.android;
    
    if (notification != null) {
      const androidDetails = AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        icon: '@mipmap/ic_launcher',
      );
      
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      
      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );
      
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        notificationDetails,
        payload: jsonEncode(message.data),
      );
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
    
    // Navigate based on notification data
    if (screen != null) {
      _navigateToScreen(screen, id);
    }
  }

  /// Navigate to specific screen based on notification data
  void _navigateToScreen(String screen, String? id) {
    // You'll need to implement navigation logic based on your app's routing
    logger.i('Navigating to screen: $screen with id: $id');
    
    // Example navigation logic (adjust based on your routing setup)
    // final context = navigatorKey.currentContext;
    // if (context != null) {
    //   switch (screen) {
    //     case 'profile':
    //       Navigator.pushNamed(context, '/profile', arguments: id);
    //       break;
    //     case 'chat':
    //       Navigator.pushNamed(context, '/chat', arguments: id);
    //       break;
    //     default:
    //       Navigator.pushNamed(context, '/home');
    //   }
    // }
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

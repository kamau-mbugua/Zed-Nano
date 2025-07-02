import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/firebase_options.dart';

/// A service class that handles Firebase initialization and provides
/// access to Firebase services throughout the app.
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  bool _initialized = false;

  // Firebase instances
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;
  late final FirebaseMessaging messaging;
  late final FirebaseAnalytics analytics;
  late final FirebaseCrashlytics crashlytics;

  // Singleton pattern
  factory FirebaseService() => _instance;

  FirebaseService._internal();

  /// Initializes Firebase services
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      logger.i('Initializing Firebase...');

      // Initialize Firebase with the options from the generated file
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Initialize Firebase services
      auth = FirebaseAuth.instance;
      firestore = FirebaseFirestore.instance;
      storage = FirebaseStorage.instance;
      messaging = FirebaseMessaging.instance;
      analytics = FirebaseAnalytics.instance;
      crashlytics = FirebaseCrashlytics.instance;

      // Configure Crashlytics
      await _configureCrashlytics();

      // Configure messaging
      await _configureMessaging();

      _initialized = true;
      logger.i('Firebase initialized successfully');
    } catch (e, stackTrace) {
      logger.e('Failed to initialize Firebase, $e, $stackTrace');
      // Re-throw the error for the calling code to handle
      rethrow;
    }
  }

  /// Configures Firebase Crashlytics
  Future<void> _configureCrashlytics() async {
    // Enable Crashlytics data collection
    await crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);

    // Pass all uncaught errors to Crashlytics
    FlutterError.onError = (errorDetails) {
      logger.e('Uncaught Flutter error, ${errorDetails.exception}, ${errorDetails.stack}');
      crashlytics.recordFlutterFatalError(errorDetails);
    };
  }

  /// Configures Firebase Cloud Messaging
  Future<void> _configureMessaging() async {
    // Request permission for notifications (iOS)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    logger.i('User granted notification permission: ${settings.authorizationStatus}');

    // Get FCM token
    String? token = await messaging.getToken();
    logger.i('FCM Token: $token');

    // Listen for token refreshes
    messaging.onTokenRefresh.listen((newToken) {
      logger.i('FCM Token refreshed: $newToken');
      // TODO: Send the token to your server
    });
  }

  /// Signs in with email and password
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) {
    return auth.signInWithEmailAndPassword(email: email, password: password);
  }

  /// Creates a new user with email and password
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) {
    return auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  /// Signs out the current user
  Future<void> signOut() {
    return auth.signOut();
  }

  /// Returns the current user
  User? get currentUser => auth.currentUser;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => auth.authStateChanges();

  /// Get FCM token
  Future<String?> getFcmToken() async {
    try {
      return await messaging.getToken();
    } catch (e) {
      logger.e('Failed to get FCM token: $e');
      return null;
    }
  }

  /// Get device ID
  Future<String?> getDeviceId() async {
    try {
      final token = await messaging.getToken();
      if (token == null) return null;
      
      // For Android, we can get the device ID from the token
      // For iOS, you might want to use a different method
      return token.substring(0, 64); // First 64 characters of the token
    } catch (e) {
      logger.e('Failed to get device ID: $e');
      return null;
    }
  }
}

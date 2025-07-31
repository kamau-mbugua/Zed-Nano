import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/firebase_options.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'dart:io';

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

  // Google Sign In instance
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isGoogleSignInInitialized = false;

  // Facebook Auth instance
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

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
    final deviceInfoPlugin = DeviceInfoPlugin();
    String? deviceId;
    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        deviceId = androidInfo.id; // OR use androidInfo.androidId (deprecated on newer Androids)
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      } else {
        deviceId = 'Unsupported Platform';
      }
      return deviceId;
    } catch (e) {
      logger.e('Failed to get device ID: $e');
      return null;
    }
  }

  Future<Map<String, String?>> getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    String? deviceId;
    String? fcmToken;

    try {
      // Get FCM token
      fcmToken = await messaging.getToken();

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        deviceId = androidInfo.id; // OR use androidInfo.androidId (deprecated on newer Androids)
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      } else {
        deviceId = 'Unsupported Platform';
      }

      return {
        'deviceId': deviceId,
        'fcmToken': fcmToken,
      };
    } catch (e) {
      print('Failed to get device info: $e');
      return {
        'deviceId': null,
        'fcmToken': null,
      };
    }
  }

  /// Signs in with Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      if (!_isGoogleSignInInitialized) {
        await _googleSignIn.initialize();
        _isGoogleSignInInitialized = true;
      }

      // Trigger the authentication flow using v7 API
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
        scopeHint: ['email', 'profile'],
      );

      // Obtain the auth details from the request (now synchronous in v7)
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Get authorization for Firebase scopes
      final authClient = _googleSignIn.authorizationClient;
      final authorization = await authClient.authorizationForScopes(['email', 'profile']);

      if (authorization?.accessToken == null || googleAuth.idToken == null) {
        throw Exception('Failed to obtain Google authentication tokens');
      }

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authorization!.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await auth.signInWithCredential(credential);
    } catch (e) {
      logger.e('Google sign-in error: $e');
      rethrow;
    }
  }

  /// Signs in with Facebook
  Future<UserCredential> signInWithFacebook() async {
    final LoginResult result = await _facebookAuth.login();

    if (result.status == LoginStatus.success) {
      final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.tokenString);

      return await auth.signInWithCredential(credential);
    } else {
      throw Exception('Failed to sign in with Facebook');
    }
  }

  /// Signs in with Twitter
  Future<UserCredential> signInWithTwitter() async {
    final OAuthProvider twitterProvider = OAuthProvider('twitter.com');
    
    // You can add additional scopes if needed
    twitterProvider.addScope('email');
    
    return await auth.signInWithProvider(twitterProvider);
  }
}

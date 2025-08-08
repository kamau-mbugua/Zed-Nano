import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/firebase_options.dart';

/// A service class that handles Firebase initialization and provides
/// access to Firebase services throughout the app.
class FirebaseService {

  // Singleton pattern
  factory FirebaseService() => _instance;

  FirebaseService._internal();
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
    final settings = await messaging.requestPermission(
      
    );

    logger.i('User granted notification permission: ${settings.authorizationStatus}');

    // Get FCM token
    final  token = await messaging.getToken();
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
      // Ensure Google Sign-In is initialized (v7 requirement)
      if (!_isGoogleSignInInitialized) {
        await _googleSignIn.initialize();
        _isGoogleSignInInitialized = true;
      }

      // Use authenticate() method for v7 API
      final googleUser = await _googleSignIn.authenticate(
        scopeHint: ['email', 'profile'],
      );

      // Get authentication tokens (only idToken available directly)
      final googleAuth = googleUser.authentication;

      // Get authorization for Firebase scopes to obtain accessToken
      final authClient = _googleSignIn.authorizationClient;
      final authorization = await authClient.authorizationForScopes(['email', 'profile']);

      if (authorization?.accessToken == null || googleAuth.idToken == null) {
        throw Exception('Failed to obtain Google authentication tokens');
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: authorization!.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final userCredential = await auth.signInWithCredential(credential);

      // Log user details for debugging
      final user = userCredential.user;
      if (user != null) {
        logger.i('Google Sign-In Success:');
        logger.i('User ID: ${user.uid}');
        logger.i('User email: ${user.email}');
        logger.i('User display name: ${user.displayName}');
        logger.i('User photo URL: ${user.photoURL}');
        logger.i('Email verified: ${user.emailVerified}');
      }

      return userCredential;
    } catch (e) {
      logger.e('Google sign-in error: $e');
      rethrow;
    }
  }

  /// Signs in with Facebook
  Future<UserCredential> signInWithFacebook() async {
    final result = await _facebookAuth.login();

    if (result.status == LoginStatus.success) {
      final credential = FacebookAuthProvider.credential(result.accessToken!.tokenString);

      return auth.signInWithCredential(credential);
    } else {
      throw Exception('Failed to sign in with Facebook');
    }
  }

  /// Signs in with Twitter
  Future<UserCredential> signInWithTwitter() async {
    final twitterProvider = OAuthProvider('twitter.com');

    // You can add additional scopes if needed
    twitterProvider.addScope('email');

    return auth.signInWithProvider(twitterProvider);
  }
}

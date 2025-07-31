import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/services/firebase_service.dart';
import 'package:zed_nano/routes/routes.dart';

/// Service class for handling social authentication (Google, Facebook, Twitter)
class SocialAuthService {
  static final SocialAuthService _instance = SocialAuthService._internal();
  factory SocialAuthService() => _instance;
  SocialAuthService._internal();

  final FirebaseService _firebaseService = FirebaseService();

  /// Sign up with Google
  /// Returns user data for phone number collection before completing registration
  static Future<Map<String, dynamic>?> signUpWithGoogle(BuildContext context) async {
    try {
      showCustomToast('Signing up with Google...', isError: false);
      
      final firebaseService = FirebaseService();
      final userCredential = await firebaseService.signInWithGoogle();
      final user = userCredential.user;

      if (user == null) {
        showCustomToast('Google sign-up failed. Please try again.', isError: true);
        return null;
      }

      // Get Firebase ID token
      final firebaseIdToken = await user.getIdToken();
      logger.i('Successfully signed up with Google');
      logger.i('Firebase ID token: $firebaseIdToken');
      logger.i('User ID: ${user.uid}');
      logger.i('User email: ${user.email}');
      logger.i('User display name: ${user.displayName}');
      logger.i('User photo URL: ${user.photoURL}');

      return {
        'firebaseIdToken': firebaseIdToken,
        'signinOption': 'google',
        'email': user.email,
        'firstName': user.displayName?.split(' ').first,
        'otherName': user.displayName?.split(' ').skip(1).join(' '),
        'user': user, // Include the Firebase user object if needed
      };

    } catch (e) {
      logger.e('Google sign-up error: $e');
      showCustomToast('Google sign-up failed: ${e.toString()}', isError: true);
      return null;
    }
  }

  /// Sign up with Facebook
  Future<void> signUpWithFacebook(BuildContext context) async {
    try {
      // Show loading
      showCustomToast('Signing in with Facebook...', isError: false);

      // Sign in with Facebook via Firebase
      final UserCredential userCredential = await _firebaseService.signInWithFacebook();
      final User? user = userCredential.user;

      if (user != null) {
        // Get Firebase ID token
        final String? firebaseIdToken = await user.getIdToken();
        
        if (firebaseIdToken != null) {
          // Check if email is verified for Facebook
          if (user.email != null && user.email!.isNotEmpty) {
            // Call your backend API for Firebase signup
            await _firebaseSignup(
              context: context,
              firebaseIdToken: firebaseIdToken,
              signinOption: 'facebook',
              email: user.email,
              firstName: user.displayName?.split(' ').first,
              otherName: user.displayName?.split(' ').skip(1).join(' '),
            );
          } else {
            // Show email verification dialog
            _showVerifyEmailDialog(context);
          }
        } else {
          throw Exception('Unable to get Firebase ID token');
        }
      } else {
        throw Exception('Unable to get user details from Facebook');
      }
    } catch (e) {
      logger.e('Facebook sign up error: $e');
      showCustomToast('Failed to sign in with Facebook: ${e.toString()}');
    }
  }

  /// Sign up with Twitter
  Future<void> signUpWithTwitter(BuildContext context) async {
    try {
      // Show loading
      showCustomToast('Signing in with Twitter...', isError: false);

      // Sign in with Twitter via Firebase
      final UserCredential userCredential = await _firebaseService.signInWithTwitter();
      final User? user = userCredential.user;

      if (user != null) {
        // Get Firebase ID token
        final String? firebaseIdToken = await user.getIdToken();
        
        if (firebaseIdToken != null) {
          // Call your backend API for Firebase signup
          await _firebaseSignup(
            context: context,
            firebaseIdToken: firebaseIdToken,
            signinOption: 'twitter',
            email: user.email,
            firstName: user.displayName?.split(' ').first,
            otherName: user.displayName?.split(' ').skip(1).join(' '),
          );
        } else {
          throw Exception('Unable to get Firebase ID token');
        }
      } else {
        throw Exception('Unable to get user details from Twitter');
      }
    } catch (e) {
      logger.e('Twitter sign up error: $e');
      showCustomToast('Failed to sign in with Twitter: ${e.toString()}');
    }
  }

  /// Call your backend Firebase signup API
  Future<void> _firebaseSignup({
    required BuildContext context,
    required String firebaseIdToken,
    required String signinOption,
    String? email,
    String? firstName,
    String? otherName,
    String? phoneNumber,
  }) async {
    try {
      final authProvider = getAuthProvider(context);

      // Prepare payload similar to your Kotlin implementation
      final Map<String, dynamic> payload = {
        'firebaseIdToken': firebaseIdToken,
      };

      if (email != null) {
        payload['email'] = email;
      }

      if (phoneNumber != null) {
        payload['phoneNumber'] = phoneNumber;
      }

      logger.d('Firebase signup payload: $payload');

      // Call your existing register API or create a new firebaseSignup method
      final response = await authProvider.registerByFirebase(
        requestData: payload,
        context: context,
      );

      if (response.isSuccess) {
        showCustomToast('Registration successful!', isError: false);

        // Navigate to signup details or home based on your flow
        // You might want to show a signup details dialog here
        _showSignupDetailsDialog(
          context: context,
          signinOption: signinOption,
          firebaseIdToken: firebaseIdToken,
          email: email,
          firstName: firstName,
          otherName: otherName,
        );
      } else {
        showCustomToast('Registration failed: ${response.message}');
      }
    } catch (e) {
      logger.e('Firebase signup error: $e');
      showCustomToast('Registration failed: ${e.toString()}');
    }
  }

  /// Call your backend Firebase login API
  Future<void> _firebaseLogin({
    required BuildContext context,
    required String firebaseIdToken,
    required String signinOption,
    String? email,
  }) async {
    try {
      final authProvider = getAuthProvider(context);
      final firebaseService = FirebaseService();
      final fcmToken = await firebaseService.getFcmToken();
      final deviceId = await firebaseService.getDeviceId();

      // Prepare payload similar to your Kotlin implementation
      final Map<String, dynamic> payload = {
        'firebaseIdToken': firebaseIdToken,
      };

      if (email != null) {
        payload['email'] = email;
      }
      payload['fcmToken'] = fcmToken;
      payload['deviceId'] = deviceId;

      logger.d('Firebase login payload: $payload');

      // Call your existing login API or create a new firebaseLogin method
      final response = await authProvider.loginByFirebase(
        requestData: payload,
        context: context,
      );

      if (response.isSuccess) {
        final userName = authProvider.userDetails?.name ??
            authProvider.loginResponse?.username ??
            "User";
        showCustomToast('Welcome back $userName!', isError: false);

        // Navigate to home or wherever appropriate
        Navigator.of(context).pushReplacementNamed(AppRoutes.getHomeMainPageRoute());
      } else {
        showCustomToast('Login failed: ${response.message}');
      }
    } catch (e) {
      logger.e('Firebase login error: $e');
      showCustomToast('Login failed: ${e.toString()}');
    }
  }

  /// Show email verification dialog for Facebook
  void _showVerifyEmailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Verify Email'),
          content: const Text(
            'Your email is not verified. Please login to Facebook to verify your email.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // You can launch Facebook URL here if needed
                showCustomToast('Please verify your email on Facebook');
              },
              child: const Text('Verify'),
            ),
          ],
        );
      },
    );
  }

  /// Show signup details dialog (similar to your SignupDetailsFragment)
  void _showSignupDetailsDialog({
    required BuildContext context,
    required String signinOption,
    required String firebaseIdToken,
    String? email,
    String? firstName,
    String? otherName,
  }) {
    // For now, just navigate to home or show success
    // You can implement a proper dialog/bottom sheet here
    showCustomToast('Welcome! Registration completed successfully.', isError: false);

    // Navigate to home or wherever appropriate
    Navigator.of(context).pop();

  }

  /// Sign in with Google
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Show loading
      showCustomToast('Signing in with Google...', isError: false);

      // Sign in with Google via Firebase
      final UserCredential userCredential = await _firebaseService.signInWithGoogle();
      final User? user = userCredential.user;

      if (user != null) {
        // Get Firebase ID token
        final String? firebaseIdToken = await user.getIdToken();
        
        if (firebaseIdToken != null) {
          // Call your backend API for Firebase login
          await _firebaseLogin(
            context: context,
            firebaseIdToken: firebaseIdToken,
            signinOption: 'google',
            email: user.email,
          );
        } else {
          throw Exception('Unable to get Firebase ID token');
        }
      } else {
        throw Exception('Unable to get user details from Google');
      }
    } catch (e) {
      logger.e('Google sign in error: $e');
      showCustomToast('Failed to sign in with Google: ${e.toString()}');
    }
  }

  /// Sign in with Facebook
  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      // Show loading
      showCustomToast('Signing in with Facebook...', isError: false);

      // Sign in with Facebook via Firebase
      final UserCredential userCredential = await _firebaseService.signInWithFacebook();
      final User? user = userCredential.user;

      if (user != null) {
        // Get Firebase ID token
        final String? firebaseIdToken = await user.getIdToken();
        
        if (firebaseIdToken != null) {
          // Check if email is verified for Facebook
          if (user.email != null && user.email!.isNotEmpty) {
            // Call your backend API for Firebase login
            await _firebaseLogin(
              context: context,
              firebaseIdToken: firebaseIdToken,
              signinOption: 'facebook',
              email: user.email,
            );
          } else {
            // Show email verification dialog
            _showVerifyEmailDialog(context);
          }
        } else {
          throw Exception('Unable to get Firebase ID token');
        }
      } else {
        throw Exception('Unable to get user details from Facebook');
      }
    } catch (e) {
      logger.e('Facebook sign in error: $e');
      showCustomToast('Failed to sign in with Facebook: ${e.toString()}');
    }
  }

  /// Sign in with Twitter
  Future<void> signInWithTwitter(BuildContext context) async {
    try {
      // Show loading
      showCustomToast('Signing in with Twitter...', isError: false);

      // Sign in with Twitter via Firebase
      final UserCredential userCredential = await _firebaseService.signInWithTwitter();
      final User? user = userCredential.user;

      if (user != null) {
        // Get Firebase ID token
        final String? firebaseIdToken = await user.getIdToken();
        
        if (firebaseIdToken != null) {
          // Call your backend API for Firebase login
          await _firebaseLogin(
            context: context,
            firebaseIdToken: firebaseIdToken,
            signinOption: 'twitter',
            email: user.email,
          );
        } else {
          throw Exception('Unable to get Firebase ID token');
        }
      } else {
        throw Exception('Unable to get user details from Twitter');
      }
    } catch (e) {
      logger.e('Twitter sign in error: $e');
      showCustomToast('Failed to sign in with Twitter: ${e.toString()}');
    }
  }

  /// Sign out from all social providers
  Future<void> signOut() async {
    try {
      await _firebaseService.signOut();
      // You might want to sign out from Google and Facebook as well
      // await GoogleSignIn().signOut();
      // await FacebookAuth.instance.logOut();
    } catch (e) {
      logger.e('Sign out error: $e');
    }
  }

  /// Complete Google registration with phone number
  Future<void> completeGoogleRegistration({
    required BuildContext context,
    required Map<String, dynamic> userData,
    required String phoneNumber,
  }) async {
    try {
      showCustomToast('Completing registration...', isError: false);

      // Call the Firebase signup method with the phone number
      await _firebaseSignup(
        context: context,
        firebaseIdToken: userData['firebaseIdToken'] as String,
        signinOption: userData['signinOption'] as String,
        email: userData['email'] as String,
        firstName: userData['firstName'] as String,
        otherName: userData['otherName'] as String,
        phoneNumber: phoneNumber,
      );

    } catch (e) {
      logger.e('Complete Google registration error: $e');
      showCustomToast('Registration failed: ${e.toString()}', isError: true);
    }
  }
}

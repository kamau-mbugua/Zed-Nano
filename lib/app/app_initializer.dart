import 'dart:async';
import 'dart:io';

import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/app/app.dart';
import 'package:zed_nano/app/app_config.dart';
import 'package:zed_nano/di_container.dart' as di;
import 'package:zed_nano/providers/business/BusinessProviders.dart';
import 'package:zed_nano/providers/common/SplashProvider.dart';
import 'package:zed_nano/providers/auth/authenticated_app_providers.dart';
import 'package:zed_nano/providers/common/theme_provider.dart';
import 'package:zed_nano/viewmodels/RefreshViewModel.dart';
import 'package:zed_nano/viewmodels/WorkflowViewModel.dart';
import 'package:zed_nano/services/firebase_service.dart';
import 'package:zed_nano/utils/app_loading.dart';
import 'package:zed_nano/utils/permission_service.dart';

// Global navigator key for accessing navigator from anywhere
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Logger instance
final logger = Logger();

// HTTP overrides for handling SSL certificates
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// Global navigation helper
// Global navigation helper
class Get {
  static BuildContext? get context {
    final context = navigatorKey.currentContext;
    if (context == null) {
      logger.w('⚠️ GetClass Get.context is null');
      return null;
    }
    return context;
  }

  static NavigatorState? get navigator => navigatorKey.currentState;
}

// Initialize the app with common configuration
Future<void> initializeApp(Flavor flavor) async {
  // Set the app flavor
  AppConfig.setFlavor(flavor);
  
  // Log application start
  logger.i('Application started with flavor: ${flavor.name}');

  // Configure HTTP overrides for SSL handling
  HttpOverrides.global = MyHttpOverrides();
  
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    await FirebaseService().initialize();
    logger.i('Firebase initialized successfully');
  } catch (e) {
    logger.e('Failed to initialize Firebase: $e');
    // Continue app initialization even if Firebase fails
  }
  
  // Configure Clarity for analytics
  final config = ClarityConfig(
    projectId: "s2fy2n25wz",
    logLevel: LogLevel.None, // Use LogLevel.Verbose for debugging
  );

  // Request necessary permissions
  await PermissionService().requestPermissions();
  
  // Initialize dependency injection
  await di.init();
  
  // Run the app with all providers
  runApp(ClarityWidget(
    app: MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => di.sl<AuthenticatedAppProviders>()),
        ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
        ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
        ChangeNotifierProvider(create: (context) => di.sl<BusinessProviders>()),
        ChangeNotifierProvider(create: (_) => WorkflowViewModel()),
        ChangeNotifierProvider(create: (_) => RefreshViewModel()),
      ],
      child: App(navigatorKey: navigatorKey),
    ),
    clarityConfig: config,
  ));

  // Initialize loading AFTER MaterialApp is running
  WidgetsBinding.instance.addPostFrameCallback((_) {
    AppLoading.initialize(
      backgroundColor: Colors.black.withOpacity(0.7),
      loaderColor: const Color(0xff032541),
      loaderSize: 60,
      strokeWidth: 5,
    );
  });

}

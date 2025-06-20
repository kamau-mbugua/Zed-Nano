import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/app/app.dart';
import 'package:zed_nano/app/app_config.dart';
import 'package:zed_nano/di_container.dart' as di;
import 'package:zed_nano/providers/SplashProvider.dart';
import 'package:zed_nano/providers/authenticated_app_providers.dart';
import 'package:zed_nano/providers/category_provider.dart';
import 'package:zed_nano/providers/theme_provider.dart';
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
class Get {
  static BuildContext? get context => navigatorKey.currentContext;
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
  
  // Configure Clarity for analytics
  final config = ClarityConfig(
    projectId: "s2fy2n25wz",
    logLevel: LogLevel.None, // Use LogLevel.Verbose for debugging
  );

  // Initialize loading animation
  AppLoading.initialize(
    lottieAssetName: 'assets/loader/loader.json',
    backgroundColor: Colors.black.withOpacity(0.7),
  );

  // Request necessary permissions
  await PermissionService().requestPermissions();
  
  // Initialize dependency injection
  await di.init();
  
  // Run the app with all providers
  runApp(ClarityWidget(
    app: MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
        ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      ],
      child: App(navigatorKey: navigatorKey),
    ),
    clarityConfig: config,
  ));
}

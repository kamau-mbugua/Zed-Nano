import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart' hide getPackageInfo;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/services/business_setup_extensions.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Constants.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/viewmodels/WorkflowViewModel.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  String appVersion = '';
  String appVersionWithBuild = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
    _initiState();
  }

  void _initiState() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      final isNotConnected = result.isEmpty ||
          (result.every((res) => res == ConnectivityResult.none));
      if (isNotConnected) {
        showCustomToast('No internet connection');
      }
    });

    // Initial navigation
    _route();
  }

  Future<void> _initializeBusinessSetup() async {
    if (!mounted) return;

    try {
      // Double-check authentication before initialization
      final authProvider = getAuthProvider(context);
      if (!authProvider.isLoggedIn) {
        logger.w('Attempted to initialize business setup for non-authenticated user');
        return;
      }

      // Initialize business setup service using extension
      await context.businessSetup.initialize();

      // Run workflow setup after initialization
      if (mounted) {
        await Provider.of<WorkflowViewModel>(context, listen: false).skipSetup(context);
      }
    } catch (e) {
      logger.e('Failed to initialize business setup: $e');
      // Don't rethrow - let the app continue to home page even if setup fails
    }
  }

  void _route() {
    Timer(
      const Duration(seconds: 3),
      () async {
        if (mounted) {
          final authProvider = getAuthProvider(context);

          if (authProvider.isLoggedIn) {
            await _initializeBusinessSetup(); // Initialize only when logged in
            await Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.getHomeMainPageRoute(),
              (route) => false,
            );
          } else {
            await Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.getOnBoardingPageRoute(),
              (route) => false,
            );
          }
        }
      },
    );
  }

  Future<void> _loadAppVersion() async {
    // Method 1: Get just the version
    final version = await getAppVersion();

    // Method 2: Get version with build number
    final versionWithBuild = await getAppVersionWithBuild();

    // Method 3: Get full package info (if you need more details)
    final packageInfo = await getPackageInfo();

    setState(() {
      appVersion = version;
      appVersionWithBuild = versionWithBuild;
    });

    // You can also use it without setState for logging or other purposes
    logger.d('AboutZedNano App Name: ${packageInfo.appName}');
    logger.d('AboutZedNano Package Name: ${packageInfo.packageName}');
    logger.d('AboutZedNano Version: ${packageInfo.version}');
    logger.d('AboutZedNano Build Number: ${packageInfo.buildNumber}');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appThemePrimary,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: SvgPicture.asset(splashLogo, fit: BoxFit.cover),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: appThemePrimary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Version ${appVersionWithBuild}',
              style: boldTextStyle(color: Colors.white, fontFamily: 'Poppins', size: 12),
            ),
          ],
        ),
      ),
    );
  }
}

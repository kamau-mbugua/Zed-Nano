import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/services/business_setup_extensions.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/viewmodels/WorkflowViewModel.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  
  String _appVersion = '';

  Future<void> _fetchAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version; // Fetches version from pubspec.yaml
    });
  }

  @override
  void initState() {
    super.initState();
    _initiState();
    _fetchAppVersion();
  }


  void _initiState() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      final bool isNotConnected = result.isEmpty ||
          (result.every((res) => res == ConnectivityResult.none));
      if (isNotConnected) {
        showCustomToast('No internet connection', isError: true);
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
    );
  }
}

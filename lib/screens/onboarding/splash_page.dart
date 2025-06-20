import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/contants/AppConstants.dart';
import 'package:zed_nano/providers/SplashProvider.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/onboarding/onboarding_screen.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Images.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  final GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
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


  void _initiState() async {
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      bool isNotConnected = result.isEmpty ||
          (result[0] != ConnectivityResult.wifi &&
              result[0] != ConnectivityResult.mobile);
      if (!isNotConnected) {
        _globalKey.currentState?.hideCurrentSnackBar();
      }
      _globalKey.currentState?.showSnackBar(SnackBar(
        backgroundColor: isNotConnected ? Colors.red : Colors.green,
        duration: Duration(seconds: isNotConnected ? 6000 : 3),
        content: Text(
          isNotConnected ? 'No internet connection' : 'Connected',
          textAlign: TextAlign.center,
        ),
      ));

      // Navigate if connected
      if (!isNotConnected) {
        _route();
      }
    });

    // Initialize splash data (shared data, etc.)

    _route();
  }

  void _route() {
    Timer(
      const Duration(seconds: 3),
          () async {
        if (mounted) {
          // final authProvider =
          // Provider.of<AuthenticatedAppProviders>(context, listen: false);
          //
          // if (Provider.of<SplashProvider>(context, listen: false)
          //     .getOnBoardingSkip()) {
          //   if (authProvider.isLoggedIn()) {
          //
          //   } else {
          //
          //   }
          // } else {
          //
          // }
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.getLoggingPageRoute(), (route) => false);
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

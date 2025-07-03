import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:zed_nano/l10n/l10n.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/routes/routes_helper.dart';
import 'package:zed_nano/screens/onboarding/splash_page.dart';
import '../app_config.dart';

class App extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const App({super.key, required this.navigatorKey});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    RouterHelper.setupRouter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: AppRoutes.splashRoute,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouterHelper.router.generator,
      scrollBehavior: const MaterialScrollBehavior().copyWith(dragDevices: {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown
      }),
      navigatorKey: widget.navigatorKey,
    );
  }
}

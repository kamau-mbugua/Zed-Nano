import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/auth/forget_password_screen.dart';
import 'package:zed_nano/screens/auth/login_page.dart';
import 'package:zed_nano/screens/auth/registration_page.dart';
import 'package:zed_nano/screens/auth/set_new_pin_page.dart';
import 'package:zed_nano/screens/main/home_main_page.dart';
import 'package:zed_nano/screens/onboarding/onboarding_screen.dart';
import 'package:zed_nano/screens/onboarding/splash_page.dart';

class RouterHelper {
  static final FluroRouter router = FluroRouter();

  static final Handler _splashHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) =>
    const SplashPage(),
  );
  static final Handler _onboardingHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) =>
    const OnboardingScreen(),
  );
  static final Handler _loggingHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) =>
    const LoginPage(),
  );
  static final Handler _userRegistrationHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) =>
    const RegistrationPage(),
  );
  static final Handler _forgetPinHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) =>
    ResetPinScreen(),
  );
  static final Handler _setPinHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) =>
    SetNewPinPage(),
  );

  static final Handler _homeMainHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) =>
        HomeMainPage(),
  );

  static void setupRouter() {
    router.define(
      AppRoutes.splashRoute,
      handler: _splashHandler,
      transitionType: TransitionType.fadeIn,
    );
    
    router.define(
      AppRoutes.onboardingRoute,
      handler: _onboardingHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      AppRoutes.loggingRoute,
      handler: _loggingHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      AppRoutes.userRegistrationRoute,
      handler: _userRegistrationHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      AppRoutes.forgetPinRoute,
      handler: _forgetPinHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      AppRoutes.setPinRoute,
      handler: _setPinHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      AppRoutes.homeMainRoute,
      handler: _homeMainHandler,
      transitionType: TransitionType.fadeIn,
    );
    
    // Define a not found handler
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        return Scaffold(
          body: Center(
            child: Text('Route not found'),
          ),
        );
      },
    );
  }

  // Navigate to a route
  static Future navigateTo(BuildContext context, String routeName,
      {Object? arguments}) {
    return router.navigateTo(context, routeName,
        routeSettings: RouteSettings(arguments: arguments));
  }
}

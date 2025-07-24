import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/auth/forget_password_screen.dart';
import 'package:zed_nano/screens/auth/login_page.dart';
import 'package:zed_nano/screens/auth/registration_page.dart';
import 'package:zed_nano/screens/auth/set_new_pin_page.dart';
import 'package:zed_nano/screens/business/business_profile_screen.dart';
import 'package:zed_nano/screens/business/edit/edit_business_page.dart';
import 'package:zed_nano/screens/business/get_started_page.dart';
import 'package:zed_nano/screens/business/subscription/activating_trial_screen.dart';
import 'package:zed_nano/screens/categories/add/add_category_page.dart';
import 'package:zed_nano/screens/categories/detail/category_detail_page.dart';
import 'package:zed_nano/screens/categories/edit/edit_category_page.dart';
import 'package:zed_nano/screens/categories/list_categories_page.dart';
import 'package:zed_nano/screens/main/home_main_page.dart';
import 'package:zed_nano/screens/onboarding/onboarding_screen.dart';
import 'package:zed_nano/screens/onboarding/splash_page.dart';
import 'package:zed_nano/screens/payments/kcb/add_k_c_b_payment_page.dart';
import 'package:zed_nano/screens/payments/list_payments_page.dart';
import 'package:zed_nano/screens/payments/mpesa/add_mpesa_payment_page.dart';
import 'package:zed_nano/screens/products/add/add_product_page.dart';
import 'package:zed_nano/screens/products/detail/product_detail_page.dart';
import 'package:zed_nano/screens/products/edit/edit_product_page.dart';
import 'package:zed_nano/screens/products/list_categories_page.dart';
import 'package:zed_nano/screens/sell/sell_page.dart';
import 'package:zed_nano/screens/stock/add_stock/add_stock_batch_tabs_page.dart';
import 'package:zed_nano/screens/stock/stock_take/stock_take_batch_tabs_page.dart';
import 'package:zed_nano/screens/stock/view_stock/view_stock_page.dart';
import 'package:zed_nano/screens/stock/view_stock/view_out_of_stock_page.dart';
import 'package:zed_nano/screens/stock/view_stock/view_low_stock_page.dart';

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
  static final Handler _sellPageHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) =>
        SellPage(),
  );
  static final Handler _setPinHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      final settings = ModalRoute.of(context!)!.settings;
      final args = settings.arguments as Map<String, dynamic>?;

      return SetNewPinPage(
        oldPin: args?['oldPin'] as String?,
        userEmail: args?['userEmail'] as String?,
      );
    },
  );

  static final Handler _getStartedHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      // Get the initial step from parameters if provided
      final initialStepStr = params['initialStep']?.first;
      final initialStep = initialStepStr != null ? int.tryParse(initialStepStr) : 0;
      return GetStartedPage(initialStep: initialStep ?? 0);
    },
  );

  static final Handler _homeMainHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) =>
        HomeMainPage(),
  );
  static final Handler _activatingTrialHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) =>
        ActivatingTrialScreen(),
  );
  static final Handler _listCategoriesHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) =>
        ListCategoriesPage(),
  );
  static final Handler _listProductsAndServicesHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) =>
        ListProductsAndServicesPage(),
  );
  static final Handler _addPaymentMethodHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) =>
        AddPaymentMethodScreen(),
  );

  static final Handler _businessProfileScreenHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) =>
        BusinessProfileScreen(),
  );

  static final Handler _editBusinessPageHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) =>
        EditBusinessPage(),
  );

  static final Handler _viewLowStockPageHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) =>
        ViewLowStockPage(),
  );

  static final Handler _viewOutOfStockPageHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) =>
        ViewOutOfStockPage(),
  );

  static final Handler _viewStockPageHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) =>
        ViewStockPage(),
  );

  static final Handler _addStockBatchTabsPageHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) =>
        AddStockBatchTabsPage(),
  );

  static final Handler _addStockTakeBatchTabsPageHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) =>
        StockTakeBatchTabsPage(),
  );

  static final Handler _categoryDetailHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      final categoryId = params['categoryId']?.first ?? '';

      return CategoryDetailPage(
        categoryId: categoryId,
      );

    },
  );
  static final Handler _editCategoryHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      final categoryId = params['categoryId']?.first ?? '';

      return EditCategoryPage(
        categoryId: categoryId,
      );

    },
  );

  static final Handler _newCategoryHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      // Default route without parameters
      return NewCategoryPage(
        doNotUpdate: true,
      );
    },
  );

  static final Handler _newCategoryWithParamHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      // Extract the doNotUpdate parameter from the URL
      final doNotUpdateParam = params['doNotUpdate']?.first ?? 'true';
      final doNotUpdate = doNotUpdateParam.toLowerCase() == 'true';
      
      return NewCategoryPage(
        doNotUpdate: doNotUpdate,
      );
    },
  );

  static final Handler _newProductHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      final doNotUpdateParam = params['doNotUpdate']?.first ?? 'false';
      final doNotUpdate = doNotUpdateParam.toLowerCase() == 'true';
      
      // Extract arguments from route if available
      Map<String, dynamic>? arguments;
      if (context != null && ModalRoute.of(context)?.settings.arguments != null) {
        arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      }
      
      String? selectedCategory;
      String? productService;
      
      if (arguments != null) {
        selectedCategory = arguments['selectedCategory'] as String?;
        productService = arguments['productService'] as String?;
      }

      return AddProductScreen(
        doNotUpdate: doNotUpdate,
        selectedCategory: selectedCategory,
        productService: productService,
      );
    },
  );

  static final Handler _productDetailHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      final productId = params['productId']?.first ?? '';

      return ProductDetailPage(
        productId: productId,
      );

    },
  );

  static final Handler _editProductPageHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      final productId = params['productId']?.first ?? '';

      return EditProductPage(
        productId: productId,
      );

    },
  );

  static final Handler _newAddKCBPaymenHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      final kcbAccountType = params['kcbAccountType']?.first ?? 'KCBACCOUNT';
      return AddKCBPaymentPage(
        kcbAccountType: kcbAccountType,
      );
    },
  );

  static final Handler _newAddMPESAPaymenHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      final mpesaAccountType = params['mpesaAccountType']?.first ?? 'MPESATILL';
      return AddMpesaPaymentPage(
        mpesaAccountType: mpesaAccountType,
      );
    },
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
    // router.define(
    //   '${AppRoutes.getStartedRoute}/:initialStep',
    //   handler: _getStartedHandler,
    //   transitionType: TransitionType.fadeIn,
    // );
    // router.define(
    //   AppRoutes.getStartedRoute,
    //   handler: _getStartedHandler,
    //   transitionType: TransitionType.fadeIn,
    // );
    router.define(
      AppRoutes.homeMainRoute,
      handler: _homeMainHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      AppRoutes.activatingTrialRoute,
      handler: _activatingTrialHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      AppRoutes.sellPageRoute,
      handler: _sellPageHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      AppRoutes.listCategoriesRoute,
      handler: _listCategoriesHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      AppRoutes.listProductsAndServicesRoute,
      handler: _listProductsAndServicesHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      AppRoutes.getNewCategoryRoute,
      handler: _newCategoryHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      AppRoutes.addPaymentMethodRoute,
      handler: _addPaymentMethodHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      AppRoutes.businessProfileScreenRoute,
      handler: _businessProfileScreenHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      AppRoutes.editBusinessScreenRoute,
      handler: _editBusinessPageHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      AppRoutes.viewLowStockScreenRoute,
      handler: _viewLowStockPageHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      AppRoutes.viewOutOfStockScreenRoute,
      handler: _viewOutOfStockPageHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      AppRoutes.viewStockPageScreenRoute,
      handler: _viewStockPageHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      AppRoutes.addStockBatchTabsPageScreenRoute,
      handler: _addStockBatchTabsPageHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      AppRoutes.addStockTakeBatchTabsPageScreenRoute,
      handler: _addStockTakeBatchTabsPageHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      '${AppRoutes.categoryDetailRoute}/:categoryId',
      handler: _categoryDetailHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      '${AppRoutes.editCategoryHRoute}/:categoryId',
      handler: _editCategoryHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      '${AppRoutes.getNewCategoryRoute}/:doNotUpdate',
      handler: _newCategoryWithParamHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      '${AppRoutes.getNewProductWithParamRoute}/:doNotUpdate',
      handler: _newProductHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      '${AppRoutes.productDetailRoute}/:productId',
      handler: _productDetailHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      '${AppRoutes.editProductRoute}/:productId',
      handler: _editProductPageHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      '${AppRoutes.getNewAddKCBPaymenParamRoute}/:kcbAccountType',
      handler: _newAddKCBPaymenHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      '${AppRoutes.getNewAddMPESAPaymenParamRoute}/:mpesaAccountType',
      handler: _newAddMPESAPaymenHandler,
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

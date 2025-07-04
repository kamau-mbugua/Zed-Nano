import 'package:zed_nano/app/app_config.dart';

class AppConstants{
//App Constants
  static const String appVersion = '';
  static const String appDescription = '';

  static String appName = AppConfig.appName;

//API Constants
  static String baseUrl = AppConfig.baseUrl;


  //shared preferences
  static const String onBoardingSkip = 'onBoardingSkip';
  static const String token = 'token';
  static const String refreshToken = 'refreshToken';
  static const String theme = 'theme';
  static const String loginResponse = 'loginResponse';
  static const String userDataResponse = 'userDataResponse';


  //ENDPOINTS
  /// ******AUTHENTICATION ENDPOINTS*******
  static const String login = 'posLoginVersion2';
  static const String register = 'api/addNewUser';
  static const String resetPinVersion = 'api/resetPinVersion2';
  static const String forgotPin = 'posForgotPinVersion2';
  static const String getTokenAfterInvite = 'api/get_token_after_invite';


 /// ******BUSINESS ENDPOINTS*******
  static const String getBusinessInfo = 'api/get_business_info';
  static const String activateFreeTrialPlan = 'api/v1/billing/activate_freetrialplan';
  static const String createBillingInvoice = 'api/v1/billing/businesss/createbilling-invoice';
  static const String uploadBusinessLogo = 'api/edit_business_logo';
  static const String createBusiness = 'postBusiness';
  static const String getSetupStatus = 'api/get_setup_status';
  static const String listBusinessCategory = 'api/listBusinessCategory?state=Active';
  static const String getBusinessPlanPackages = 'api/v1/billing/listbillingplan_packages';






}
import 'package:zed_nano/app/app_config.dart';

class AppConstants{
//App Constants
  static const String appVersion = '';
  static const String appDescription = '';

  static String appName = AppConfig.appName;

//API Constants
  static String baseUrl = AppConfig.baseUrl;
  static String webUrl = AppConfig.webUrl;
  static String domainName = AppConfig.domainName;

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
  static const String doPushStk = 'api/pushstk';
  static const String initiateKcbStkPush = 'api/v1/payments/initiate_kcb_stk_push';
  static const String activateFreeTrialPlan = 'api/v1/billing/activate_freetrialplan';
  static const String createCategory = 'api/createCategory';
  static const String createProduct = 'api/createProduct';
  static const String createBillingInvoice = 'api/v1/billing/businesss/createbilling-invoice';
  static const String enableCashPayment = 'api/activate_cash_payment';
  static const String enableSettleInvoiceStatus = 'api/v1/business/enablesetttleinvoicetstatus';
  static const String addKCBPayment = 'api/v1/payments/activate_kcb_mpesa?status=true';
  static const String addMPESAPayment = 'api/activate_daraja_for_business';
  static const String updateBusinessSetupStatus = 'api/update_business_setup_status';
  static const String branchStoreSummary   = 'api/v1/business/branch-store-summary';
  static const String getBranchTransactionByDate   = 'api/get_branch_transaction_by_date';
  static const String uploadBusinessLogo = 'api/edit_business_logo';
  static const String uploadImage = 'api/v1/ecommerce/generate_file_system_url';
  static const String getPaymentMethodsWithStatus = 'api/get_payment_methods_with_status';
  static const String getListCategories = 'api/listCategories/Active';
  static const String getListProducts = 'api/listProducts/Active';
  static const String createBusiness = 'postBusiness';
  static const String getSetupStatus = 'api/get_setup_status';
  static const String listSubscribedBillingPlans = 'api/v1/billing/listsubscribed_billing_plans';
  static const String listBusinessCategory = 'api/listBusinessCategory?state=Active';
  static const String getBusinessPlanPackages = 'api/v1/billing/listbillingplan_packages';
  static const String getUnitOfMeasure = 'api/v1/products/unitofmeasure/get';
  static const String getVariablePriceStatus = 'api/getVariablePriceStatus';






}
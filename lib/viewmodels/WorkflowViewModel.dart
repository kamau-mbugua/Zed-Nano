import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/models/get_token_after_invite/GetTokenAfterInviteResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/services/business_setup_service.dart';

class WorkflowViewModel with ChangeNotifier {
  bool _showBusinessSetup = false;

  NanoSubscription? _billingPlan;

  bool get showBusinessSetup => _showBusinessSetup;

  String? _workflowState;

  String? get workflowState => _workflowState;

  NanoSubscription? get billingPlan => _billingPlan;

  void setWorkflowState(String? state) {
    logger.d('setWorkflowState Setting workflow state to $state');
    _workflowState = state;
    notifyListeners();
  }

  Future<void> skipSetup(BuildContext context) async {
    try {
      // Get business setup service
      final businessSetupService = Provider.of<BusinessSetupService>(context, listen: false);
      
      // Ensure business setup service is initialized
      if (!businessSetupService.isInitialized) {
        await businessSetupService.initialize();
      }
      
      logger.i('WorkflowViewModel - BusinessSetupService.requiresBusinessSetup: ${businessSetupService.requiresBusinessSetup}');
      
      // Check if business setup is required using the service
      if (businessSetupService.requiresBusinessSetup) {
        logger.i('WorkflowViewModel - Business setup required, showing setup screen');
        _showBusinessSetup = true;
        notifyListeners();
        return;
      }

      // Get providers
      final authProvider = getAuthProvider(context);

      // Get token after invite
      if (authProvider.isLoggedIn) {
        final requestData = {
          'branchId': authProvider.businessDetails?.branchId ?? '',
        };
        await authProvider
            .getTokenAfterInvite(requestData: requestData, context: context)
            .then((value) {
          if (value.isSuccess) {
            final response = value.data!;
            _showBusinessSetup = (response.data?.workflowState == null);
            setWorkflowState(response.data?.workflowState);
            _billingPlan =
                response.data?.businessBillingDetails?.nanoSubscription;
            logger.i('WorkflowViewModelShowBusinessSetup: ${_billingPlan?.toJson()}');
            notifyListeners();
          } else {
            showCustomToast(value.message);
            logger.e('Failed to get token: ${value.message}');
          }
        });
      } else {
        logger.i('User is not logged in');
      }
    } catch (e) {
      logger.e('Error in skipSetup: $e');
    }
  }
}

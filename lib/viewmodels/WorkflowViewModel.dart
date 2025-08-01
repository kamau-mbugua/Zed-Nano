import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/models/get_token_after_invite/GetTokenAfterInviteResponse.dart';
import 'package:zed_nano/models/listbillingplan_packages/BillingPlanPackagesResponse.dart';
import 'package:zed_nano/models/listsubscribed_billing_plans/SubscribedBillingPlansResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';

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
    logger.i("BusinessWorkflowViewModel 1 ${getBusinessDetails(context)!.businessNumber}");

    if (getBusinessDetails(context)!.businessNumber?.isEmptyOrNull ?? true) {
      logger.i("BusinessWorkflowViewModel ${getBusinessDetails(context)!.businessNumber}");
      _showBusinessSetup = true;
      return;
    }

    try {
      // Get providers
      final authProvider = getAuthProvider(context);
      final businessProvider = getBusinessProvider(context);

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
            notifyListeners();
          } else {
            showCustomToast(value.message);
            logger.e("Failed to get token: ${value.message}");
          }
        });
      } else {
        logger.i("User is not logged in");
      }
    } catch (e) {
      logger.e('Error in skipSetup: $e');
    }
  }
}


import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';

class WorkflowViewModel with ChangeNotifier {
  bool _showBusinessSetup = false;
  
  bool get showBusinessSetup => _showBusinessSetup;
  String? _workflowState;

  String? get workflowState => _workflowState;

  void setWorkflowState(String? state) {
    logger.d('setWorkflowState Setting workflow state to $state');
    _workflowState = state;
    notifyListeners();
  }
  
  Future<void> skipSetup(BuildContext context) async {
    try {
      // Get providers
      final authProvider = getAuthProvider(context);
      final businessProvider = getBusinessProvider(context);
      
      // Get token after invite
      if (authProvider.isLoggedIn) {
        await authProvider.getTokenAfterInvite(requestData: {}, context: context);
      }
      
      // Update workflow state
      await businessProvider.getSetupStatus(context: context).then((value) {
        if (value.isSuccess) {
          final response = value.data!;
          _showBusinessSetup = response.data?.workflowState == null;
          setWorkflowState( response.data?.workflowState);
          notifyListeners();
        }
      });
    } catch (e) {
      logger.e('Error in skipSetup: $e');
    }
  }
}

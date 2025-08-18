import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/services/business_setup_service.dart';
import 'package:zed_nano/viewmodels/WorkflowViewModel.dart';

/// Extension methods to make BusinessDetailsContextExtension easier to use throughout the app
extension BusinessDetailsContextExtension on BuildContext {
  /// Get BusinessDetailsContextExtension instance from context
  WorkflowViewModel get businessSetup => Provider.of<WorkflowViewModel>(this, listen: false);

  /// Get BusinessDetailsContextExtension instance with listen parameter
  WorkflowViewModel businessDetailsWith({bool listen = true}) => Provider.of<WorkflowViewModel>(this, listen: listen);

  String get businessAddress => businessSetup.getBusinessAddress();
  String get businessEmail => businessSetup.getBusinessEmail();
  String get businessLogo => businessSetup.getBusinessLogo();
  String get businessPhone => businessSetup.getBusinessPhone();
}
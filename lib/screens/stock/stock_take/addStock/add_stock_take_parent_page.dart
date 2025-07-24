import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/business/create_business/business_created_preview_page.dart';
import 'package:zed_nano/screens/business/create_business/create_business_page.dart';
import 'package:zed_nano/screens/business/subscription/choose_subscription_page.dart';
import 'package:zed_nano/screens/business/subscription/subscription_payment_page.dart';
import 'package:zed_nano/screens/business/wifget/stepper_indicator.dart';
import 'package:zed_nano/screens/sell/select_category_page.dart';
import 'package:zed_nano/screens/stock/add_stock/addStock/steps/category/add_stock_select_category_page.dart';
import 'package:zed_nano/screens/stock/add_stock/addStock/steps/preview/add_stock_preview_page.dart';
import 'package:zed_nano/screens/stock/add_stock/addStock/steps/products/add_stock_products_page.dart';
import 'package:zed_nano/screens/widget/common/reusable_stepper_widget.dart';
import 'package:zed_nano/screens/widget/common/stepper_usage_examples.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/models/createbillingInvoice/CreateBillingInvoiceResponse.dart';
import 'package:zed_nano/viewmodels/WorkflowViewModel.dart';

class AddStockTakeParentPage extends StatefulWidget {
  final int initialStep;

  const AddStockTakeParentPage({
    Key? key,
    this.initialStep = 0,
  }) : super(key: key);

  @override
  State<AddStockTakeParentPage> createState() => _AddStockTakeParentPageState();
}

class _AddStockTakeParentPageState extends State<AddStockTakeParentPage> {
  CreateBillingInvoiceResponse? invoiceData;

  void handleInvoiceCreated(CreateBillingInvoiceResponse invoice) {
    setState(() {
      invoiceData = invoice;
    });
  }

  void _onStepChanged(int currentStep) {
    // Handle step changes if needed
    print('Current step: $currentStep');
  }

  void _onCompleted() {
    // Handle completion - navigate back or show success
    Navigator.of(context).pop();
  }

  void _onCancelled() {
    // Handle cancellation - navigate back
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ReusableStepperWidget(
      initialStep: widget.initialStep,
      onStepChanged: _onStepChanged,
      onCompleted: _onCompleted,
      onCancelled: _onCancelled,
      stepTitles: const [
        'Products',
        'Preview',
      ],
      steps: [
        _AddStockProductsPageWrapper(),
        _AddStockPreviewPageWrapper(),
      ],
    );
  }
}

// Wrapper widgets to integrate with the new stepper system
class _AddStockProductsPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AddStockProductsPage(
      onNext: () => StepperController.nextStep(context),
      onPrevious: () => StepperController.previousStep(context),
    );
  }
}

class _AddStockPreviewPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AddStockPreviewPage(
      onNext: () => StepperController.nextStep(context),
      onPrevious: () => StepperController.previousStep(context),
    );
  }
}

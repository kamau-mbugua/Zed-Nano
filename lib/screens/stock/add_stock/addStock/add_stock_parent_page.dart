import 'package:flutter/material.dart';
import 'package:zed_nano/models/createbillingInvoice/CreateBillingInvoiceResponse.dart';
import 'package:zed_nano/screens/stock/add_stock/addStock/steps/preview/add_stock_preview_page.dart';
import 'package:zed_nano/screens/stock/add_stock/addStock/steps/products/add_stock_products_page.dart';
import 'package:zed_nano/screens/widget/common/reusable_stepper_widget.dart';

class AddStockParentPage extends StatefulWidget {

  const AddStockParentPage({
    super.key,
    this.initialStep = 0,
  });
  final int initialStep;

  @override
  State<AddStockParentPage> createState() => _AddStockParentPageState();
}

class _AddStockParentPageState extends State<AddStockParentPage> {
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

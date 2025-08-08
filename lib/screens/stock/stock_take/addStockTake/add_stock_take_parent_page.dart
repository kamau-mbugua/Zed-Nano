import 'package:flutter/material.dart';
import 'package:zed_nano/models/createbillingInvoice/CreateBillingInvoiceResponse.dart';
import 'package:zed_nano/screens/stock/stock_take/addStockTake/steps/preview/add_stock_take_preview_page.dart';
import 'package:zed_nano/screens/stock/stock_take/addStockTake/steps/products/add_stock_take_products_page.dart';
import 'package:zed_nano/screens/widget/common/reusable_stepper_widget.dart';

class AddStockTakeParentPage extends StatefulWidget {

  const AddStockTakeParentPage({
    super.key,
    this.initialStep = 0,
  });
  final int initialStep;

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
    return AddStockTakeProductsPage(
      onNext: () => StepperController.nextStep(context),
      onPrevious: () => StepperController.previousStep(context),
    );
  }
}

class _AddStockPreviewPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AddStockTakePreviewPage(
      onNext: () => StepperController.nextStep(context),
      onPrevious: () => StepperController.previousStep(context),
    );
  }
}

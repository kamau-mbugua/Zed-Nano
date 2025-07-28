import 'package:flutter/material.dart';
import 'package:zed_nano/screens/payments/checkout_payment/check_out_payments_page.dart';
import 'package:zed_nano/screens/sell/cart_preview_page.dart';
import 'package:zed_nano/screens/sell/sell_page.dart';
import 'package:zed_nano/screens/stock/add_stock/addStock/steps/preview/add_stock_preview_page.dart';
import 'package:zed_nano/screens/stock/add_stock/addStock/steps/products/add_stock_products_page.dart';
import 'package:zed_nano/screens/widget/common/reusable_stepper_widget.dart';
import 'package:zed_nano/models/createbillingInvoice/CreateBillingInvoiceResponse.dart';

class SellStepperPage extends StatefulWidget {
  final int initialStep;
  final String? customerId;

  const SellStepperPage({
    Key? key,
    this.initialStep = 0,
    this.customerId
  }) : super(key: key);

  @override
  State<SellStepperPage> createState() => _SellStepperPageState();
}

class _SellStepperPageState extends State<SellStepperPage> {
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
        'Sell',
        'Preview',
        'Checkout'
      ],
      steps: [
        _SellPageWrapper(),
        _CartPreviewPageWrapper(customerId: widget.customerId),
        _CheckOutPaymentsPageWrapper(),
      ],
    );
  }
}

// Wrapper widgets to integrate with the new stepper system
class _SellPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SellPage(
      onNext: () => StepperController.nextStep(context),
      onPrevious: () => StepperController.previousStep(context),
    );
  }
}

class _CartPreviewPageWrapper extends StatelessWidget {
  final String? customerId;
  
  const _CartPreviewPageWrapper({Key? key, this.customerId}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return CartPreviewPage(
      onNext: () => StepperController.nextStep(context),
      onPrevious: () => StepperController.previousStep(context),
      customerId: customerId,
    );
  }
}

class _CheckOutPaymentsPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CheckOutPaymentsPage(
      onNext: () => StepperController.nextStep(context),
      onPrevious: () => StepperController.previousStep(context),
    );
  }
}

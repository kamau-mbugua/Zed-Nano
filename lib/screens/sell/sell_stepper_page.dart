import 'package:flutter/material.dart';
import 'package:zed_nano/screens/invoices/create_invoice/select_customer_page.dart';
import 'package:zed_nano/screens/invoices/create_invoice/select_invoice_type_page.dart';
import 'package:zed_nano/screens/payments/checkout_payment/check_out_payments_page.dart';
import 'package:zed_nano/screens/sell/cart_preview_page.dart';
import 'package:zed_nano/screens/sell/sell_page.dart';
import 'package:zed_nano/screens/stock/add_stock/addStock/steps/preview/add_stock_preview_page.dart';
import 'package:zed_nano/screens/stock/add_stock/addStock/steps/products/add_stock_products_page.dart';
import 'package:zed_nano/screens/widget/common/reusable_stepper_widget.dart';
import 'package:zed_nano/models/createbillingInvoice/CreateBillingInvoiceResponse.dart';

enum SellStepType{
  Order,
  Invoice
}
class SellStepperPage extends StatefulWidget {
  final int initialStep;
  final String? customerId;
  final Map<String, dynamic>? initialStepData;
  final SellStepType stepType;

  const SellStepperPage({
    Key? key,
    this.initialStep = 0,
    this.customerId,
    this.initialStepData,
    this.stepType = SellStepType.Order
  }) : super(key: key);

  @override
  State<SellStepperPage> createState() => _SellStepperPageState();
}

class _SellStepperPageState extends State<SellStepperPage> {
  CreateBillingInvoiceResponse? invoiceData;
  late Map<String, dynamic> stepData;

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

  void _onStepDataChanged(Map<String, dynamic> data) {
    setState(() {
      stepData = data;
    });
  }

  @override
  void initState() {
    super.initState();
    stepData = widget.initialStepData ?? {};
  }

  @override
  Widget build(BuildContext context) {
    List<String> stepTitles;
    List<Widget> steps;

    if (widget.stepType == SellStepType.Order) {
      stepTitles = const [
        'Sell',
        'Preview',
        'Checkout'
      ];
      steps =  [
        _SellPageWrapper(),
        _CartPreviewPageWrapper(customerId: widget.customerId),
        _CheckOutPaymentsPageWrapper(orderId: stepData['orderId'] as String?),
      ];
    }else{
      stepTitles = const [
        'Customer',
        'InvoiceType',
        'Sell',
        'Preview',
      ];
      steps =  [
        _SelectCustomerPage(),
        _SelectInvoiceTypePage(),
        _SellPageWrapper(),
        _CartPreviewPageWrapper(customerId: widget.customerId),
      ];
    }

    return ReusableStepperWidget(
      initialStep: widget.initialStep,
      onStepChanged: _onStepChanged,
      onCompleted: _onCompleted,
      onCancelled: _onCancelled,
      stepData: stepData,
      onStepDataChanged: _onStepDataChanged,
      stepTitles: stepTitles,
      steps: steps,
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

class _SelectCustomerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SelectCustomerPage(
      onNext: () => StepperController.nextStep(context),
      onPrevious: () => StepperController.previousStep(context),
    );
  }
}
class _SelectInvoiceTypePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SelectInvoiceTypePage(
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
      skipAndClose: () => StepperController.skipAndClose(context),
      customerId: customerId,
    );
  }
}

class _CheckOutPaymentsPageWrapper extends StatelessWidget {
  final String? orderId;
  
  const _CheckOutPaymentsPageWrapper({Key? key, this.orderId}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return CheckOutPaymentsPage(
      onNext: () => StepperController.nextStep(context),
      onPrevious: () => StepperController.previousStep(context),
      orderId: orderId,
    );
  }
}

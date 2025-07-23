import 'package:flutter/material.dart';
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
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/models/createbillingInvoice/CreateBillingInvoiceResponse.dart';
import 'package:zed_nano/viewmodels/WorkflowViewModel.dart';

class AddStockParentPage extends StatefulWidget {
  final int initialStep;

  const AddStockParentPage({
    Key? key,
    this.initialStep = 0,
  }) : super(key: key);

  @override
  State<AddStockParentPage> createState() => _AddStockParentPageState();
}

class _AddStockParentPageState extends State<AddStockParentPage> {
  @override
  void initState() {
    super.initState();
    stepNumber = widget.initialStep;
  }

  int stepNumber = 0;
  CreateBillingInvoiceResponse? invoiceData;


  void goToNextStep() {
    if (stepNumber < 2) {  // Changed from 3 to 2 since array length is 3 (indexes 0,1,2)
      setState(() {
        stepNumber += 1;
      });
    } else {
      Navigator.of(context).pop();
    }
  }


  void goPreviousStep() {
    if (stepNumber > 0) {
      setState(() {
        stepNumber -= 1;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  void handleInvoiceCreated(CreateBillingInvoiceResponse invoice) {
    setState(() {
      invoiceData = invoice;
    });
  }



  @override
  Widget build(BuildContext context) {
    final pages = [
      AddStockSelectCategoryPage(onNext: goToNextStep, onPrevious: goPreviousStep,),
      AddStockProductsPage(onNext: goToNextStep, onPrevious: goPreviousStep,),
      AddStockPreviewPage(onNext: goToNextStep, onPrevious: goPreviousStep,),
    ];

    return Scaffold(
      backgroundColor: colorBackground,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: StepperIndicator(currentStep: stepNumber, totalSteps: 4),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: pages[stepNumber],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

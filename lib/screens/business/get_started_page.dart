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
import 'package:zed_nano/services/business_setup_extensions.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/models/createbillingInvoice/CreateBillingInvoiceResponse.dart';
import 'package:zed_nano/viewmodels/WorkflowViewModel.dart';

class GetStartedPage extends StatefulWidget {
  final int initialStep;
  final bool isExistingPlan;

  const GetStartedPage({
    Key? key,
    this.initialStep = 0,
    this.isExistingPlan = false,
  }) : super(key: key);

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  @override
  void initState() {
    super.initState();
    stepNumber = widget.initialStep;
  }

  int stepNumber = 0;
  CreateBillingInvoiceResponse? invoiceData;

  void goToNextStep() {
    if (stepNumber < 3) {
      setState(() {
        stepNumber += 1;
      });
    }
  }

  void handleInvoiceCreated(CreateBillingInvoiceResponse invoice) {
    setState(() {
      invoiceData = invoice;
    });
  }

  void goSkip() async {
    try {
      // Pop the current screen
      Navigator.pop(context);
      
      // Get the ViewModel and handle the skip operation
      _initializeBusinessSetupAfterCreation(context);
    } catch (e) {
      logger.e('Error in goSkip: $e');
    }
  }

  Future<void> _initializeBusinessSetupAfterCreation(BuildContext context) async {
    try {
      await context.businessSetup.initialize();

      await Provider.of<WorkflowViewModel>(context, listen: false).skipSetup(context);

      Navigator.of(context).pushReplacementNamed(AppRoutes.getHomeMainPageRoute());

    } catch (e) {
      logger.e('Failed to initialize business setup after business creation: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      CreateBusinessPage(onNext: goToNextStep),
      BusinessCreatedPreviewPage(onNext: goToNextStep),
      SubscriptionScreen(
        onNext: goToNextStep, 
        onSkip: goSkip,
        onInvoiceCreated: handleInvoiceCreated,
          isExistingPlan: widget.isExistingPlan,
      ),
      CompleteSubscriptionScreen(
        onSkip: goSkip,
        invoiceData: invoiceData,
      ),
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

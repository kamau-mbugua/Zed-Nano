import 'package:flutter/material.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/business/create_business/business_created_preview_page.dart';
import 'package:zed_nano/screens/business/create_business/create_business_page.dart';
import 'package:zed_nano/screens/business/subscription/choose_subscription_page.dart';
import 'package:zed_nano/screens/business/subscription/subscription_payment_page.dart';
import 'package:zed_nano/screens/business/wifget/stepper_indicator.dart';
import 'package:zed_nano/utils/Colors.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({super.key});

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  int stepNumber = 0;

  void goToNextStep() {
    if (stepNumber < 3) {
      setState(() {
        stepNumber += 1;
      });
    }
  }

  void goSkip(){
    Navigator.pushNamedAndRemoveUntil(context,
        AppRoutes.getActivatingTrialRoute(), (route) => false);

  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      CreateBusinessPage(onNext: goToNextStep),
      BusinessCreatedPreviewPage(onNext: goToNextStep),
      SubscriptionScreen(onNext: goToNextStep, onSkip: goSkip),
      CompleteSubscriptionScreen(onSkip: goSkip),
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

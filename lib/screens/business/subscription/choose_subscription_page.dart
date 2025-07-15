import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/models/business/BusinessDetails.dart';
import 'package:zed_nano/models/listbillingplan_packages/BillingPlanPackagesResponse.dart';
import 'package:zed_nano/models/createbillingInvoice/CreateBillingInvoiceResponse.dart';
import 'package:zed_nano/models/listsubscribed_billing_plans/SubscribedBillingPlansResponse.dart';
import 'package:zed_nano/providers/business/BusinessProviders.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/custom_dialog.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/extensions.dart';

class SubscriptionScreen extends StatefulWidget {
  final VoidCallback onNext, onSkip;
  final bool isExistingPlan;
  final Function(CreateBillingInvoiceResponse) onInvoiceCreated;

  const SubscriptionScreen({
    Key? key,
    required this.onNext,
    required this.onSkip,
    required this.onInvoiceCreated,
    this.isExistingPlan = false,
  }) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int selectedIndex = -1;

  List<BillingPlanPackageGroup>? plans;
  String? noOfFreeTrialDays;
  BusinessDetails? businessDetails;
  SubscribedBillingPlansResponse? subscribedBillingPlansResponse;

  @override
  void initState() {
    businessDetails = getBusinessDetails(context);

    if (widget.isExistingPlan) {
      logger.i(
          "fetchSubscribedBillingPlans called for existing plan ${widget.isExistingPlan}");
      fetchSubscribedBillingPlans();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getBusinessPlanPackages();
    });

    super.initState();
  }

  void fetchSubscribedBillingPlans() {
    logger.i("fetchSubscribedBillingPlans called");
    setState(() {
      subscribedBillingPlansResponse =
          getWorkflowViewModel(context).billingPlan;
    });

    if (subscribedBillingPlansResponse == null) {
      logger.i("fetchSubscribedBillingPlans is NULL");
      getWorkflowViewModel(context).skipSetup(context).then((value) {
        setState(() {
          subscribedBillingPlansResponse =
              getWorkflowViewModel(context).billingPlan;
        });
      });
    }
  }

  Future<void> getBusinessPlanPackages() async {
    await context
        .read<BusinessProviders>()
        .getBusinessPlanPackages(context: context)
        .then((value) async {
      if (value.isSuccess) {
        var businessPlans = value.data?.response;
        setState(() {
          noOfFreeTrialDays = value.data?.noOfFreeTrialDays.toString();
          plans = businessPlans;
        });
      } else {
        showCustomToast(
          value.message ?? 'Something went wrong',
        );
      }
    });
  }

  Future<void> activateFreeTrialPlan() async {
    final businessData = <String, dynamic>{};

    await context
        .read<BusinessProviders>()
        .activateFreeTrialPlan(requestData: businessData, context: context)
        .then((value) async {
      if (value.isSuccess) {
        showCustomToast(value.message.toString(), isError: false);
        widget.onSkip();
      } else {
        showCustomToast(
          value.message ?? 'Something went wrong',
        );
      }
    });
  }

  Future<void> createBillingInvoice() async {
    final businessData = <String, dynamic>{
      'billingPlanPaymentPlanId':
          '${plans?[selectedIndex]?.plans?[0]?.billingPlanPaymentPlanId}',
      'packageId': '${plans?[selectedIndex].plans?[0].packageId}',
      'isChangePlan':widget.isExistingPlan
    };

    await context
        .read<BusinessProviders>()
        .createBillingInvoice(requestData: businessData, context: context)
        .then((value) async {
      if (value.isSuccess) {
        showCustomToast(value.message.toString(), isError: false);
        widget.onInvoiceCreated(value.data!);
        widget.onNext();
      } else {
        showCustomToast(
          value.message ?? 'Something went wrong',
        );
      }
    });
  }

  void _showCancelPlanDialog() {
    showCustomDialog(
      context: context,
      title: 'Cancel Current Plan?',
      subtitle:
          "We're sad to see you leave! Your current plan will remain active until the due date, so you can continue enjoying our services until then.",
      negativeButtonText: 'Cancel',
      positiveButtonText: 'Cancel Plan',
      onNegativePressed: () => Navigator.pop(context),
      onPositivePressed: () {
        // Add subscription cancellation logic here
        Navigator.pop(context); // Close dialog
        showCustomToast("Plan cancelled successfully!", isError: false);
        Navigator.pop(context); // Return to previous screen
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Subscription Plan',
          style: TextStyle(
            color: Color(0xff1f2024),
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            fontSize: 16.0,
          ),
        ),
        actions: widget.isExistingPlan
            ? [
                TextButton(
                  onPressed: _showCancelPlanDialog,
                  child: Text(
                    'Cancel Plan',
                    style: TextStyle(
                      color: Colors.red[700], // Using your accentRed color
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ]
            : null,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // AppBar Section
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headings(
                    label: 'Choose your \nSubscription Plan',
                    subLabel:
                        'Enjoy a free ${noOfFreeTrialDays ?? 0} trial period..',
                  ),
                  const SizedBox(height: 10),

                  // Current subscription info with styled container
                  if (widget.isExistingPlan)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: lightGreyColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current: ${subscribedBillingPlansResponse?.data?[0].billingPeriodName}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  color: darkGreyColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Next Billing Date: ${subscribedBillingPlansResponse?.data![0].dateSubscribed?.toFormattedDate()}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'KES ${subscribedBillingPlansResponse?.data![0].billingPeriodAmount?.formatCurrency()}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              color: darkGreyColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const SizedBox.shrink(),

                  const SizedBox(height: 16),
                  // Subscription List
                  if (plans != null)
                    ...plans!.asMap().entries.map((entry) {
                      var index = entry.key;
                      var plan = entry.value;

                      return GestureDetector(
                        onTap: () => setState(() => selectedIndex = index),
                        child: Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selectedIndex == index
                                      ? const Color(0xff032541)
                                      : Colors.grey.shade300,
                                  width: 1.5,
                                ),
                                color: selectedIndex == index
                                    ? const Color(0xFFF2F4F5)
                                    : Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Radio<int>(
                                    value: index,
                                    groupValue: selectedIndex,
                                    onChanged: (value) =>
                                        setState(() => selectedIndex = value!),
                                    activeColor: const Color(0xff032541),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          plan?.id ?? '',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins',
                                            color: Color(0xff1f2024),
                                          ),
                                        ),
                                        const Visibility(
                                          visible: false,
                                          child: Text(
                                            '0',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Poppins',
                                              color: Color(0xff032541),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${businessDetails?.localCurrency ?? 'KSH'} ${plan?.plans?[0]?.billingPeriodAmount ?? ''}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Poppins',
                                          color: Color(0xff1f2024),
                                        ),
                                      ),
                                      Text(
                                        "every ${plan?.id ?? ''}",
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Poppins',
                                          color: Color(0xff1f2024),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ).paddingSymmetric(horizontal: 1),
                            ),
                            if (plan.isRecommended == true)
                              Positioned(
                                top: -1,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                      SizedBox(width: 0),
                                      Text(
                                        '',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }).toList()
                  else ...[
                    Container(
                      height: 200,
                      child: const Center(
                        child: Text(
                          'No plans found',
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Bottom Buttons
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    outlineButton(
                      text: 'Start ${noOfFreeTrialDays ?? 0} Day Free Trial',
                      onTap: () {
                        activateFreeTrialPlan();
                      },
                      context: context,
                    ).paddingSymmetric(horizontal: 12),
                    10.height,
                    appButton(
                      text: 'Subscribe',
                      onTap: () {
                        if (selectedIndex == -1) {
                          showCustomToast('Please select a plan');
                          return;
                        }
                        createBillingInvoice();
                      },
                      isEnable: selectedIndex != -1,
                      context: context,
                    ).paddingSymmetric(horizontal: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/models/business/BusinessDetails.dart';
import 'package:zed_nano/models/listbillingplan_packages/BillingPlanPackagesResponse.dart';
import 'package:zed_nano/models/createbillingInvoice/CreateBillingInvoiceResponse.dart';
import 'package:zed_nano/providers/business/BusinessProviders.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/utils/Common.dart';

class SubscriptionScreen extends StatefulWidget {
  final VoidCallback onNext, onSkip;
  final Function(CreateBillingInvoiceResponse) onInvoiceCreated;



  const SubscriptionScreen({
    Key? key, 
    required this.onNext, 
    required this.onSkip,
    required this.onInvoiceCreated,
  }) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int selectedIndex = -1;

  List<BillingPlanPackageGroup>? plans;
  String? noOfFreeTrialDays;
  BusinessDetails? businessDetails;


  @override
  void initState() {
    businessDetails = getAuthProvider(context).businessDetails;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getBusinessPlanPackages();
    });
    super.initState();
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
            value.message ?? 'Something went wrong');
      }
    });
  }
  Future<void> activateFreeTrialPlan() async {

    final businessData = <String, dynamic>{};

    await context
        .read<BusinessProviders>()
        .activateFreeTrialPlan(requestData:businessData,context: context)
        .then((value) async {
      if (value.isSuccess) {
        showCustomToast(value.message.toString(), isError: false);
        widget.onSkip();
      } else {
        showCustomToast(
            value.message ?? 'Something went wrong');
      }
    });
  }


  Future<void> createBillingInvoice() async {

    final businessData = <String, dynamic>{
      'billingPlanPaymentPlanId':'${plans?[selectedIndex]?.plans?[0]?.billingPlanPaymentPlanId}',
      'packageId':'${plans?[selectedIndex].plans?[0].packageId}',
    };

    await context
        .read<BusinessProviders>()
        .createBillingInvoice(requestData:businessData,context: context)
        .then((value) async {
      if (value.isSuccess) {
        showCustomToast(value.message.toString(), isError: false);
        widget.onInvoiceCreated(value.data!);
        widget.onNext();
      } else {
        showCustomToast(
            value.message ?? 'Something went wrong');
      }
    });
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
                  const Text(
                    'Choose your \nSubscription Plan',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Color(0xff1f2024),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enjoy a free ${noOfFreeTrialDays ?? 0} trial period.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      color: Color(0xff71727a),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Subscription List
                  if (plans != null) ...plans!.asMap().entries.map((entry) {
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                        Visibility(
                                          visible: false,
                                          child: Text(
                                            '0',
                                            style: const TextStyle(
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
                                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
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
                      child: Center(
                        child: Text(
                          'No plans found',),
                      ),
                    )
                  ]
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
                            context: context)
                        .paddingSymmetric(horizontal: 12),
                    10.height,
                    appButton(
                            text: 'Subscribe',
                            onTap: () {
                              if (selectedIndex == -1) {
                                showCustomToast("Please select a plan");
                                return;
                              }
                              createBillingInvoice();
                            },
                        isEnable: selectedIndex != -1,
                            context: context)
                        .paddingSymmetric(horizontal: 12),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/utils/Common.dart';

class SubscriptionPlan {
  final String title;
  final String price;
  final String frequency;
  final String discount;
  final bool isRecommended;

  SubscriptionPlan({
    required this.title,
    required this.price,
    required this.frequency,
    required this.discount,
    this.isRecommended = false,
  });
}

class SubscriptionScreen extends StatefulWidget {
  final VoidCallback onNext, onSkip;

  const SubscriptionScreen({Key? key, required this.onNext, required this.onSkip}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int selectedIndex = -1;

  final List<SubscriptionPlan> plans = [
    SubscriptionPlan(
      title: 'Yearly',
      price: 'KES 10,000.00',
      frequency: 'every year',
      discount: '~36% discount',
    ),
    SubscriptionPlan(
      title: 'Quarterly',
      price: 'KES 1000.00',
      frequency: 'every 3 months',
      discount: '~23% discount',
      isRecommended: true,
    ),
    SubscriptionPlan(
      title: 'Monthly',
      price: 'KES 300.00',
      frequency: 'every week',
      discount: '',
    ),
  ];

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
            fontFamily: "Poppins",
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
                      fontFamily: "Poppins",
                      color: Color(0xff1f2024),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Enjoy a free 7-day trial period.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins",
                      color: Color(0xff71727a),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Subscription List
                  ...plans.asMap().entries.map((entry) {
                    int index = entry.key;
                    SubscriptionPlan plan = entry.value;

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
                                        plan.title,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Poppins",
                                          color: Color(0xff1f2024),
                                        ),
                                      ),
                                      if (plan.discount.isNotEmpty)
                                        Text(
                                          plan.discount,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Poppins",
                                            color: Color(0xff032541),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      plan.price,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Poppins",
                                        color: Color(0xff1f2024),
                                      ),
                                    ),
                                    Text(
                                      plan.frequency,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Poppins",
                                        color: Color(0xff1f2024),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ).paddingSymmetric(horizontal: 1),
                          ),
                          if (plan.isRecommended)
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
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
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
                            text: "Start 14-Day Free Trial",
                            onTap: () {
                              widget.onSkip();
                            },
                            context: context)
                        .paddingSymmetric(horizontal: 12),
                    10.height,
                    appButton(
                            text: "Subscribe",
                            onTap: () {
                              widget.onNext();
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

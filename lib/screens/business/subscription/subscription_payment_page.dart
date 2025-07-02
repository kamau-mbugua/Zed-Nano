import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/common/sub_category_picker.dart';
import 'package:zed_nano/screens/widget/payment/card_number_field.dart';
import 'package:zed_nano/utils/Common.dart';



class CompleteSubscriptionScreen extends StatefulWidget {
  final VoidCallback onSkip;

  const CompleteSubscriptionScreen({super.key, required this.onSkip});

  @override
  State<CompleteSubscriptionScreen> createState() => _CompleteSubscriptionScreenState();
}

class _CompleteSubscriptionScreenState extends State<CompleteSubscriptionScreen> {
  String selectedPayment = 'Credit Card';
  String selectedYear = '';
  String selectedMonth = '';

  final List<String> paymentMethods = ['Credit Card', 'MPESA'];

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
            // Main Scroll View
            Positioned.fill(
              top: 1,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Complete Your Subscription",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins",
                        color: Color(0xff1f2024),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Enjoy a free 7-day trial period.",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                        color: Color(0xff71727a),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Plan Box
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xfff5f7f8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Monthly Plan",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff1f2024)),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Next Billing: 20 July 2025",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      color: Color(0xff71727a)),
                                )
                              ]),
                          Text(
                            "KES 1000.00",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              color: Color(0xff1f2024),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Expandable Payment Options
                    ...paymentMethods.map((method) => _buildPaymentOption(method)).toList(),

                    const SizedBox(height: 40),

                    // Subscribe Button
                    appButton(
                        text: "Subscribe",
                        onTap: () {
                          widget.onSkip();
                        },
                        context: context)
                        .paddingSymmetric(horizontal: 1),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String method) {
    bool selected = selectedPayment == method;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = method;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? Color(0xffdcdcdc) : Color(0xffdcdcdc),
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  selected ? Icons.radio_button_checked : Icons.radio_button_off,
                  size: 20,
                  color: selected ? Color(0xff032541) : Colors.grey,
                ),
                SizedBox(width: 12),
                Text(
                  method,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: selected ? Color(0xff1f2024) : Color(0xff71727a),
                  ),
                ),
              ],
            ),
            if (selected && method == 'Credit Card') ...[
              const SizedBox(height: 16),
              CardNumberField().paddingSymmetric(horizontal: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child:  SubCategoryPicker(
                      label: 'Month',
                      options: List.generate(
                        12,
                            (index) {
                          final month = index + 1;
                          return month.toString();
                            }
                      ),
                      selectedValue: selectedMonth,
                      onChanged: (value) {
                        final selectedCat = value;
                        setState(() {
                          selectedMonth = selectedCat;
                        });
                      },
                    ).paddingSymmetric(horizontal: 1),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child:  SubCategoryPicker(
                      label: 'Year',
                      options: List.generate(
                        10,
                            (index) {
                          final year = DateTime.now().year + index;
                          return year.toString();
                            }
                      ),
                      selectedValue: selectedYear,
                      onChanged: (value) {
                        final selectedCat = value;
                        setState(() {
                          selectedYear = selectedCat;
                        });
                      },
                    ).paddingSymmetric(horizontal: 1),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: const StyledTextField(
                      textFieldType: TextFieldType.EMAIL,
                      hintText: "CVV",
                      maxLength: 3,  // Limits input to 50 characters
                      showCounter: true,
                    ).paddingSymmetric(horizontal: 1),
                  )
                ],
              )
            ]else if (selected && method == 'MPESA') ...[
              10.height,
              PhoneInputField().paddingSymmetric(horizontal: 2),
            ]
          ],
        ),
      ),
    );
  }

  Widget progressBarSegment({bool filled = true, int flex = 0}) {
    return Expanded(
      flex: flex == 0 ? 2 : flex,
      child: Container(
        height: 8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: filled ? Color(0xff17ae7b) : Color(0xffe7e8ec),
        ),
      ),
    );
  }
}

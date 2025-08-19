import 'package:flutter/material.dart';
import 'package:zed_nano/utils/Colors.dart';

class StepperIndicator extends StatelessWidget {

  const StepperIndicator({
    required this.currentStep, super.key,
    this.totalSteps = 4,
  });
  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isActive = index <= currentStep;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 5,
            decoration: BoxDecoration(
              color: isActive ? successTextColor : const Color(0xffe4e4ed),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }),
    );
  }
}

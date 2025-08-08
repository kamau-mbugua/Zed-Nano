import 'package:flutter/material.dart';

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
              color: isActive ? const Color(0xff00c382) : const Color(0xffe4e4ed),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }),
    );
  }
}

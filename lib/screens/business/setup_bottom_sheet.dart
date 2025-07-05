import 'package:flutter/material.dart';

class SetupBottomSheet extends StatelessWidget {
  final String step;

  SetupBottomSheet({required this.step});

  final List<String> steps = [
    "Create a Business",
    "Settup Billing",
    "Add Categories",
    "Add Products and Services",
    "Setup Payment Methods",
  ];

  int get activeStepIndex {
    switch (step) {
      case "Basic":
        return 1;
      case "Billing":
        return 2;
      case "Category":
        return 3;
      case "Products":
        return 4;
      default:
        return 0;
    }
  }

  Color getIconColor(int index) {
    if (index < activeStepIndex) return const Color(0xff17ae7b); // Completed (green)
    if (index == activeStepIndex) return const Color(0xff032541); // Active (dark blue)
    return const Color(0xffc5c6cc); // Inactive (gray)
  }

  Color getTextColor(int index) {
    if (index < activeStepIndex || index == activeStepIndex) {
      return const Color(0xff1f2024);
    }
    return const Color(0xffc5c6cc);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 72, bottom: 24),
      child: Stack(
        children: [
          // Title Section
          Positioned(
            top: 0,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Complete Setup',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: Color(0xff1f2024),
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  child: Stack(
                    children: [
                      Transform.rotate(
                        angle: 1.57,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xffffb37c),
                              width: 5,
                            ),
                          ),
                        ),
                      ),
                      Transform.rotate(
                        angle: 1.57,
                        child: Container(
                          margin: const EdgeInsets.only(left: 12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xffe86339),
                              width: 5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          // Step Count and Description
          Positioned(
            top: 40,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '3 Steps Away',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: Color(0xff1f2024),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Select a step to begin.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    color: Color(0xff71727a),
                  ),
                ),
              ],
            ),
          ),

          // Step List
          Positioned(
            top: 96,
            left: 0,
            right: 0,
            child: Column(
              children: List.generate(steps.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: getIconColor(index),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Text(
                        steps[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          color: getTextColor(index),
                        ),
                      )
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

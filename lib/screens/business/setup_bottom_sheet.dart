import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';

class SetupStepBottomSheet extends StatelessWidget {
  final String currentStep;

  SetupStepBottomSheet({required this.currentStep});

  final List<String> steps = [
    "Create a Business",
    "Settup Billing",
    "Add Categories",
    "Add Products and Services",
    "Setup Payment Methods",
  ];

  int get activeIndex {
    switch (currentStep) {
      case "basic":
        return 1;
      case "billing":
        return 2;
      case "category":
        return 3;
      case "products":
        return 4;
      default:
        return 0;
    }
  }



  double get getValue {
    switch (currentStep) {
      case "basic":
        return 0.2;
      case "billing":
        return 0.4;
      case "category":
        return 0.6;
      case "products":
        return 0.8;
      default:
        return 1.0;
    }
  }


  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.9,
      maxChildSize: 1.0,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 16),
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xffe0e0e0),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ), // Rest of the content
               Row(
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                        Icons.close,
                        color: Color(0xff032541),
                        size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '3 Steps Away',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: Color(0xff1f2024),
                        ),
                      ),
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
                  CircularProgressIndicator(
                    value: getValue,
                    strokeWidth: 5,
                    valueColor: const AlwaysStoppedAnimation(Color(0xffe86339)),
                    backgroundColor: const Color(0xffffb37c),
                  )
                ],
              ),


              const SizedBox(height: 10),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                child: ListView.builder(
                  itemCount: steps.length,
                  itemBuilder: (context, index) {
                    return borderWidget(
                      index: index,
                      activeIndex: activeIndex,
                      steps: steps,
                      onTab: (index) {
                        //get the step name
                        String stepName = steps[index as int];
                        switch (stepName) {
                          case "Create a Business":
                            logger.d("Create a Business" );
                            break;
                          case "Settup Billing":
                            logger.d("Settup Billing" );
                            break;
                          case "Add Categories":
                            logger.d("Add Categories" );
                            break;
                          case "Add Products and Services":
                            logger.d("Add Products and Services" );
                            break;
                          case "Setup Payment Methods":
                            logger.d("Setup Payment Methods" );
                            break;
                          default:
                            break;
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/business/get_started_page.dart';
import 'package:zed_nano/screens/widget/common/base_bottom_sheet.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';

class SetupStepBottomSheet extends StatelessWidget {

  SetupStepBottomSheet({required this.currentStep, super.key});
  final String currentStep;

  final List<String> steps = [
    'Create a Business',
    'Setup Billing',
    'Add Categories',
    'Add Products and Services',
    'Setup Payment Methods',
  ];

  int get activeIndex {
    switch (currentStep) {
      case 'basic':
        return 1;
      case 'billing':
        return 2;
      case 'category':
        return 3;
      case 'product':
        return 4;
      default:
        return 0;
    }
  }



  double get getValue {
    switch (currentStep) {
      case 'basic':
        return 0.2;
      case 'billing':
        return 0.4;
      case 'category':
        return 0.6;
      case 'products':
        return 0.8;
      default:
        return 1;
    }
  }


  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      title: 'Complete Setup',
      initialChildSize: 0.6,
      headerContent: Row(
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
          ),
        ],
      ),
      bodyContent: SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        child: ListView.builder(
          itemCount: steps.length,
          itemBuilder: (context, index) {
            return borderWidget(
              index: index,
              activeIndex: activeIndex,
              steps: steps,
              onTab: (index) async {
                //get the step name
                Navigator.pop(context);
                final stepName = steps[index as int];
                switch (stepName) {
                  case 'Create a Business':
                    const GetStartedPage(initialStep:1).launch(context);
                    logger.d('Create a Business' );
                  case 'Setup Billing':
                    const GetStartedPage(initialStep:2).launch(context);
                    logger.d('Setup Billing' );
                  case 'Add Categories':
                    logger.d('Add Categories' );

                    //if its active
                    if(index == activeIndex) {
                      // Show the bottom sheet
                      await Navigator.pushNamed(context, AppRoutes.getNewCategoryWithParamRoutes('false'));
                    }else{
                      await Navigator.pushNamed(context, AppRoutes.getListCategoriesRoute());
                    }

                    // BottomSheetHelper.showProductServiceCategoryBottomSheet(context);
                  case 'Add Products and Services':
                    if(index == activeIndex) {
                      // Show the bottom sheet
                      await Navigator.pushNamed(context, AppRoutes.getNewProductWithParamRoutes('false'));
                    }else{
                      Navigator.pushNamed(
                          context, AppRoutes.getListProductsAndServicesRoute(),);
                    }

                    logger.d('Add Products and Services' );
                  case 'Setup Payment Methods':
                    logger.d('Setup Payment Methods' );
                    Navigator.pushNamed(context, AppRoutes.getAddPaymentMethodRoute());
                  default:
                    break;
                }
              },
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/screens/widget/common/base_bottom_sheet.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';

class ProductServiceCategoryBottomSheet extends StatelessWidget {
  ProductServiceCategoryBottomSheet({super.key});


  final List<String> steps = [
    'Add Products Categories',
    'Add Services Categories',
  ];


  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      title: 'Products and Services',
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 1.0,
      headerContent:  const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Product or Service',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: Color(0xff1f2024),
            ),
          ),
          Text(
            'Select an option to proceed.',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              color: Color(0xff71727a),
            ),
          ),
        ],
      ).paddingTop(16),
      bodyContent: SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        child: ListView.builder(
          itemCount: steps.length,
          itemBuilder: (context, index) {
            return arrowListItem(
              index: index,
              steps: steps,
              onTab: (index) {
                //get the step name
                String stepName = steps[index as int];
                switch (stepName) {
                  case 'Add Products Categories':
                    logger.d('Add Products Categories' );
                    break;
                  case 'Add Services Categories':
                    logger.d('Add Services Categories' );
                    break;
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

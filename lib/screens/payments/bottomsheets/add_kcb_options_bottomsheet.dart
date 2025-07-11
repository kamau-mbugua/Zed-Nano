import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/widget/common/base_bottom_sheet.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';

class AddKcbOptionsBottomsheet extends StatelessWidget {
  AddKcbOptionsBottomsheet({super.key});


  final List<String> steps = [
    'I have a KCB Vooma Till.',
    'I have a KCB Account.',
  ];


  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      title: 'Setup Options',
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 1.0,
      headerContent:  const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'KCB Mobile Money',
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
              onTab: (index) async {
                //get the step name
                String stepName = steps[index as int];
                switch (stepName) {
                  case 'I have a KCB Vooma Till.':
                    Navigator.pop(context); // Close the bottom sheet first
                    await Navigator.pushNamed(context, AppRoutes.getNewAddKCBPaymentParamRoute('VOOMATILL'));
                    break;
                  case 'I have a KCB Account.':
                    Navigator.pop(context); // Close the bottom sheet first
                    await Navigator.pushNamed(context, AppRoutes.getNewAddKCBPaymentParamRoute('KCBACCOUNT'));
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

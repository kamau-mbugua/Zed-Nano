import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/widget/common/base_bottom_sheet.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';

class AddMpesaOptionsBottomsheet extends StatelessWidget {
  AddMpesaOptionsBottomsheet({super.key});


  final List<String> steps = [
    'I have MPESA Paybill Number.',
    'I have MPESA Till Number.',
  ];


  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      title: 'Setup Options',
      initialChildSize: 0.5,
      headerContent:  const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MPESA Setup',
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
                final stepName = steps[index as int];
                switch (stepName) {
                  case 'I have MPESA Paybill Number.':
                    Navigator.pop(context); // Close the bottom sheet first
                    await Navigator.pushNamed(context, AppRoutes.getNewAddMPESAPaymentParamRoute('MPESAPAYBILL'));
                  case 'I have MPESA Till Number.':
                    Navigator.pop(context); // Close the bottom sheet first
                    await Navigator.pushNamed(context, AppRoutes.getNewAddMPESAPaymentParamRoute('MPESATILL'));
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

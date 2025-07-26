import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/screens/widget/common/base_bottom_sheet.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';

class PrintingOptionsBottomSheet extends StatelessWidget {
  String? printOrderInvoiceId;
  PrintingOptionsBottomSheet({Key? key, this.printOrderInvoiceId}) : super(key: key);


  final List<String> steps = [
    'Send to POS',
    'Generate PDF',
  ];


  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      title: 'More Actions',
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 1.0,
      headerContent:  const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  case 'Send to POS':
                    // Navigator.pushNamed(context, AppRoutes.getNewCategoryRoutes());
                    break;
                  case 'Generate PDF':
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

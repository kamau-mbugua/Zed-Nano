import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/branchTerminals/BranchTerminalsResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/widget/common/base_bottom_sheet.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';

class PrintingOptionsBottomSheet extends StatefulWidget {
  String? printOrderInvoiceId;
  PrintingOptionsBottomSheet({Key? key, this.printOrderInvoiceId}) : super(key: key);

  @override
  State<PrintingOptionsBottomSheet> createState() => _PrintingOptionsBottomSheetState();
}

class _PrintingOptionsBottomSheetState extends State<PrintingOptionsBottomSheet> {

  BranchTerminalsResponse? branchTerminalsResponse;
  List<BranchTerminalsData>? branchTerminalsDataList;

  final List<String> steps = [
    'Generate PDF',
  ];



  @override
  void initState() {
    super.initState();
    // Defer the first data fetch until after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getBranchTerminals();
    });
  }

  Future<void> getBranchTerminals() async {

    try {
      final response =
      await getBusinessProvider(context).getBranchTerminals(context: context);

      if (response.isSuccess ) {
        if ( response.data?.data?.isNotEmpty == true) {
          setState(() {
            branchTerminalsResponse = response.data;
            branchTerminalsDataList = response.data?.data;
            steps.add('Send to POS');
          });
        } else {
          showCustomToast('No active terminals attached to this business');
        }


      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      showCustomToast('Failed to load Order details');
    }
  }

  Future<void> doSendToPos() async {

    var requestData = <String, dynamic>{
      'pushTransactionId': widget.printOrderInvoiceId,
      'serialNo': branchTerminalsDataList?.first?.terminalSerialNumber
    };

    try {
      final response =
      await getBusinessProvider(context).doSendToPos(requestData: requestData,context: context);

      if (response.isSuccess) {
        showCustomToast(response.message, isError: false);
        finish(context);
      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      showCustomToast('Failed to load Order details');
    }
  }


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
              onTab: (index) async {
                //get the step name
                String stepName = steps[index as int];
                switch (stepName) {
                  case 'Send to POS':
                    // Navigator.pushNamed(context, AppRoutes.getNewCategoryRoutes());
                  await doSendToPos();
                    break;
                  case 'Generate PDF':
                    showCustomToast('PDF Coming soon', isError: false);
                    finish(context);
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

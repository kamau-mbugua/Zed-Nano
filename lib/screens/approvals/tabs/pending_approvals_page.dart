import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/models/approval_data.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/approvals/itemBuilders/approval_types.dart';
import 'package:zed_nano/screens/approvals/stock_take/stock_take_approval.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Images.dart';

class PendingApprovalsPage extends StatefulWidget {
  String? getStatus;
  PendingApprovalsPage({Key? key, this.getStatus}) : super(key: key);

  @override
  _PendingApprovalsPageState createState() => _PendingApprovalsPageState();
}

class _PendingApprovalsPageState extends State<PendingApprovalsPage> {

  // Mock data for testing purposes
  List<ApprovalData>? approvalData = [
    ApprovalData(name: 'Stock Take', count: '12'),
    ApprovalData(name: 'Add Stock', count: '8'),
    ApprovalData(name: 'Users', count: '5'),
    ApprovalData(name: 'Customers', count: '3'),
  ];

  @override
  void initState() {
    super.initState();
    // Defer the first data fetch until after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getApprovalByStatus();
    });
  }

  Future<void> getApprovalByStatus() async {
    Map<String, dynamic> requestData = {
      'status': widget.getStatus
    };

    try {
      final response =
      await getBusinessProvider(context).getApprovalByStatus(requestData: requestData, context: context);

      if (response.isSuccess) {
        setState(() {
          approvalData = response.data?.data ?? [];
        });
      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      showCustomToast('Failed to load Order details');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:  RefreshIndicator(
        onRefresh: () async {
          await getApprovalByStatus();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            headings(
              label: 'Select Category',
              subLabel: 'Select a category to view pending requests.',
              textSizeTitle: 16,
              textSizeSubTitle: 14,
            ),
            _createListView(),
          ],
        ).paddingSymmetric(horizontal: 16),
      ),
    );
  }
  Widget _createListView() {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 items per row
          crossAxisSpacing: 12, // Horizontal spacing between items
          mainAxisSpacing: 12, // Vertical spacing between rows
          childAspectRatio: 1.6, // Width to height ratio for each item
        ),
        itemCount: approvalData?.length ?? 0,
        itemBuilder: (context, index) {
          return createListItem(
            approvalData?[index],
            widget.getStatus ?? '',
            onTap: (){
              logger.d('Selected Approval: ${approvalData?[index]?.name}');
              if(approvalData?[index]?.name == 'Stock Take'){
                StockTakeApproval().launch(context);
              }
            },);
        },
      ),
    );
  }

}

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/approval_data.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/approvals/add_stock/add_stock_approval_approved.dart';
import 'package:zed_nano/screens/approvals/customers/customers_approved_approval_page.dart';
import 'package:zed_nano/screens/approvals/itemBuilders/approval_types.dart';
import 'package:zed_nano/screens/approvals/stock_take/stock_take_approval_approved.dart';
import 'package:zed_nano/screens/approvals/users/add_users_approved_approval_page.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';

class ApprovedApprovalsPage extends StatefulWidget {

  ApprovedApprovalsPage({super.key, this.getStatus});
  String? getStatus;

  @override
  _ApprovedApprovalsPageState createState() => _ApprovedApprovalsPageState();
}

class _ApprovedApprovalsPageState extends State<ApprovedApprovalsPage> {
  List<ApprovalData>? approvalData;

  @override
  void initState() {
    super.initState();
    // Defer the first data fetch until after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getApprovalByStatus();
    });
  }

  Future<void> getApprovalByStatus() async {
    final requestData = <String, dynamic>{'status': widget.getStatus};

    try {
      final response = await getBusinessProvider(context)
          .getApprovalByStatus(requestData: requestData, context: context);

      if (response.isSuccess) {
        setState(() {
          final approvalListData = response.data?.data;
          approvalData = [
            ApprovalData(
                name: 'Stock Take',
                count: approvalListData?.stockTakeCount.toString(),),
            ApprovalData(
                name: 'Add Stock',
                count: approvalListData?.addStockCount.toString(),),
            ApprovalData(
                name: 'Users', count: approvalListData?.usersCount.toString(),),
            ApprovalData(
                name: 'Customers',
                count: approvalListData?.customersCount.toString(),),
          ];
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
      body: RefreshIndicator(
        onRefresh: () async {
          await getApprovalByStatus();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            onTap: () {
              if (approvalData?[index].name == 'Stock Take') {
                const StockTakeApprovalApproved().launch(context);
              }
              if (approvalData?[index].name == 'Add Stock') {
                const AddStockApprovalApproved().launch(context);
              }
              if (approvalData?[index].name == 'Users') {
                const AddUsersApprovedApprovalPageState().launch(context);
              }
              if (approvalData?[index].name == 'Customers') {
                const CustomersApprovedApprovalPageState().launch(context);
              }
            },
          );
        },
      ),
    );
  }
}

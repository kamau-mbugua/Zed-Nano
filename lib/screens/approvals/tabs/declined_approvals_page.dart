import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/approval_data.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/approvals/add_stock/add_stock_approval_declined.dart';
import 'package:zed_nano/screens/approvals/customers/customers_declined_approval_page.dart';
import 'package:zed_nano/screens/approvals/itemBuilders/approval_grid_view.dart';
import 'package:zed_nano/screens/approvals/stock_take/stock_take_approval_declined.dart';
import 'package:zed_nano/screens/approvals/users/add_users_declined_approval_page.dart';
import 'package:zed_nano/screens/approvals/voided_transactions/declined_voided_transactions_page.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';

class DeclinedApprovalsPage extends StatefulWidget {

  DeclinedApprovalsPage({super.key, this.getStatus});
  String? getStatus;

  @override
  _DeclinedApprovalsPageState createState() => _DeclinedApprovalsPageState();
}

class _DeclinedApprovalsPageState extends State<DeclinedApprovalsPage> {
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
            ApprovalData(
              name: 'Voided Transactions',
              count: approvalListData?.voidedTransactions.toString(),),
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
            ApprovalGridView(
              approvalData: approvalData,
              status: widget.getStatus ?? '',
              onItemTap: _handleApprovalItemTap,
            ),
          ],
        ).paddingSymmetric(horizontal: 16),
      ),
    );
  }

  void _handleApprovalItemTap(ApprovalData item) {
    if (item.name == 'Stock Take') {
      const StockTakeApprovalDeclined().launch(context);
    }
    if (item.name == 'Add Stock') {
      const AddStockApprovalDeclined().launch(context);
    }
    if (item.name == 'Users') {
      const AddUsersDeclinedApprovalPageState().launch(context);
    }
    if (item.name == 'Customers') {
      const CustomersDeclinedApprovalPageState().launch(context);
    }
    if (item.name == 'Voided Transactions') {
      const DeclinedVoidedTransactionsPage().launch(context);
    }
  }
}

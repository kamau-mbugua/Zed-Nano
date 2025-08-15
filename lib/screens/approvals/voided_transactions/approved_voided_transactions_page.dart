import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/customers_list/CustomerListResponse.dart';
import 'package:zed_nano/models/void-pending-approval/VoidPendingApprovalResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/approvals/itemBuilders/add_customers_approval_item_builders.dart';
import 'package:zed_nano/screens/approvals/itemBuilders/voided/void_transaction_approval_item_builders.dart';
import 'package:zed_nano/screens/approvals/itemBuilders/voided/void_transaction_approved_builders.dart';
import 'package:zed_nano/screens/approvals/voided_transactions/void_transaction_detail_page.dart';
import 'package:zed_nano/screens/customers/details/customer_details_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/searchview.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'package:zed_nano/utils/pagination_controller.dart';

class ApprovedVoidedTransactionsPage extends StatefulWidget {
  const ApprovedVoidedTransactionsPage({super.key});

  @override
  State<ApprovedVoidedTransactionsPage> createState() => _ApprovedVoidedTransactionsPageState();
}

class _ApprovedVoidedTransactionsPageState extends State<ApprovedVoidedTransactionsPage> {

  late PaginationController<VoidPendingTransaction> _paginationController;
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  bool _isInitialized = false;
  Timer? _debounceTimer;


  @override
  void initState() {
    super.initState();

    // Initialize the controller but don't start fetching yet
    _paginationController = PaginationController<VoidPendingTransaction>(
      fetchItems: (page, pageSize) async {
        return getVoidedTransactionsPending(page: page, limit: pageSize);
      },
    );

    // Defer the first data fetch until after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isInitialized = true;
      });
      // Start the first page fetch after the UI is fully built
      _paginationController.fetchFirstPage();
    });
  }

  Future<List<VoidPendingTransaction>> getVoidedTransactionsPending({required int page, required int limit}) async {
    final response = await getBusinessProvider(context).getVoidedApprovedTransactionsPending(
      page: page,
      limit: limit,
      searchValue: _searchTerm,
      context: context,
    );
    return response.data?.transactions ?? [];
  }

  void _debounceSearch(String value) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchTerm = value;
      });
      _paginationController.refresh();
    });
  }

  @override
  void dispose() {
    _paginationController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _handleDecline(String? transactionId, String action) async {
    var payload = {
      "comments": '$action transaction ${transactionId}',
      "action": "$action",
      "transactionId": transactionId
    };
    await getBusinessProvider(context).voidTransaction(requestData: payload, context: context).then((value) {
      if (value.isSuccess) {
        showCustomToast(value.message ?? 'Transaction Declined');
        _paginationController.refresh();
      } else {
        showCustomToast(value.message ?? 'Failed to load product details');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AuthAppBar(title: 'Approved Voided Transactions'),
      body: RefreshIndicator(
        onRefresh: () async {
          await _paginationController.refresh();
        },
        child: Column(
          children: [
            buildSearchBar(
              controller: _searchController,
              onChanged: _debounceSearch,
            ),
            Expanded(
              child: PagedListView<int, VoidPendingTransaction>(
                pagingController: _paginationController.pagingController,
                padding: const EdgeInsets.all(16),
                builderDelegate: PagedChildBuilderDelegate<VoidPendingTransaction>(
                  itemBuilder: (context, item, index) {
                    return addVoidApprovedTransactionsApprovalItemBuilder(
                      item,
                      onApprove:(){
                        _handleDecline(
                          item.transactionID,
                          'approve',
                        );
                      },
                      onDecline:(){
                        _handleDecline(
                          item.transactionID,
                          'approve',
                        );
                      },
                      onTap:(){
                      },
                    ).onTap(() {
                      VoidTransactionDetailPage(transactionId: item.transactionID).launch(context);
                    });
                  },
                  firstPageProgressIndicatorBuilder: (_) => const SizedBox.shrink(),
                  newPageProgressIndicatorBuilder: (_) => const SizedBox.shrink(),
                  noItemsFoundIndicatorBuilder: (context) => const Center(
                    child: CompactGifDisplayWidget(
                      gifPath: emptyListGif,
                      title: "It's empty, over here.",
                      subtitle: 'No pending voided transactions in your business, yet! Add to view them here.',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


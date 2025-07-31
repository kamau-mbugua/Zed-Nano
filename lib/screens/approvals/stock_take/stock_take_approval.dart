import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/get_approved_add_stock_batches_by_branch/GetBatchesListResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/approvals/itemBuilders/stock_take_item_builders.dart';
import 'package:zed_nano/screens/stock/stock_take/view_stock__take_batch_detail.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/screens/widget/common/searchview.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'package:zed_nano/utils/pagination_controller.dart';

class StockTakeApproval extends StatefulWidget {
  const StockTakeApproval({Key? key}) : super(key: key);

  @override
  _StockTakeApprovalState createState() => _StockTakeApprovalState();
}

class _StockTakeApprovalState extends State<StockTakeApproval> {
  TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  String _searchTerm = '';
  late PaginationController<BatchData> _paginationController;
  Set<String> _selectedItems = {}; // Add this to track selected items

  @override
  void initState() {
    super.initState();
    _paginationController = PaginationController<BatchData>(
      fetchItems: (page, pageSize) async {
        return getPendingBatchesByBranch(page: page, limit: pageSize);
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _paginationController.initialize();
        _paginationController.fetchFirstPage();
      }
    });
  }


  Future<List<BatchData>> getPendingBatchesByBranch(
      {required int page, required int limit}) async {
    try {
      final response = await getBusinessProvider(context).getPendingBatchesByBranch(
        page: page,
        limit: limit,
        searchValue: _searchTerm,
        context: context,
      );

      return response.data?.data ?? [];
    } catch (e) {
      showCustomToast(e.toString());
      return [];
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }


  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchTerm = query;
        _paginationController.refresh();
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(title: 'Stock Take Approval'),
      body: Column(
        children: [
          headings(
            label: 'Stock Take Requests',
            subLabel: 'Tap on a request to view more details.',
          ),
          _buildSearchBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _paginationController.refresh();
                // await _fetchStockSummary();
              },
              child: _buildApprovedStockList().paddingSymmetric(horizontal: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return buildSearchBar(controller: _searchController, onChanged: _onSearchChanged);
  }

  Widget _buildApprovedStockList() {
    return PagedListView<int, BatchData>(
      pagingController: _paginationController.pagingController,
      builderDelegate: PagedChildBuilderDelegate<BatchData>(
        itemBuilder: (context, item, index) {
          return stockTakeItemBuilder(item,
              onChecked: () {
                setState(() {
                  if (_selectedItems.contains(item.id)) {
                    _selectedItems.remove(item.id);
                  } else {
                    _selectedItems.add(item.id!);
                  }
                });
              },
              onApprove: () {},
              onDecline: () {},
              onTap: () {
                ViewStockTakeBatchDetail(
                  batchId: item?.batchId ?? '',
                ).launch(context);
              },
              context: context,
              isSelected: _selectedItems.contains(item.id));
        },
        firstPageProgressIndicatorBuilder: (_) => const SizedBox(),
        newPageProgressIndicatorBuilder: (_) => const SizedBox(),
        noItemsFoundIndicatorBuilder: (context) => const Center(
          child: CompactGifDisplayWidget(
            gifPath: emptyListGif,
            title: "It's empty over here.",
            subtitle:
            'No approved batches here yet! Add to view them here.',
          ),
        ),
        firstPageErrorIndicatorBuilder: (context) => const Center(
          child: CompactGifDisplayWidget(
            gifPath: emptyListGif,
            title: "It's empty over here.",
            subtitle:
            'No approved batches here yet! Add to view them here.',
          ),
        ),
      ),
    );
  }
}

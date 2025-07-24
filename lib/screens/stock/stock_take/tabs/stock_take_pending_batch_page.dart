import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/get_approved_add_stock_batches_by_branch/GetBatchesListResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/stock/add_stock/addStock/add_stock_parent_page.dart';
import 'package:zed_nano/screens/stock/add_stock/view_stock_batch_detail.dart';
import 'package:zed_nano/screens/stock/itemBuilder/build_batch_item.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/searchview.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'package:zed_nano/utils/pagination_controller.dart';

class StockTakePendingBatchPage extends StatefulWidget {
  const StockTakePendingBatchPage({Key? key}) : super(key: key);

  @override
  _StockTakePendingBatchPageState createState() =>
      _StockTakePendingBatchPageState();
}

class _StockTakePendingBatchPageState extends State<StockTakePendingBatchPage> {
  TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  String _searchTerm = '';
  late PaginationController<BatchData> _paginationController;

  @override
  void initState() {
    super.initState();
    _paginationController = PaginationController<BatchData>(
      fetchItems: (page, pageSize) async {
        return getPendingAddStockBatchesByBranch(page: page, limit: pageSize);
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _paginationController.initialize();
        _paginationController.fetchFirstPage();
      }
    });
  }


  Future<List<BatchData>> getPendingAddStockBatchesByBranch(
      {required int page, required int limit}) async {
    try {
      final response = await getBusinessProvider(context).getPendingAddStockBatchesByBranch(
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
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _paginationController.refresh();
                // await _fetchStockSummary();
              },
              child: _buildApprovedStockList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          const AddStockParentPage(initialStep:0).launch(context);
        },
        label: const Text('Add Stock', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: appThemePrimary,
      ),
    );  }


  Widget _buildSearchBar() {
    return buildSearchBar(controller: _searchController, onChanged: _onSearchChanged);
  }

  Widget _buildApprovedStockList() {
    return PagedListView<int, BatchData>(
      pagingController: _paginationController.pagingController,
      builderDelegate: PagedChildBuilderDelegate<BatchData>(
        itemBuilder: (context, item, index) {
          return buildBatchItem(item, onTap: () {
            ViewStockBatchDetail(
              batchId: item?.batchId ?? '',
            ).launch(context);
          });
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



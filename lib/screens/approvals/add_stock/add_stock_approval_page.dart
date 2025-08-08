import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/get_approved_add_stock_batches_by_branch/GetBatchesListResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/approvals/itemBuilders/add_stock_approval_item_builders.dart';
import 'package:zed_nano/screens/stock/add_stock/view_stock_batch_detail.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/searchview.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'package:zed_nano/utils/pagination_controller.dart';

class AddStockApprovalPage extends StatefulWidget {
  const AddStockApprovalPage({super.key});

  @override
  _AddStockApprovalPageState createState() =>
      _AddStockApprovalPageState();
}

class _AddStockApprovalPageState extends State<AddStockApprovalPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  String _searchTerm = '';
  late PaginationController<BatchData> _paginationController;
  final List<String> _selectedItems = []; // Add this to track selected items


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
      {required int page, required int limit,}) async {
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




  Future<void> _approveSelectedStockTake(
      {required Map<String, dynamic> requestData,}) async {
    try {
      await getBusinessProvider(context).approveMultipleAddStockBatches(
        requestData: requestData,
        context: context,
      ).then((response) {
        if (response.isSuccess) {
          _selectedItems.clear();
          showCustomToast(response.message ?? 'Stock Take Approved Successfully', isError: false);
          _paginationController.refresh();
        } else {
          showCustomToast(response.message ?? 'Failed to approve stock take');
        }

      });

    } catch (e) {
      showCustomToast(e.toString());
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
      appBar: const AuthAppBar(title: 'Add Stock Requests'),
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
      bottomNavigationBar: _buildSubmitButton(),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 7,
              child: Visibility(
                visible: _selectedItems.isNotEmpty,
                child: appButton(
                  text: 'Approve Selected',
                  onTap: () {
                    final requestData = <String, dynamic>{
                      'listBatchIds': _selectedItems,
                      'status': 'APPROVED',
                    };
                    _approveSelectedStockTake(requestData:requestData);
                  },
                  context: context,
                ),
              ),
            ),
          ],
        ),
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
          return addStockApprovalItemBuilder(item,
              onChecked: () {
                setState(() {
                  if (_selectedItems.contains(item.id)) {
                    _selectedItems.remove(item.id);
                  } else {
                    _selectedItems.add(item.id!);
                  }
                });
              },
              onApprove: () {
                if (!_selectedItems.contains(item.id)) {
                  _selectedItems.add(item.id!);
                }
                final requestData = <String, dynamic>{
                  'listBatchIds': _selectedItems,
                  'status': 'APPROVED',
                };
                _approveSelectedStockTake(requestData:requestData);
              },
              onDecline: () {
                if (!_selectedItems.contains(item.id)) {
                  _selectedItems.add(item.id!);
                }
                final requestData = <String, dynamic>{
                  'listBatchIds': _selectedItems,
                  'status': 'DECLINED',
                };
                _approveSelectedStockTake(requestData:requestData);
              },
              onTap: () {
                ViewStockBatchDetail(
                  batchId: item.batchId ?? '',
                ).launch(context);
              },
              context: context,
              isSelected: _selectedItems.contains(item.id),);
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




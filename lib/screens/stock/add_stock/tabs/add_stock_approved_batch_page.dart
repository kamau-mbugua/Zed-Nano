import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zed_nano/models/get_approved_add_stock_batches_by_branch/GetBatchesListResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/searchview.dart';
import 'package:zed_nano/utils/pagination_controller.dart';

class AddStockApprovedBatchPage extends StatefulWidget {
  const AddStockApprovedBatchPage({Key? key}) : super(key: key);

  @override
  _AddStockApprovedBatchPageState createState() =>
      _AddStockApprovedBatchPageState();
}

class _AddStockApprovedBatchPageState extends State<AddStockApprovedBatchPage> {
  TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  String _searchTerm = '';
  late PaginationController<BatchData> _paginationController;

  @override
  void initState() {
    super.initState();
    _paginationController = PaginationController<BatchData>(
      fetchItems: (page, pageSize) async {
        return getApprovedAddStockBatchesByBranch(page: page, limit: pageSize);
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _paginationController.initialize();
        _paginationController.fetchFirstPage();
      }
    });
  }


  Future<List<BatchData>> getApprovedAddStockBatchesByBranch(
      {required int page, required int limit}) async {
    try {
      final response = await getBusinessProvider(context).getApprovedAddStockBatchesByBranch(
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
    return Container();
  }


  Widget _buildSearchBar() {
    return buildSearchBar(controller: _searchController, onChanged: _onSearchChanged);
  }

}



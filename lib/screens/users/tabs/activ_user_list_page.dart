import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:zed_nano/models/customers_list/CustomerListResponse.dart';
import 'package:zed_nano/models/listCategories/ListCategoriesResponse.dart';
import 'package:zed_nano/models/listUsers/ListUsersResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/customers/itemBuilder/list_customers_item_builder.dart';
import 'package:zed_nano/screens/users/itemBuilders/users_itme_builders.dart';
import 'package:zed_nano/screens/widget/common/categories_widget.dart';
import 'package:zed_nano/screens/widget/common/searchview.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'package:zed_nano/utils/pagination_controller.dart';

class ActiveUserListPage extends StatefulWidget {
  const ActiveUserListPage({Key? key}) : super(key: key);

  @override
  State<ActiveUserListPage> createState() => _ActiveUserListPageState();
}

class _ActiveUserListPageState extends State<ActiveUserListPage> {

  late PaginationController<ListUserData> _paginationController;
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = "";
  bool _isInitialized = false;
  Timer? _debounceTimer;


  @override
  void initState() {
    super.initState();

    // Initialize the controller but don't start fetching yet
    _paginationController = PaginationController<ListUserData>(
      fetchItems: (page, pageSize) async {
        return getListListUsers(page: page, limit: pageSize);
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

  Future<List<ListUserData>> getListListUsers({required int page, required int limit}) async {
    final response = await getBusinessProvider(context).getListListUsers(
      page: page,
      limit: limit,
      searchValue: _searchTerm,
      context: context,
      status: 'ACTIVE',
    );
    return response.data?.data ?? [];
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
                  child: PagedListView<int, ListUserData>(
                    pagingController: _paginationController.pagingController,
                    padding: const EdgeInsets.all(16),
                    builderDelegate: PagedChildBuilderDelegate<ListUserData>(
                      itemBuilder: (context, item, index) {
                        return listUsersItemBuilder(item);
                      },
                      firstPageProgressIndicatorBuilder: (_) => const SizedBox.shrink(),
                      newPageProgressIndicatorBuilder: (_) => const SizedBox.shrink(),
                      noItemsFoundIndicatorBuilder: (context) => const Center(
                        child: CompactGifDisplayWidget(
                          gifPath: emptyListGif,
                          title: "It's empty, over here.",
                          subtitle: "No Users in your business, yet! Add to view them here.",
                        ),
                      ),
                    ),
                  ),
                ),
              ]
          ),
        )
    );
  }
}


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/customers_list/CustomerListResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/approvals/itemBuilders/add_customers_approval_item_builders.dart';
import 'package:zed_nano/screens/customers/details/customer_details_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/searchview.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'package:zed_nano/utils/pagination_controller.dart';

class CustomersPendingApprovalPage extends StatefulWidget {
  const CustomersPendingApprovalPage({super.key});

  @override
  State<CustomersPendingApprovalPage> createState() => _CustomersPendingApprovalPageState();
}

class _CustomersPendingApprovalPageState extends State<CustomersPendingApprovalPage> {

  late PaginationController<Customer> _paginationController;
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  bool _isInitialized = false;
  Timer? _debounceTimer;


  @override
  void initState() {
    super.initState();

    // Initialize the controller but don't start fetching yet
    _paginationController = PaginationController<Customer>(
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

  Future<List<Customer>> getListListUsers({required int page, required int limit}) async {
    final response = await getBusinessProvider(context).getListCustomers(
      page: page,
      limit: limit,
      searchValue: _searchTerm,
      context: context,
      status: 'Awaiting',
      paymentType: '',
      customerType: '',
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

  Future<void> activateCustomer(String customerNumber) async {
    try {
      final response =
      await getBusinessProvider(context).activateCustomer(customerNumber: customerNumber!, context: context);

      if (response.isSuccess) {
        showCustomToast(response.message, isError: false);
        _paginationController.refresh();
      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      showCustomToast('Failed to load product details');
    }
  }
  Future<void> suspendCustomer(String customerNumber) async {
    try {
      final response =
      await getBusinessProvider(context).suspendCustomer(customerNumber: customerNumber!, context: context);

      if (response.isSuccess) {
        showCustomToast(response.message, isError: false);
        _paginationController.refresh();

      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      showCustomToast('Failed to load product details');
    }
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
        appBar: const AuthAppBar(title: 'Users Requests'),
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
                  child: PagedListView<int, Customer>(
                    pagingController: _paginationController.pagingController,
                    padding: const EdgeInsets.all(16),
                    builderDelegate: PagedChildBuilderDelegate<Customer>(
                      itemBuilder: (context, item, index) {
                        return addCustomersApprovalItemBuilder(
                            item,
                            onApprove:() async {
                              await activateCustomer(item.id);
                            },
                          onDecline:() async {
                            await suspendCustomer(item.id);
                          },
                          onTap:(){
                            CustomerDetailsPage(customerID: item.id,).launch(context);
                          },
                        );
                      },
                      firstPageProgressIndicatorBuilder: (_) => const SizedBox.shrink(),
                      newPageProgressIndicatorBuilder: (_) => const SizedBox.shrink(),
                      noItemsFoundIndicatorBuilder: (context) => const Center(
                        child: CompactGifDisplayWidget(
                          gifPath: emptyListGif,
                          title: "It's empty, over here.",
                          subtitle: 'No Users in your business, yet! Add to view them here.',
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


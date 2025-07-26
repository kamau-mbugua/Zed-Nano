import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/fetchByStatus/OrderResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/customers/itemBuilder/list_customers_transactions_item_builder.dart';
import 'package:zed_nano/screens/widget/common/base_bottom_sheet.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/filter_row_widget.dart';
import 'package:zed_nano/screens/widget/common/sub_category_picker.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'package:zed_nano/utils/pagination_controller.dart';

class CustomerOrdersPages extends StatefulWidget {
  String customerId;
  CustomerOrdersPages({Key? key, required this.customerId}) : super(key: key);

  @override
  _CustomerOrdersPagesState createState() => _CustomerOrdersPagesState();
}

class _CustomerOrdersPagesState extends State<CustomerOrdersPages> {

  List<String> orderStatus = ['Paid', 'Unpaid', 'Partial'];
  String selectedStatus = 'Unpaid';

  late PaginationController<OrderData> _paginationController;
  final TextEditingController _searchController = TextEditingController();

  String _searchTerm = "";
  bool _isInitialized = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();

    // Initialize the controller but don't start fetching yet
    _paginationController = PaginationController<OrderData>(
      fetchItems: (page, pageSize) async {
        return fetchByStatus(page: page, limit: pageSize);
      },
    );

    // Defer the first data fetch until after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _paginationController.fetchFirstPage();
    });
  }

  Future<List<OrderData>> fetchByStatus(
      {required int page, required int limit}) async {
    final response = await getBusinessProvider(context).fetchByStatus(
        page: page,
        limit: limit,
        searchValue: _searchTerm,
        context: context,
        customerId: widget.customerId,
        status: selectedStatus.toLowerCase(),
        startDate: '',
        endDate: '',
        cashier: '',
    );
    return response.data?.transaction ?? [];
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
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Orders',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xff000000),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                )
            ),
            Text('View All',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: accentRed,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                )
            )
          ],
        ),
        _showFiltersRow(),
        Expanded(
          child: PagedListView<int, OrderData>(
            pagingController: _paginationController.pagingController,
            builderDelegate: PagedChildBuilderDelegate<OrderData>(
              itemBuilder: (context, item, index) {
                return listCustomersOrdersItemBuilder(item);
              },
              firstPageProgressIndicatorBuilder: (_) => const SizedBox.shrink(),
              newPageProgressIndicatorBuilder: (_) => const SizedBox.shrink(),
              noItemsFoundIndicatorBuilder: (context) =>  Center(
                child: CompactGifDisplayWidget(
                  gifPath: emptyListGif,
                  title: "It's empty, over here.",
                  subtitle:
                  "No ${selectedStatus} orders in your business, yet! Add to view them here.",
                ),
              ),
            ),
          ).paddingSymmetric(vertical: 16),
        ),
      ],
    ).paddingSymmetric(horizontal: 16);
  }

  Widget _showFiltersRow() {
    return  buildFilterButton(
      text: "Displaying",
      isActive: false,
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => orderBottomSheet(),
        );
      },
      icon: Icons.tune,
      showTrailingText: true,
      trailingWidget: Text(
        selectedStatus.isEmpty ? 'All Orders' : selectedStatus,
        style: TextStyle(
          fontSize: 14,
          color: Color(0xff2f3036),
          fontWeight: FontWeight.w500,
        ),
      ),
    ).paddingSymmetric(vertical: 16);
  }

  Widget orderBottomSheet() {
    return BaseBottomSheet(
      title: 'Order Status',
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 1.0,
      headerContent:  const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select an option to proceed.',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              color: Color(0xff71727a),
            ),
          ),
        ],
      ).paddingTop(16),
      bodyContent: SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        child: ListView.builder(
          itemCount: orderStatus.length,
          itemBuilder: (context, index) {
            return arrowListItem(
              index: index,
              steps: orderStatus,
              onTab: (index) {

                //get the step name
                String stepName = orderStatus[index as int];

                Navigator.pop(context);
                setState(() {
                  selectedStatus = stepName;
                });
                
                // Refresh the pagination controller to fetch new data with updated status
                _paginationController.refresh();
              },
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/get_add_stock_products_batch/StockBatchDetail.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/stock/itemBuilder/preview_add_stock_item.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/flexible_rich_text.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'package:zed_nano/utils/extensions.dart';
import 'package:zed_nano/utils/pagination_controller.dart';

class ViewStockTakeBatchDetail extends StatefulWidget {
  String batchId;

  ViewStockTakeBatchDetail({Key? key, required this.batchId}) : super(key: key);

  @override
  _ViewStockTakeBatchDetailState createState() => _ViewStockTakeBatchDetailState();
}

class _ViewStockTakeBatchDetailState extends State<ViewStockTakeBatchDetail> {
  late PaginationController<StockItem> _paginationController;
  StockBatchDetail? stockBatchDetail;

  @override
  void initState() {
    super.initState();

    // Initialize pagination controller without adding listeners yet
    _paginationController = PaginationController<StockItem>(
      fetchItems: (page, pageSize) async {
        return getAddStockPendingProductsBatch(page: page, limit: pageSize);
      },
    );

    // Defer API calls to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Initialize the controller and fetch first page after build is complete
        _paginationController.initialize();
        _paginationController.fetchFirstPage();
      }
    });
  }

  Future<List<StockItem>> getAddStockPendingProductsBatch(
      {required int page, required int limit}) async {
    var request = {
      'batchId': widget.batchId,
    };

    try {
      final response = await getBusinessProvider(context)
          .getAddStockPendingProductsBatch(
              page: page, limit: limit, context: context, requestData: request);

      setState(() {
        stockBatchDetail = response.data;
      });

      return response.data?.data ?? [];
    } catch (e) {
      showCustomToast(e.toString());
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  AuthAppBar(
        title: 'Batch Details',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _createHeader().paddingSymmetric(horizontal: 16, vertical: 16),
          _createSubHeader().paddingSymmetric(horizontal: 16, vertical: 16),
          16.height,
          Expanded(
            child: _buildStockList().paddingSymmetric(horizontal: 16, vertical: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildStockList() {
    return PagedListView<int, StockItem>(
      pagingController: _paginationController.pagingController,
      builderDelegate: PagedChildBuilderDelegate<StockItem>(
        itemBuilder: (context, item, index) {
          return viewBatchStockTakeProductItem(
            item: item,
          );
        },
        firstPageProgressIndicatorBuilder: (_) => const SizedBox(),
        newPageProgressIndicatorBuilder: (_) => const SizedBox(),
        noItemsFoundIndicatorBuilder: (context) => const Center(
          child: CompactGifDisplayWidget(
            gifPath: emptyListGif,
            title: "It's empty over here.",
            subtitle:
                'No products in this batch yet! Add to view them here.',
          ),
        ),
        firstPageErrorIndicatorBuilder: (context) => const Center(
          child: CompactGifDisplayWidget(
            gifPath: emptyListGif,
            title: "It's empty over here.",
            subtitle:
                'No products in this batch yet! Add to view them here.',
          ),
        ),
      ),
    );
  }

  Widget _createSubHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${stockBatchDetail?.count ?? 0} Products',
                style: const TextStyle(
                  color: textPrimary,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const Text('Enter supplier or vendor details.',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                letterSpacing: 0.12,
              ))
        ],
      ),
    );
  }

  Widget _createHeader() {
    return Container(
        width: context.width(),
        margin: const EdgeInsets.only(left: 0, right: 0, bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'Batch No: ${stockBatchDetail?.batchHeader?.batchNumber ?? 'N/A'}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    )),
                Text(stockBatchDetail?.batchHeader?.stockStatus ?? 'N/A',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: stockBatchDetail?.batchHeader?.stockStatus ==
                              'APPROVED'
                          ? successTextColor
                          : errorColors,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ))
              ],
            ),
            if (stockBatchDetail?.batchHeader?.stockStatus == 'APPROVED')
              FlexibleRichText(
                segments: [
                  const TextSegment(
                    text: 'Approved by: ',
                    color: textSecondary, // or your textColorSecondary
                  ),
                  TextSegment(
                    text: stockBatchDetail?.batchHeader?.approvedBy ?? 'N/A',
                    color: textPrimary, // or your textColorPrimary
                  ),
                ],
              )
            else
              FlexibleRichText(
                segments: [
                  const TextSegment(
                    text: 'Created by: ',
                    color: textSecondary, // or your textColorSecondary
                  ),
                  TextSegment(
                    text: stockBatchDetail?.batchHeader?.createdByName ?? 'N/A',
                    color: textPrimary, // or your textColorPrimary
                  ),
                ],
              ),
            if (stockBatchDetail?.batchHeader?.stockStatus == 'APPROVED')
              FlexibleRichText(
                segments: [
                  const TextSegment(
                    text: 'Approved by: ',
                    color: textSecondary, // or your textColorSecondary
                  ),
                  TextSegment(
                    text: stockBatchDetail?.batchHeader?.dateApproved
                            ?.toFormattedDate() ??
                        'N/A',
                    color: textPrimary, // or your textColorPrimary
                  ),
                ],
              )
            else
              FlexibleRichText(
                segments: [
                  const TextSegment(
                    text: 'Created on: ',
                    color: textSecondary, // or your textColorSecondary
                  ),
                  TextSegment(
                    text: stockBatchDetail?.batchHeader?.dateCreated
                            ?.toFormattedDate() ??
                        'N/A',
                    color: textPrimary, // or your textColorPrimary
                  ),
                ],
              ),
          ],
        ));
  }
}

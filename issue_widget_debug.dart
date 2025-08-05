Widget _buildRecentSalesSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Recent Sales',
        style: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
          fontSize: 14,
        ),
      ),
      const SizedBox(height: 16),
      Expanded( // Add Expanded widget here
        child: PagedListView<int, SalesReportTotalSalesData>(
          pagingController: _paginationController.pagingController,
          padding: const EdgeInsets.all(0),
          builderDelegate: PagedChildBuilderDelegate<SalesReportTotalSalesData>(
            itemBuilder: (context, item, index) {
              return _buildRecentSaleItem(item);
            },
            firstPageProgressIndicatorBuilder: (_) => const Center(
              child: CircularProgressIndicator(),
            ),
            newPageProgressIndicatorBuilder: (_) => const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            ),
            noItemsFoundIndicatorBuilder: (context) => const Center(
              child: CompactGifDisplayWidget(
                gifPath: emptyListGif,
                title: "It's empty, over here.",
                subtitle: "No recent sales in your business, yet! Add to view them here.",
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

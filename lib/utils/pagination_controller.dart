import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:zed_nano/app/app_initializer.dart';

class PaginationController<T> extends ChangeNotifier {
  final Future<List<T>> Function(int page, int pageSize) fetchItems;
  final int pageSize;
  int _currentPage = 0;
  bool _isLoading = false;
  final List<T> _items = [];
  final PagingController<int, T> pagingController;

  PaginationController({required this.fetchItems, this.pageSize = 100})
      : pagingController = PagingController(firstPageKey: 0) {
    pagingController.addPageRequestListener((pageKey) {
      fetchNextPage(pageKey);
    });
    // We don't auto-fetch anymore - the caller will explicitly call fetchFirstPage()
  }

  List<T> get items => _items;
  bool get isLoading => _isLoading;

  // Call this method explicitly after the build is complete
  void fetchFirstPage() {
    if (pagingController.nextPageKey == 0) {
      pagingController.notifyPageRequestListeners(pagingController.nextPageKey!);
    }
  }

  Future<void> fetchNextPage(int pageKey) async {
    if (_isLoading) return;

    _isLoading = true;
    Future.microtask(() => notifyListeners()); // Notify after the current frame

    try {
      List<T> newItems = await fetchItems(_currentPage, pageSize);
      final isLastPage = newItems.length < pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        pagingController.appendPage(newItems, nextPageKey);
      }
      _currentPage++;
    } catch (error) {
      logger.e('PaginationController Error fetching next page: $error');
      pagingController.error = error;
    }

    _isLoading = false;
    Future.microtask(() => notifyListeners()); // Notify after the current frame
  }

  Future<void> refresh() async {
    _currentPage = 0;
    _items.clear();
    pagingController.refresh();
  }
  
  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }
}
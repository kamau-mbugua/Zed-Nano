import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:zed_nano/app/app_initializer.dart';

class PaginationController<T> extends ChangeNotifier {
  final Future<List<T>> Function(int page, int pageSize) fetchItems;
  final int pageSize;
  int _currentPage = 1;
  bool _isLoading = false;
  final List<T> _items = [];
  final PagingController<int, T> pagingController;
  bool _isDisposed = false; // Track disposed state
  
  PaginationController({required this.fetchItems, this.pageSize = 100})
      : pagingController = PagingController(firstPageKey: 1) {
    pagingController.addPageRequestListener((pageKey) {
      if (!_isDisposed) {
        fetchNextPage(pageKey);
      }
    });
    // We don't auto-fetch anymore - the caller will explicitly call fetchFirstPage()
  }

  List<T> get items => _items;
  bool get isLoading => _isLoading;

  // Call this method explicitly after the build is complete
  void fetchFirstPage() {
    if (_isDisposed) return;
    
    if (pagingController.nextPageKey == 1) {
      pagingController.notifyPageRequestListeners(pagingController.nextPageKey!);
    }
  }

  Future<void> fetchNextPage(int pageKey) async {
    if (_isLoading || _isDisposed) return;

    _isLoading = true;
    if (!_isDisposed) {
      Future.microtask(() => notifyListeners()); // Notify after the current frame
    }

    try {
      // Check again before starting the network request
      if (_isDisposed) return;
      
      List<T> newItems = await fetchItems(_currentPage, pageSize);
      
      // Check again after the network request completes
      if (_isDisposed) return;
      
      final isLastPage = newItems.length < pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        pagingController.appendPage(newItems, nextPageKey);
      }
      _currentPage++;
    } catch (error) {
      if (_isDisposed) return;
      
      logger.e('PaginationController Error fetching next page: $error');
      pagingController.error = error;
    }

    _isLoading = false;
    if (!_isDisposed) {
      Future.microtask(() => notifyListeners()); // Notify after the current frame
    }
  }

  Future<void> refresh() async {
    if (_isDisposed) return;
    
    _currentPage = 1;
    _items.clear();
    pagingController.refresh();
  }

  // Method to manually pause/resume operations
  void pauseOperations() {
    _isLoading = false;
  }
  
  @override
  void dispose() {
    _isDisposed = true; // Mark as disposed first
    _isLoading = false; // Stop any loading state
    pagingController.dispose();
    super.dispose();
  }
}
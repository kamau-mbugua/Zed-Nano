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
    // Don't immediately add the listener that triggers fetches
    // We'll do this in a separate method called after widget initialization
  }

  // Call this after widget is fully initialized (e.g., in a post-frame callback)
  void initialize() {
    if (_isDisposed) return;
    
    // Now it's safe to add the listener
    pagingController.addPageRequestListener((pageKey) {
      if (!_isDisposed) {
        fetchNextPage(pageKey);
      }
    });
  }

  List<T> get items => _items;
  bool get isLoading => _isLoading;

  // Call this method explicitly after the build is complete
  void fetchFirstPage() {
    if (_isDisposed) return;
    
    // Initialize the controller first if not already done
    initialize();
    
    if (pagingController.nextPageKey == 1) {
      // Use microtask to ensure this happens after the current build phase
      Future.microtask(() {
        if (!_isDisposed) {
          pagingController.notifyPageRequestListeners(pagingController.nextPageKey!);
        }
      });
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
    
    // Use microtask to ensure this happens after the current build phase
    Future.microtask(() {
      if (!_isDisposed) {
        pagingController.refresh();
      }
    });
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
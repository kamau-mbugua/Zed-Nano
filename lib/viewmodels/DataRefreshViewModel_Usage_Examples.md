# DataRefreshViewModel Usage Examples

The `DataRefreshViewModel` is a powerful tool for managing data refresh events across your Flutter app. It allows any page to trigger refresh events and other pages to listen and respond automatically.

## Basic Setup

The `DataRefreshViewModel` is already registered in the app's `MultiProvider`, so you can access it from any widget.

## Import Required Files

```dart
import 'package:zed_nano/viewmodels/DataRefreshViewModel.dart';
import 'package:zed_nano/viewmodels/data_refresh_extensions.dart';
```

## 1. Triggering Refresh Events

### From Any Page (Using Extensions)

```dart
class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  
  void onOrderUpdated() {
    // Trigger refresh for order-related data
    context.dataRefresh.refreshAfterOrderOperation(operation: 'order_payment');
  }
  
  void onCustomerUpdated() {
    // Trigger refresh for customer-related data
    context.dataRefresh.refreshAfterCustomerOperation(operation: 'customer_created');
  }
  
  void onPaymentMade() {
    // Trigger refresh for payment-related data
    context.dataRefresh.refreshAfterPaymentOperation(operation: 'payment_completed');
  }
  
  void onInventoryChanged() {
    // Trigger refresh for inventory-related data
    context.dataRefresh.refreshAfterInventoryOperation(operation: 'stock_updated');
  }
  
  void onMajorOperation() {
    // Trigger refresh for dashboard and multiple data types
    context.dataRefresh.refreshAfterMajorOperation(operation: 'business_setup_completed');
  }
}
```

### Using Specific Data Types

```dart
class OrderDetailPage extends StatefulWidget {
  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  
  void onOrderCancelled() {
    // Trigger specific refresh types
    context.dataRefresh.triggerMultipleRefresh([
      DataRefreshType.orders,
      DataRefreshType.dashboard,
      DataRefreshType.transactions,
    ], customEvent: 'order_cancelled');
  }
  
  void onOrderPaid() {
    // Trigger single refresh type
    context.dataRefresh.triggerRefresh(DataRefreshType.orders, customEvent: 'order_paid');
  }
}
```

## 2. Listening for Refresh Events

### In Admin Dashboard (Complete Example)

```dart
class AdminDashboardPage extends StatefulWidget {
  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  bool _isFetching = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isFetching) return;

    // Listen for DataRefreshViewModel events
    final dataRefreshViewModel = Provider.of<DataRefreshViewModel>(context);

    var shouldRefresh = false;

    // Check for specific data type refreshes
    if (dataRefreshViewModel.getLastRefreshed(DataRefreshType.dashboard) != null ||
        dataRefreshViewModel.getLastRefreshed(DataRefreshType.orders) != null ||
        dataRefreshViewModel.getLastRefreshed(DataRefreshType.transactions) != null ||
        dataRefreshViewModel.getLastRefreshed(DataRefreshType.payments) != null) {
      logger.w('AdminDashboardPage detected data refresh event');
      shouldRefresh = true;
    }

    if (shouldRefresh) {
      _fetchDataWithDebounce();
    }
  }

  void _fetchDataWithDebounce() {
    if (_isFetching) return;
    _isFetching = true;
    
    fetchDashboardData().then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _isFetching = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataRefreshViewModel>(
      builder: (context, dataRefreshViewModel, child) {
        return Scaffold(
          // Your dashboard UI here
          body: Column(
            children: [
              // Show loading indicator if any data is refreshing
              if (dataRefreshViewModel.isAnyRefreshing)
                const LinearProgressIndicator(),
              
              // Your dashboard content
              Expanded(child: _buildDashboardContent()),
            ],
          ),
        );
      },
    );
  }
}
```

### In Order List Pages

```dart
class OrdersListPage extends StatefulWidget {
  @override
  _OrdersListPageState createState() => _OrdersListPageState();
}

class _OrdersListPageState extends State<OrdersListPage> {
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    final dataRefreshViewModel = Provider.of<DataRefreshViewModel>(context);
    
    // Listen specifically for order-related refreshes
    if (dataRefreshViewModel.getLastRefreshed(DataRefreshType.orders) != null) {
      // Refresh the order list
      _paginationController.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataRefreshViewModel>(
      builder: (context, dataRefreshViewModel, child) {
        return Scaffold(
          body: PagedListView<int, OrderData>(
            pagingController: _paginationController.pagingController,
            builderDelegate: PagedChildBuilderDelegate<OrderData>(
              itemBuilder: (context, item, index) {
                return OrderItemWidget(
                  order: item,
                  onTap: () {
                    // Navigate to order detail
                    OrderDetailPage(orderId: item.id).launch(context).then((_) {
                      // Order detail page will trigger refresh events automatically
                      // This page will listen and refresh accordingly
                    });
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
```

## 3. Custom Event Tracking

### Triggering Custom Events

```dart
class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  
  void onPaymentCompleted(String paymentMethod) {
    // Trigger with custom event name
    context.dataRefresh.triggerRefresh(
      DataRefreshType.payments, 
      customEvent: 'payment_${paymentMethod.toLowerCase()}_completed'
    );
  }
  
  void onBulkPaymentProcessed(int orderCount) {
    // Trigger multiple refreshes with custom event
    context.dataRefresh.triggerMultipleRefresh([
      DataRefreshType.orders,
      DataRefreshType.payments,
      DataRefreshType.dashboard,
    ], customEvent: 'bulk_payment_${orderCount}_orders');
  }
}
```

### Listening for Custom Events

```dart
class ReportsPage extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    final dataRefreshViewModel = Provider.of<DataRefreshViewModel>(context);
    
    // Check for specific custom events
    if (dataRefreshViewModel.wasCustomEventTriggeredRecently(
        'bulk_payment_completed', 
        const Duration(seconds: 30)
    )) {
      // Refresh reports data
      _refreshReportsData();
    }
    
    // Check for payment-related events
    final paymentEventTime = dataRefreshViewModel.getCustomEventTime('payment_mpesa_completed');
    if (paymentEventTime != null) {
      // Handle M-Pesa payment completion
      _handleMpesaPaymentUpdate();
    }
  }
}
```

## 4. Debugging and Monitoring

### Get Refresh Summary

```dart
class DebugPage extends StatefulWidget {
  @override
  _DebugPageState createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  
  void showRefreshSummary() {
    final summary = context.dataRefresh.getRefreshSummary();
    print('Refresh Summary: $summary');
    
    // Show in UI
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Refresh Summary'),
        content: Text(summary.toString()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  void clearAllRefreshStates() {
    context.dataRefresh.clearAllRefreshStates();
    showCustomToast('All refresh states cleared');
  }
}
```

## 5. Best Practices

### 1. Use Appropriate Refresh Types
```dart
// ✅ Good - Specific refresh types
context.dataRefresh.refreshAfterOrderOperation();
context.dataRefresh.refreshAfterPaymentOperation();

// ❌ Avoid - Too broad
context.dataRefresh.triggerRefreshAll();
```

### 2. Add Custom Event Names for Tracking
```dart
// ✅ Good - Descriptive custom events
context.dataRefresh.refreshAfterOrderOperation(operation: 'order_payment_completed');
context.dataRefresh.refreshAfterCustomerOperation(operation: 'customer_profile_updated');

// ❌ Avoid - Generic events
context.dataRefresh.refreshAfterOrderOperation();
```

### 3. Use Debouncing in Listeners
```dart
// ✅ Good - Prevent multiple rapid refreshes
void _fetchDataWithDebounce() {
  if (_isFetching) return;
  _isFetching = true;
  
  fetchData().then((_) {
    Future.delayed(const Duration(milliseconds: 500), () {
      _isFetching = false;
    });
  });
}
```

### 4. Handle Errors Gracefully
```dart
// ✅ Good - Error handling
void triggerRefreshEvent() {
  try {
    context.dataRefresh.refreshAfterOrderOperation(operation: 'order_updated');
    logger.d('Triggered refresh event successfully');
  } catch (e) {
    logger.e('Failed to trigger refresh event: $e');
    // Continue without breaking the app
  }
}
```

## 6. Common Use Cases

### Order Operations
- Order created → Refresh orders, dashboard
- Order paid → Refresh orders, payments, dashboard, transactions
- Order cancelled → Refresh orders, dashboard
- Order voided → Refresh orders, transactions, dashboard

### Customer Operations
- Customer created → Refresh customers, dashboard
- Customer updated → Refresh customers
- Customer deleted → Refresh customers, dashboard

### Payment Operations
- Payment made → Refresh payments, orders, dashboard, transactions
- Payment voided → Refresh payments, transactions, dashboard
- Bulk payments → Refresh payments, orders, dashboard

### Inventory Operations
- Stock added → Refresh inventory, products, dashboard
- Stock sold → Refresh inventory, products, dashboard
- Product created → Refresh products, inventory
- Category created → Refresh products, inventory

This system provides a clean, scalable way to keep your app's data synchronized across all pages without tight coupling between components.

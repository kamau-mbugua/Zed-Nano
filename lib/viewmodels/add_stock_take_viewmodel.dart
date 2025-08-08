import 'package:flutter/foundation.dart';

class AddStockTakeViewModel with ChangeNotifier {
  // Private state
  final Map<String, AddStockTakeCartItem> _items = {};
  
  // Getters
  List<AddStockTakeCartItem> get items => _items.values.toList();
  int get itemCount => _items.length;
  // double get totalAmount => _items.values.fold(0, (sum, item) => sum + (item.price * item.quantity));
  bool get isEmpty => _items.isEmpty;
  
  // Find a specific item by ID (returns null if not found)
  AddStockTakeCartItem? findItem(String productId) {
    return _items.containsKey(productId) ? _items[productId] : null;
  }
  
  // Add item to cart (or update if exists)
  void addItem(
      {double quantity = 0.0,
        String productId = '',
        String productName = '',
        double expectedQuantity = 0.0,
        String imagePath = '',
      }) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingItem) => AddStockTakeCartItem(
          quantity: quantity,
          productId: existingItem.productId,
          productName: existingItem.productName,
          imagePath: existingItem.imagePath,
          expectedQuantity: existingItem.expectedQuantity,
        ),
      );
    } else {
      // Add new item
      _items.putIfAbsent(
        productId,
        () => AddStockTakeCartItem(
          quantity: quantity,
          productId: productId,
          productName: productName,
          imagePath: imagePath,
          expectedQuantity: expectedQuantity,
        ),
      );
    }
    notifyListeners();
  }
  
  // Update item quantity
  void updateQuantity(String productId, double quantity) {
    if (!_items.containsKey(productId) || quantity <= 0.0) return;

    _items.update(
      productId,
          (existingItem) => AddStockTakeCartItem(
        quantity: existingItem.quantity + quantity,
        productId: existingItem.productId,
        productName: existingItem.productName,
        imagePath: existingItem.imagePath,
        expectedQuantity: existingItem.expectedQuantity,
      ),
    );
    notifyListeners();
  }
  
  // Remove single item
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }
  
  // Clear cart
  void clear() {
    _items.clear();
    notifyListeners();
  }
}

// CartItem model
class AddStockTakeCartItem {


  AddStockTakeCartItem({
    required this.quantity,
    required this.productId,
    required this.productName,
    required this.imagePath,
    required this.expectedQuantity,
  });
  final double expectedQuantity;
  final double quantity;
  final String productId;
  final String productName;
  final String imagePath;

  double get variation => quantity - expectedQuantity;

  // Convert to JSON for API calls
  Map<String, dynamic> toJson() {
    return {
      'expectedQuantity': expectedQuantity,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
    };
  }
}

import 'package:flutter/foundation.dart';

class AddStockViewModel with ChangeNotifier {
  // Private state
  final Map<String, AddStockCartItem> _items = {};
  
  // Getters
  List<AddStockCartItem> get items => _items.values.toList();
  int get itemCount => _items.length;
  // double get totalAmount => _items.values.fold(0, (sum, item) => sum + (item.price * item.quantity));
  bool get isEmpty => _items.isEmpty;
  
  // Find a specific item by ID (returns null if not found)
  AddStockCartItem? findItem(String productId) {
    return _items.containsKey(productId) ? _items[productId] : null;
  }
  
  // Add item to cart (or update if exists)
  void addItem(
      {double quantity = 0.0,
        String productId = '',
        String productName = '',
        double buyingPrice = 0.0,
        double oldStock = 0.0,
        double sellingPrice = 0.0,
        String imagePath = '',
        String currency = '',
        String category = '',
      }) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingItem) => AddStockCartItem(
          oldStock: existingItem.oldStock,
          category: existingItem.category,
          buyingPrice: existingItem.buyingPrice,
          sellingPrice: existingItem.sellingPrice,
          quantity: existingItem.quantity + quantity,
          productId: existingItem.productId,
          productName: existingItem.productName,
          imagePath: existingItem.imagePath,
          currency: existingItem.currency,
        ),
      );
    } else {
      // Add new item
      _items.putIfAbsent(
        productId,
        () => AddStockCartItem(
          oldStock: oldStock,
          category: category,
          buyingPrice: buyingPrice,
          sellingPrice: sellingPrice,
          quantity: quantity,
          productId: productId,
          productName: productName,
          imagePath: imagePath,
          currency: currency,
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
          (existingItem) => AddStockCartItem(
        oldStock: existingItem.oldStock,
        category: existingItem.category,
        buyingPrice: existingItem.buyingPrice,
        sellingPrice: existingItem.sellingPrice,
        quantity: existingItem.quantity + quantity,
        productId: existingItem.productId,
        productName: existingItem.productName,
        imagePath: existingItem.imagePath,
        currency: existingItem.currency,
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
class AddStockCartItem {
  final double oldStock;
  final String category;
  final double buyingPrice;
  final double sellingPrice;
  final double quantity;
  final String productId;
  final String productName;
  final String imagePath;
  final String currency;


  AddStockCartItem({
    required this.oldStock,
    required this.category,
    required this.buyingPrice,
    required this.sellingPrice,
    required this.quantity,
    required this.productId,
    required this.productName,
    required this.imagePath,
    required this.currency,
  });

  double get total => quantity + oldStock;

  // Convert to JSON for API calls
  Map<String, dynamic> toJson() {
    return {
      'buyingPrice': buyingPrice,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'sellingPrice': sellingPrice,
    };
  }
}

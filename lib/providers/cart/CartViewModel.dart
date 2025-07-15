import 'package:flutter/foundation.dart';

class CartViewModel with ChangeNotifier {
  // Private state
  final Map<String, CartItem> _items = {};
  
  // Getters
  List<CartItem> get items => _items.values.toList();
  int get itemCount => _items.length;
  double get totalAmount => _items.values.fold(0, (sum, item) => sum + (item.price * item.quantity));
  bool get isEmpty => _items.isEmpty;
  
  // Find a specific item by ID (returns null if not found)
  CartItem? findItem(String productId) {
    return _items.containsKey(productId) ? _items[productId] : null;
  }
  
  // Add item to cart (or update if exists)
  void addItem(String productId, String name, double price, String imagePath, String currency,String category, {int quantity = 1}) {
    if (_items.containsKey(productId)) {
      // Update existing item quantity
      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          name: existingItem.name,
          category: existingItem.category,
          price: existingItem.price,
          quantity: existingItem.quantity + quantity,
          imagePath: existingItem.imagePath,
          currency: existingItem.currency,
        ),
      );
    } else {
      // Add new item
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: productId,
          name: name,
          price: price,
          quantity: quantity,
          imagePath: imagePath,
          currency: currency,
          category: category,
        ),
      );
    }
    notifyListeners();
  }
  
  // Update item quantity
  void updateQuantity(String productId, int quantity) {
    if (!_items.containsKey(productId) || quantity <= 0) return;
    
    _items.update(
      productId,
      (existingItem) => CartItem(
        id: existingItem.id,
        name: existingItem.name,
        price: existingItem.price,
        quantity: quantity,
        imagePath: existingItem.imagePath,
        currency: existingItem.currency,
        category: existingItem.category,
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
class CartItem {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imagePath;

  final String currency;
  final int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.quantity,
    required this.imagePath,
    required this.currency,
  });

  double get total => price * quantity;
}

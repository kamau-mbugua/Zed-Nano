// import 'package:flutter/material.dart';
//
// /// Provider to manage categories in the app
// class CategoryProvider extends ChangeNotifier {
//   // List of categories
//   List<Category> _categories = [];
//
//   // Getter for categories
//   List<Category> get categories => _categories;
//
//   // Selected category ID
//   int? _selectedCategoryId;
//
//   // Getter for selected category ID
//   int? get selectedCategoryId => _selectedCategoryId;
//
//   // Getter for selected category
//   Category? get selectedCategory {
//     if (_selectedCategoryId == null) return null;
//     try {
//       return _categories.firstWhere((category) => category.id == _selectedCategoryId);
//     } catch (e) {
//       return null;
//     }
//   }
//
//   // Initialize categories
//   Future<void> initCategories() async {
//     // TODO: Load categories from API or local storage
//     _categories = [
//       // Sample categories - replace with actual data
//       Category(id: 1, name: 'Food', icon: Icons.restaurant),
//       Category(id: 2, name: 'Transport', icon: Icons.directions_car),
//       Category(id: 3, name: 'Shopping', icon: Icons.shopping_cart),
//       Category(id: 4, name: 'Bills', icon: Icons.receipt),
//       Category(id: 5, name: 'Entertainment', icon: Icons.movie),
//     ];
//     notifyListeners();
//   }
//
//   // Set selected category
//   void selectCategory(int categoryId) {
//     _selectedCategoryId = categoryId;
//     notifyListeners();
//   }
//
//   // Clear selected category
//   void clearSelectedCategory() {
//     _selectedCategoryId = null;
//     notifyListeners();
//   }
//
//   // Add new category
//   void addCategory(Category category) {
//     _categories.add(category);
//     notifyListeners();
//   }
//
//   // Update existing category
//   void updateCategory(Category updatedCategory) {
//     final index = _categories.indexWhere((cat) => cat.id == updatedCategory.id);
//     if (index != -1) {
//       _categories[index] = updatedCategory;
//       notifyListeners();
//     }
//   }
//
//   // Delete category
//   void deleteCategory(int categoryId) {
//     _categories.removeWhere((cat) => cat.id == categoryId);
//     if (_selectedCategoryId == categoryId) {
//       _selectedCategoryId = null;
//     }
//     notifyListeners();
//   }
// }
//
// /// Category model class
// class Category {
//   final int id;
//   final String name;
//   final IconData icon;
//
//   Category({
//     required this.id,
//     required this.name,
//     required this.icon,
//   });
// }

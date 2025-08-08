class Product {
  
  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.imageUrl = '',
  });
  final String id;
  final String name;
  final String category;
  final int price;
  final String imageUrl;
}

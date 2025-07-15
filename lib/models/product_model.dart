class Product {
  final String id;
  final String name;
  final String category;
  final int price;
  final String imageUrl;
  
  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.imageUrl = '',
  });
}

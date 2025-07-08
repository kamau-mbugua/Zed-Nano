import 'package:flutter/material.dart';
import 'package:zed_nano/utils/GifsImages.dart';

class ServiceCategoriesTab extends StatefulWidget {
  const ServiceCategoriesTab({super.key});

  @override
  State<ServiceCategoriesTab> createState() => _ServiceCategoriesTabState();
}

class _ServiceCategoriesTabState extends State<ServiceCategoriesTab> {
  // Mock data - replace with actual data source
  List<ProductCategory> categories = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    setState(() {
      isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
        // Add mock data here when you have categories
        // categories = mockProductCategories;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){},
        backgroundColor: const Color(0xFF032541),
        icon: const Icon(Icons.add, size: 20, color: Colors.white),
        label: const Text(
          'Add',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF032541),
              ),
            );
          }

          if (categories.isEmpty) {
            return const Center(
              child: CompactGifDisplayWidget(
                gifPath: emptyListGif,
                title: "It's empty, over here.",
                subtitle: "No service categories in your business, yet! Add to view them here.",
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _loadCategories();
            },
            color: const Color(0xFF032541),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return _buildCategoryCard(category);
              },
            ),
          );
        },
      ),
    );
  }
}

Widget _buildCategoryCard(ProductCategory category) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE8E8E8)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        // Category Icon/Image
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF032541).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.category,
            color: Color(0xFF032541),
            size: 24,
          ),
        ),
        const SizedBox(width: 16),

        // Category Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Color(0xFF1F2024),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                category.description ?? 'No description',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  color: Color(0xFF71727A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${category.productCount} products',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  color: Color(0xFF032541),
                ),
              ),
            ],
          ),
        ),

        // Actions
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
              // _editCategory(category);
                break;
              case 'delete':
              // _deleteCategory(category);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 16, color: Color(0xFF71727A)),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 16, color: Color(0xFFED3241)),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Color(0xFFED3241))),
                ],
              ),
            ),
          ],
          child: const Icon(
            Icons.more_vert,
            color: Color(0xFF71727A),
          ),
        ),
      ],
    ),
  );
}

// Model class for Product Category
class ProductCategory {
  final String id;
  final String name;
  final String? description;
  final int productCount;
  final String? imageUrl;

  ProductCategory({
    required this.id,
    required this.name,
    this.description,
    required this.productCount,
    this.imageUrl,
  });

  // Factory constructor for JSON deserialization
  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] as String,
      name: json['name']as String,
      description: json['description']as String,
      productCount: json['productCount']as int,
      imageUrl: json['imageUrl']as String,
    );
  }

  // To JSON method for serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'productCount': productCount,
      'imageUrl': imageUrl,
    };
  }


}

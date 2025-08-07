import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/models/createCategory/CreateCategoryResponse.dart';
import 'package:zed_nano/models/listCategories/ListCategoriesResponse.dart';
import 'package:zed_nano/models/listProducts/ListProductsResponse.dart';
import 'package:zed_nano/providers/business/BusinessProviders.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_dialog.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'package:zed_nano/utils/pagination_controller.dart';
import 'package:zed_nano/screens/widget/common/categories_widget.dart';

class CategoryDetailPage extends StatefulWidget {
  final String categoryId;
  
  const CategoryDetailPage({
    Key? key,
    required this.categoryId,
  }) : super(key: key);

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  ProductCategoryData? categoryData;
  int productCount = 0;

  late PaginationController<ProductData> _paginationController;
  String _searchTerm = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    
    // Initialize pagination controller without immediately fetching data
    _paginationController = PaginationController<ProductData>(
      fetchItems: (page, pageSize) async {
        return getListByProducts(page: page, limit: pageSize);
      },
    );

    // Defer API calls to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCategoryDetails();
      _paginationController.fetchFirstPage();
    });
  }

  Future<List<ProductData>> getListByProducts({required int page, required int limit}) async {
    final response = await getBusinessProvider(context).getListByProducts(
        page: page,
        limit: limit,
        searchValue: _searchTerm,
        context: context,
        categoryId: widget.categoryId
    );
    
    return response.data?.data ?? [];
  }

  Future<void> _fetchCategoryDetails() async {
    if (widget.categoryId.isNotEmpty) {
      final Map<String, dynamic> requestData = {
        'categoryId': widget.categoryId,
      };
      
      try {
        final response = await context.read<BusinessProviders>().getCategoryById(
          requestData: requestData,
          context: context,
        );
        
        if (response.isSuccess && response.data?.data != null) {
          setState(() {
            categoryData = response.data?.data;
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          showCustomToast(response.message ?? 'Failed to load category details');
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        showCustomToast('An error occurred while loading category details');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      showCustomToast('Invalid category or business ID');
    }
  }

  void _deleteCategory() {
    showCustomDialog(
      context: context,
      title: 'Delete Category',
      subtitle: 'Are you sure you want to delete this category? This action cannot be undone.',
      positiveButtonText: 'Delete',
      negativeButtonText: 'Cancel',
      positiveButtonColor: accentRed,
      onPositivePressed: () async {
        Navigator.pop(context); // Close dialog
        final businessId = getBusinessDetails(context)?.businessId;
        if (widget.categoryId.isNotEmpty) {
          final Map<String, dynamic> requestData = {
            'categoryState': 'Inactive',
            'categoryId': widget.categoryId,
          };
          
          try {
            final response = await context.read<BusinessProviders>().updateCategory(
              requestData: requestData,
              context: context,
            );
            if (response.isSuccess) {
              showCustomToast('Category deleted successfully', isError: false);
              Navigator.pop(context); // Go back to categories page
            } else {
              showCustomToast(response.message ?? 'Failed to delete category');
            }
          } catch (e) {
            showCustomToast('An error occurred while deleting category');
          }
        }
      },
    );
  }

  void _navigateToEditCategory() {
    Navigator.pushNamed(
        context,
        AppRoutes.getEditCategoryHRoute(widget.categoryId ?? '')).then((_) {
      _fetchCategoryDetails();
    });
  }

  void _navigateToAddProduct() {
    if (categoryData != null) {
      // Navigate to add product page with the current category
      Navigator.pushNamed(
        context, 
        AppRoutes.getNewProductWithParamRoutes('true'),
        arguments: {
          'categoryId': categoryData?.id,
          'categoryName': categoryData?.categoryName,
          'selectedCategory': categoryData?.categoryName,
          'productService': categoryData?.productService,
        },
      ).then((result) {
        // Refresh products when returning from add product page if a product was added
        if (result == true) {
          _paginationController.refresh();
        }
      });
    } else {
      showCustomToast('Category details not available');
    }
  }

  @override
  void dispose() {
    _paginationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(
        title: 'View Category',
        actions: [
          TextButton(
            child: const Text('Delete', style: TextStyle(color:accentRed)),
            onPressed: _deleteCategory,
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildBody() {
    // if (_isLoading) {
    //   return const Center(child: CircularProgressIndicator());
    // }
    //
    // if (categoryData == null) {
    //   return const Center(
    //     child: Text('Could not load category details',
    //       style: TextStyle(fontFamily: 'Poppins', fontSize: 16)),
    //   );
    // }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryDetailsCard(),
          const SizedBox(height: 24),
          _buildProductsHeader(),
          const SizedBox(height: 16),
          Expanded(
            child: _buildProductsSection(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCategoryDetailsCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Category Details',
              style: TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                fontSize: 14.0,
              ),
            ),
            GestureDetector(
              onTap: _navigateToEditCategory,
              child: const Text(
                'Edit',
                style: TextStyle(
                  color: accentRed,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontSize: 12.0,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoryData?.categoryName ?? 'N/A',
                    style: const TextStyle(
                      color: textPrimary,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      fontSize: 28.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    categoryData?.categoryDescription ?? 'N/A',
                    style: const TextStyle(
                      color: textSecondary,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      fontSize: 12.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$productCount ${categoryData?.productService?.toLowerCase() == 'service' ? 'Service' : 'Product'}',
                    style: const TextStyle(
                      color: textSecondary,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFE3F3FF),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: _getCategoryImage(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _getCategoryImage() {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: rfCommonCachedNetworkImage(
        '${categoryData?.imagePath ?? ''}',
        fit: BoxFit.cover,
        height: 55,
        width: 55,
      ),
    );
  }

  Widget _buildProductsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
         Text(
          ' ${categoryData?.productService?.toLowerCase() == 'service' ? 'Service' : 'Product'}',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            fontSize: 14.0,
          ),
        ),
        GestureDetector(
          onTap: _navigateToAddProduct,
          child: Text(
            ' ${categoryData?.productService?.toLowerCase() == 'service' ? 'Add Service' : 'Add Product'}',
            style: TextStyle(
              color: accentRed,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              fontSize: 12.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductsSection() {
    return PagedListView<int, ProductData>(
      pagingController: _paginationController.pagingController,
      builderDelegate: PagedChildBuilderDelegate<ProductData>(
        itemBuilder: (context, item, index) {
          return buildProductCard(item);
        },
        firstPageProgressIndicatorBuilder: (_) => SizedBox(),
        newPageProgressIndicatorBuilder: (_) => SizedBox(),
        noItemsFoundIndicatorBuilder: (context) => const Center(
          child: CompactGifDisplayWidget(
            gifPath: emptyListGif,
            title: "It's empty, over here.",
            subtitle: "No products in this category yet! Add to view them here.",
          ),
        ),
      ),
    );
  }
  
  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: outlineButton(text: 'Edit Category', onTap: _navigateToEditCategory, context: context),
    );
  }
}

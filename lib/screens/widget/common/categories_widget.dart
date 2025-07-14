import 'package:flutter/material.dart';
import 'package:zed_nano/models/listCategories/ListCategoriesResponse.dart' show ProductCategoryData;
import 'package:zed_nano/models/listProducts/ListProductsResponse.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/categories/tabs/product_categories_tab.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/utils/Colors.dart';

Widget buildCategoryCard(ProductCategoryData category) {
  return Builder(
    builder: (context) => GestureDetector(
      onTap: () {
        // Navigate to category detail page using context
        Navigator.pushNamed(
          context,
          AppRoutes.getCategoryDetailRoute(category.id ?? ''));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child:   rfCommonCachedNetworkImage(
                '${category.imagePath}',
                fit: BoxFit.fitHeight,
                height: 55,
                width: 55,
                radius: 8
              ),
            ),

            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.categoryName ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: darkGreyColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.categoryDescription ?? 'No description',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${category.subCategories?.length ?? 0} Products',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: darkBlueColor,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildProductCard(ProductData category) {
  return Builder(
    builder: (context) {
      return GestureDetector(
        onTap: () {
          // Navigate to category detail page using context
          Navigator.pushNamed(context, AppRoutes.getProductDetailRoute(category.id ?? ''));
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child:   rfCommonCachedNetworkImage(
                  '${category.imagePath}',
                  fit: BoxFit.fitHeight,
                  height: 55,
                  width: 55,
                    radius: 8
                ),
              ),

              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.productName ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: darkGreyColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.productDescription ?? 'No description',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${category.currency} ${category.productPrice}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: darkBlueColor,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

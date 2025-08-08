import 'package:flutter/material.dart';
import 'package:zed_nano/models/get_all_activeStock/GetAllActiveStockResponse.dart';
import 'package:zed_nano/models/get_customer_by_number/CustomerListResponse.dart';
import 'package:zed_nano/models/listProducts/ListProductsResponse.dart';
import 'package:zed_nano/models/listStockTake/GetActiveStockTakeResponse.dart';
import 'package:zed_nano/screens/business/bottomsheets/product_service_category_bottom_sheet.dart';
import 'package:zed_nano/screens/business/bottomsheets/setup_bottom_sheet.dart';
import 'package:zed_nano/screens/customers/details/bottomsheet/customer_options_bottom_sheet.dart';
import 'package:zed_nano/screens/invoices/bottomsheet/invoice_options_bottom_sheet.dart';
import 'package:zed_nano/screens/orders/bottomsheets/printing_options_bottom_sheet.dart';
import 'package:zed_nano/screens/payments/bottomsheets/add_kcb_options_bottomsheet.dart';
import 'package:zed_nano/screens/payments/bottomsheets/add_mpesa_options_bottomsheet.dart';
import 'package:zed_nano/screens/sell/bottomsheet/add_discount_bottom_sheet.dart';
import 'package:zed_nano/screens/stock/add_stock/addStock/steps/products/add_stock_product_bottom_sheet.dart';
import 'package:zed_nano/screens/stock/stock_take/addStockTake/steps/products/add_stock_take_product_bottom_sheet.dart';
import 'package:zed_nano/screens/widget/common/base_bottom_sheet.dart';
import 'package:zed_nano/screens/widget/common/confirmation_bottom_sheet.dart';
import 'package:zed_nano/screens/widget/common/form_bottom_sheet.dart';

/// Helper class to show different types of bottom sheets
class BottomSheetHelper {
  /// Shows the setup step bottom sheet
  static Future<void> showSetupStepBottomSheet(
    BuildContext context, {
    required String currentStep,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SetupStepBottomSheet(currentStep: currentStep),
    );
  }

  static Future<void> showCustomerOptionsBottomSheet(
    BuildContext context, {
    required CustomerData customerData,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomerOptionsBottomSheet(customerData: customerData),
    );
  }
  static Future<void> showPrintingOptionsBottomSheet(
    BuildContext context, {
    required String? printOrderInvoiceId,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PrintingOptionsBottomSheet(printOrderInvoiceId: printOrderInvoiceId),
    );
  }

  static Future<void> showAddDiscountBottomSheet(
    BuildContext context, {
    required ProductData? productData,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddDiscountBottomSheet(productData: productData),
    );
  }

  static Future<void> showAddStockBottomSheet(
    BuildContext context, {
    required ActiveStockProduct activeStockProduct,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddStockProductBottomSheet(product: activeStockProduct),
    );
  }


  static Future<void> showAddStockTakeBottomSheet(
    BuildContext context, {
    required StockTakeProduct activeStockProduct,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddStockTakeProductBottomSheet(product: activeStockProduct),
    );
  }


  static Future<void> showInvoiceOptionsBottomSheet(
    BuildContext context, {
    required String? invoiceNumber,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => InvoiceOptionsBottomSheet(invoiceNumber: invoiceNumber),
    );
  }

  static Future<void> showProductServiceCategoryBottomSheet(
    BuildContext context,) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductServiceCategoryBottomSheet(),
    );
  }
  static Future<void> showAddKcbOptionsBottomsheet(
    BuildContext context,) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddKcbOptionsBottomsheet(),
    );
  }
  static Future<void> showAddMpesaOptionsBottomsheet(
    BuildContext context,) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddMpesaOptionsBottomsheet(),
    );
  }

  /// Shows a confirmation bottom sheet
  static Future<void> showConfirmationBottomSheet(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onConfirm, String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color confirmColor = const Color(0xffe86339),
    Color cancelColor = const Color(0xff71727a),
    Widget? icon,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ConfirmationBottomSheet(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmColor: confirmColor,
        cancelColor: cancelColor,
        onConfirm: onConfirm,
        icon: icon,
      ),
    );
  }

  /// Shows a form bottom sheet
  static Future<void> showFormBottomSheet(
    BuildContext context, {
    required String title,
    required List<Widget> formFields,
    required String submitButtonText,
    required VoidCallback onSubmit, Color submitButtonColor = const Color(0xffe86339),
    bool isSubmitting = false,
    String? subtitle,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FormBottomSheet(
        title: title,
        formFields: formFields,
        submitButtonText: submitButtonText,
        submitButtonColor: submitButtonColor,
        onSubmit: onSubmit,
        isSubmitting: isSubmitting,
        subtitle: subtitle,
      ),
    );
  }

  /// Shows a custom bottom sheet using the base bottom sheet
  static Future<void> showCustomBottomSheet(
    BuildContext context, {
    required String title,
    required Widget bodyContent, bool showCloseButton = true,
    double initialChildSize = 0.9,
    double minChildSize = 0.5,
    double maxChildSize = 1.0,
    Widget? headerContent,
    EdgeInsets contentPadding = const EdgeInsets.symmetric(horizontal: 16),
    Color backgroundColor = Colors.white,
    BorderRadius borderRadius = const BorderRadius.vertical(top: Radius.circular(20)),
    VoidCallback? onClose,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BaseBottomSheet(
        title: title,
        showCloseButton: showCloseButton,
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        headerContent: headerContent,
        bodyContent: bodyContent,
        contentPadding: contentPadding,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        onClose: onClose,
      ),
    );
  }
}

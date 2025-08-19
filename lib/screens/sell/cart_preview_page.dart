import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart'hide navigatorKey;
import 'package:provider/provider.dart';
import 'package:zed_nano/app/app_initializer.dart' ;
import 'package:zed_nano/providers/cart/CartViewModel.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/invoices/detail/invoice_detail_page.dart';
import 'package:zed_nano/screens/stock/add_stock/addStock/add_stock_parent_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/common/bottom_sheet_helper.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/reusable_stepper_widget.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/utils/extensions.dart';
import 'package:zed_nano/viewmodels/CustomerInvoicingViewModel.dart';
import 'package:zed_nano/viewmodels/data_refresh_extensions.dart';

//create an enum class for
// - SaveOrder
// - RequestPayment
// - MoreOptions

enum CreateOrderOption {
  saveOrder,
  requestPayment,
  moreOptions,
}

class CartPreviewPage extends StatefulWidget {
  const CartPreviewPage({required this.onNext, required this.onPrevious, required this.skipAndClose, super.key, this.customerId});
  final String? customerId;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback skipAndClose;

  @override
  State<CartPreviewPage> createState() => _CartPreviewPageState();
}

class _CartPreviewPageState extends State<CartPreviewPage> {
  final TextEditingController _narrationController = TextEditingController();
  bool _isContactDetailsExpanded = false;

  @override
  void dispose() {
    _narrationController.dispose();
    super.dispose();
  }

  Future<void> saveOrder(CreateOrderOption  createOrderOption) async {
    final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
    final cartItems = cartViewModel.items;
    final subTotalAmount = cartViewModel.subTotalAmount;

    final receiptNumber = DateTime.now().millisecondsSinceEpoch.toString().substring(0, 13);
    final List<Map<String, dynamic>> itemsArray = cartItems.map((item) {
      return {
        'discount': item.discount,
        'discountPercent': 0.0,
        'discountType': 'Amount',
        '_id': item.id,
        'itemAmount': item.price * item.quantity,
        'itemCategory': item.category ?? '',
        'itemCount': item.quantity.toDouble(),
        'itemName': item.name ?? '',
        'productId': item.id,
        // 'reciptNumber': receiptNumber,
        'totalAmount': item.price * item.quantity,
        'unitOfMeasure': 'Unit',
      };
    }).toList();
    
    final requestData = <String, dynamic>{
      'transamount': subTotalAmount,
      'customerName': _narrationController.text.isEmpty ? '' : _narrationController.text,
      'customerId': widget.customerId ?? '', // You might want to get this from user session
      'items': itemsArray,
    };

    logger.d('Request Data: $requestData');


    await getBusinessProvider(context).createOrder(
        requestData: requestData,
        context: context,)
        .then((value) async {
      if (value.isSuccess) {
        showCustomToast(value.message ?? 'Customer created successfully',
            isError: false,);
        if (createOrderOption == CreateOrderOption.saveOrder) {
          await triggerRefreshEvent();
          widget.skipAndClose();
        }
        if (createOrderOption == CreateOrderOption.requestPayment) {
          // Pass the order ID to the stepper system
          final orderId = value.data?.data?.id;
          if (orderId != null) {
            final currentStepData = StepperController.getStepData(context);
            currentStepData['orderId'] = orderId;
            StepperController.updateStepData(context, currentStepData);
          }
          widget.onNext();
        }
        if (createOrderOption == CreateOrderOption.moreOptions) {



          BottomSheetHelper.showPrintingOptionsBottomSheet(context, printOrderInvoiceId: value.data?.data?.id).then((value) async {
            await triggerRefreshEvent();
            widget.skipAndClose();
          });
        }
        cartViewModel.clear();
      } else {

        if (value.message?.contains('stock') == true) {
          showCustomToast("${value.message?.extractProductName} Out of stock", isError: true, actionText: 'Add Stock', onPressed: (){
            Future.delayed(const Duration(milliseconds: 500), () {
              navigatorKey.currentState?.push(
                MaterialPageRoute(builder: (context) => const AddStockParentPage()),
              );
            });
          }, context: context);
        }else{
          showCustomToast(value.message ?? 'Something went wrong');
        }
      }
    });

  }
  Future<void> _sendInvoice() async {
    final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
    final customerInvoicingViewModel = Provider.of<CustomerInvoicingViewModel>(context, listen: false);
    final cartItems = cartViewModel.items;
    final List<Map<String, dynamic>> itemsArray = cartItems.map((item) {
      return {
        'discount': item.discount,
        'discountPercent': 0.0,
        'discountType': 'Amount',
        'productId': item.id,
        'amount': item.price,
        'quantity': item.quantity.toDouble(),
      };
    }).toList();

    final requestData = <String, dynamic>{
      'customerId': customerInvoicingViewModel.invoiceDetailItem.customerId,
      'type': customerInvoicingViewModel.invoiceDetailItem.type,
      'frequency': customerInvoicingViewModel.invoiceDetailItem.frequency,
      'products': itemsArray,
    };

    logger.d('Request Data: $requestData');


    await getBusinessProvider(context).sendInvoice(
        requestData: requestData,
        context: context,)
        .then((value) {
      if (value.isSuccess) {
        showCustomToast(value.message ?? 'Invoice Generated successfully',
            isError: false,);

        InvoiceDetailPage(invoiceNumber: value.data?.data?.invoiceNumber).launch(context).then((value) {
          widget.onNext();
          customerInvoicingViewModel.clearData();
          cartViewModel.clear();
        });

      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });

  }

  Future<void> triggerRefreshEvent() async {
    try {
      // Trigger refresh for order-related data across the app
      context.dataRefresh.refreshAfterOrderOperation(operation: 'order_updated');
      logger.d('OrderDetailPage: Triggered refresh event for order operation');
    } catch (e) {
      logger.e('OrderDetailPage: Failed to trigger refresh event: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context);
    final customerInvoicingViewModel = Provider.of<CustomerInvoicingViewModel>(context);


    return Scaffold(
      backgroundColor: Colors.white,
      appBar:_buildAppBar(customerInvoicingViewModel),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fixed header section
              _cartHeader(cartViewModel, customerInvoicingViewModel),
              // const SizedBox(height: 12),
              
              // Flexible content section
              Expanded(
                child: Column(
                  children: [
                    // Scrollable cart items
                    Expanded(
                      child: _cartListing(cartViewModel),
                    ),
                    
                    // Fixed bottom sections
                    _createNarationView(cartViewModel, customerInvoicingViewModel),
                    _createSummaryView(cartViewModel),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: _buildSubmitButton(cartViewModel, customerInvoicingViewModel),
    );
  }

  Widget _createSummaryView(CartViewModel cartViewModel) {
    final subTotalAmount = cartViewModel.subTotalAmount;
    final totalAmount = cartViewModel.totalAmount;
    final itemCount = cartViewModel.itemCount;
    final totalDiscount = cartViewModel.totalDiscount;
    return Container(
        width: context.width(),
        decoration: BoxDecoration(
          color: lightGreyColor,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,

                    ),
                ),
                Text('KES ${subTotalAmount.formatCurrency()}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,
                    ),
                ),
              ],
            ).paddingSymmetric(vertical: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Discount',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,

                    ),
                ),
                Text('KES ${totalDiscount.formatCurrency()}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,
                    ),
                ),
              ],
            ).paddingSymmetric(vertical: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,


                    ),
                ),
                Text('KES ${totalAmount.formatCurrency()}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,


                    ),
                ),
              ],
            ).paddingSymmetric(vertical: 10),
          ],
        ),).paddingSymmetric(horizontal: 16);
  }

  Widget _buildSubmitButton(CartViewModel cartViewModel, CustomerInvoicingViewModel customerInvoicingViewModel) {

    return customerInvoicingViewModel.customerData != null
    ?  Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
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
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: appButton(
                text:'Send Invoice',
                onTap: () async {
                  await _sendInvoice();
                },
                context: context,
              ),
            ),
          ],
        ),
      ),
    )
     : Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.05),
        //     blurRadius: 10,
        //     offset: const Offset(0, -5),
        //   ),
        // ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: outlineButton(
                text:'Save Order',
                onTap: () async {
                  await saveOrder(CreateOrderOption.saveOrder);
                },
                context: context,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              flex: 4,
              child: appButton(
                text:'Request Payment',
                onTap: () async {
                  await saveOrder(CreateOrderOption.requestPayment);
                },
                context: context,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              flex: 2,
              child: appButtonWithIcon(
                text: '',
                iconPath: fabMenuIcon,
                context: context,
                onTap: () async {
                  await saveOrder(CreateOrderOption.moreOptions);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createCheakoutView(CartViewModel cartViewModel) {
    final totalAmount = cartViewModel.totalAmount;
    final itemCount = cartViewModel.itemCount;
    return   Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Total amount card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F9F6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$itemCount Items',
                  style: const TextStyle(
                    color: textPrimary,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'KES ${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: successTextColor,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Checkout button
          SizedBox(
              width: double.infinity,
              height: 56,
              child: appButton(text: 'Checkout', onTap: (){
                widget.onNext();
              }, context: context,),
          ),
        ],
      ),
    );
  }

  Widget _createNarationView(CartViewModel cartViewModel, CustomerInvoicingViewModel customerInvoicingViewModel) {
    return  Visibility(
      visible: customerInvoicingViewModel.customerData == null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Narration',
                  style: TextStyle(
                    color: textPrimary,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(Optional)',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            StyledTextField(
              textFieldType: TextFieldType.MULTILINE,
              hintText:'Enter narration...',
              controller: _narrationController,
            ),
          ],
        ),
      ),
    );
  }

  Widget _cartListing(CartViewModel cartViewModel){
    final cartItems = cartViewModel.items;

    return cartItems.isEmpty
        ? const Center(
      child: CompactGifDisplayWidget(
        gifPath: emptyListGif,
        title: "It's empty, over here.",
        subtitle:
        'No products in your cart yet! Add to view them here.',
      ),
    )
        : ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: cartItems.length,
      separatorBuilder: (context, index) => const Divider(height: 0.5, color: innactiveBorderCart,),
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return _buildCartItem(
          item: item,
          cartViewModel: cartViewModel,
          onDecrease: () {
            if (item.quantity > 0) {
              if (item.quantity == 1) {
                cartViewModel.removeItem(item.id);
              } else {
                cartViewModel.updateQuantity(
                    item.id ?? '', item.quantity - 1,);
              }
            }
          },
          onIncrease: () {
            if (item.quantity == 0) {
              cartViewModel.addItem(
                item.id ?? '',
                item.name ?? '',
                item.price ?? 0.0,
                item.imagePath ?? '',
                item.currency ?? '',
                item.category ?? '',
                0,
              );
            } else {
              cartViewModel.updateQuantity(
                  item.id ?? '', item.quantity + 1,);
            }
          },);
      },
    );
  }

  Widget _cartHeader(CartViewModel cartViewModel, CustomerInvoicingViewModel customerInvoicingViewModel){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(customerInvoicingViewModel.customerData != null ? 'Preview Invoice' : 'Order Items',
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                letterSpacing: 0.09,
              ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(customerInvoicingViewModel.customerData != null ? 'Here’s a preview of your invoice.' :'Tap on a product to edit.',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0.12,
                  ),
              ),
              Visibility(
                visible: customerInvoicingViewModel.customerData == null,
                child: TextButton(
                  onPressed: cartViewModel.clear,
                  child: const Text(
                    'Clear Cart',
                    style: TextStyle(
                      color: accentRed,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: customerInvoicingViewModel.customerData != null,
            child: Column(
              children: [
                16.height,
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Invoice Details',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xff000000),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        ),
                    ),
                    Text('Edit',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: googleRed,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        ),
                    ),
                  ],
                ),
                8.height,
                _buildSummary(customerInvoicingViewModel),
                8.height,
                _buildCustomerDetails(customerInvoicingViewModel),
                8.height,
                _buildInvoiceItemsHeader(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceItemsHeader(){
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Items',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
            ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tap on a product to edit.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 0.12,

                ),
            ),
            Text('Add Item',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: googleRed,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomerDetails(CustomerInvoicingViewModel customerInvoicingViewModel){
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 6,),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isContactDetailsExpanded = !_isContactDetailsExpanded;
              });
            },
            child: Row(
              children: [
                Expanded(
                  child: Text("To: ${customerInvoicingViewModel.customerData?.customerName ?? 'N/A'}",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ),
                  ),
                ),
                rfCommonCachedNetworkImage(
                    _isContactDetailsExpanded ? upIcon : dropIcon,
                    fit: BoxFit.cover,
                    height: 15,
                    width: 15,
                    radius: 8,
                ),
              ],
            ).paddingSymmetric(vertical: 10),
          ),
          if (_isContactDetailsExpanded) ...[
            Row(
                children: [
                  rfCommonCachedNetworkImage(
                      phoneIconGray,
                      fit: BoxFit.cover,
                      height: 15,
                      width: 15,
                      radius: 8,
                  ),
                  6.width,
                  Text(customerInvoicingViewModel.customerData?.mobileNumber ?? 'N/A',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.12,

                      ),
                  ),
                ],
            ).paddingSymmetric(vertical: 5),
            Row(
                children: [
                  rfCommonCachedNetworkImage(
                      emailIconGray,
                      fit: BoxFit.cover,
                      height: 15,
                      width: 15,
                      radius: 0,
                  ),
                  6.width,
                  Text(customerInvoicingViewModel.customerData?.email ?? 'N/A',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.12,

                      ),
                  ),
                ],
            ).paddingSymmetric(vertical: 5),
            Row(
                children: [
                  rfCommonCachedNetworkImage(
                      locationIcon,
                      fit: BoxFit.cover,
                      height: 15,
                      width: 15,
                      radius: 0,
                  ),
                  6.width,
                  Expanded(
                    child: Text(customerInvoicingViewModel.customerData?.physicalAddress ?? 'N/A',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.12,
                        ),
                    ),
                  ),
                ],
            ).paddingSymmetric(vertical: 5),
          ],
        ],
      ),
    );
  }

  Widget _buildSummary(CustomerInvoicingViewModel customerInvoicingViewModel) {
    return Row(
      children: [
        Expanded(
          child: Container(

              decoration: BoxDecoration(
                color: cardBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Date Issued',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.12,

                      ),
                  ),
                  Text(DateFormatter.getCurrentFormattedDate(),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                  ),
                ],
              ),
          ),
        ),
        16.width,
        Expanded(
          child: Container(
              decoration: BoxDecoration(
                color: cardBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Purchase Order No',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.12,

                      ),
                  ),
                  Text(customerInvoicingViewModel.invoiceDetailItem.purchaseOrderNumber ?? 'N/A',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: textSecondary,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                  ),
                ],
              ),
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar(CustomerInvoicingViewModel customerInvoicingViewModel) {
    return AuthAppBar(
      title: customerInvoicingViewModel.customerData != null ? 'Create Invoice' : 'Preview Cart',
      onBackPressed: widget.onPrevious,
      actions: [
        Visibility(
          visible: customerInvoicingViewModel.customerData == null,
          child: TextButton(
            onPressed: () {
              widget.onPrevious();
            },
            child: const Text(
              'Add Items',
              style: TextStyle(
                color: accentRed,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartItem({
    required CartItem item,
    required CartViewModel cartViewModel,
    required VoidCallback onDecrease,
    required VoidCallback onIncrease,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              cartViewModel.removeItem(item.id);
            },
            child: const SizedBox(
              width: 24,
              height: 24,
              child: Center(
                child: Icon(
                  Icons.remove,
                  color: accentRed,
                  size: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          rfCommonCachedNetworkImage(
            item.imagePath ?? '',
            fit: BoxFit.cover,
            height: 42,
            width: 42,
          ),
          const SizedBox(width: 5),
          // Product details
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: Color(0xFF323232),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      item.category ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Text(
                      ' · ',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Text(
                      '${item.currency ?? 'KES'} ${item.total.formatCurrency()}',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('x${item.quantity ?? 0}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("${item.currency ?? 'KES'} ${item.price.formatCurrency()}",
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,


                          ),
                      ),
                      Text("${item.currency ?? 'KES'} ${item.discount.formatCurrency()}",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: item.discount == 0 ? Colors.grey : successTextColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            letterSpacing: 0.15,

                          ),
                      ),

                    ],
                ),

              ],
            ),
          ),
        ],
      ),
    ).paddingSymmetric(
      vertical: 16,
    );
  }

  }

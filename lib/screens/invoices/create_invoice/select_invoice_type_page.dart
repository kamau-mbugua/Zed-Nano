import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/filter_row_widget.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/screens/widget/common/selection_chips_widget.dart';
import 'package:zed_nano/screens/widget/common/sub_category_picker.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/viewmodels/CustomerInvoicingViewModel.dart';

class SelectInvoiceTypePage extends StatefulWidget {
  const SelectInvoiceTypePage({required this.onNext, required this.onPrevious, super.key});
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  _SelectInvoiceTypePageState createState() => _SelectInvoiceTypePageState();
}

class _SelectInvoiceTypePageState extends State<SelectInvoiceTypePage> {

  List<String> invoiceTypes = ['One-Off', 'Recurring'];
  String selectedIinvoiceTypes = 'One-Off';
  List<String> recurrencyTypes = ['Daily', 'Weekly', 'Monthly', 'Quarterly' ,'Yearly'];
  String? selectedRecurrencyType;

  FocusNode purchaseFocusNode = FocusNode();
  TextEditingController purchaseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(title: 'Create Invoice', onBackPressed: widget.onPrevious),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headings(
            label: 'Invoice Details',
            subLabel: 'Fill in the details to create your invoice.',
          ),
          16.height,
          _selectCustomer(),
          16.height,
          _selectInvoiceType(),
          16.height,
          _buildReccurency(),
          _buildPurchaseOrder(),

        ],
      ).paddingSymmetric(horizontal: 18),
      bottomNavigationBar: _buildSubmitButton(),
    );
  }

  Widget _buildReccurency() {
    return Visibility(
      visible: selectedIinvoiceTypes == 'Recurring',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Customer Name',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: textPrimaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
            ),
        ),
        const SizedBox(height: 8),
        SubCategoryPicker(
          label: 'Select Recurrency Type',
          options: recurrencyTypes ?? [],
          selectedValue: selectedRecurrencyType,
          onChanged: (value) {
            final selectedCat = value;
            setState(() {
              selectedRecurrencyType = selectedCat;
            });
          },
        ),
        16.height,
      ],
      ),
    );

  }

  Widget _selectInvoiceType() {
    return Padding(
      padding: const EdgeInsets.symmetric(),
      child: SelectionChipsWidget(
        title: 'Invoice Type',
        options: invoiceTypes,
        selectedOption: selectedIinvoiceTypes,
        onSelectionChanged: (String selectedType) {
          setState(() {
            selectedIinvoiceTypes = selectedType;
          });
        },
      ),
    );
  }

  Widget _buildSubmitButton(){
    final customerInvoicingViewModel = Provider.of<CustomerInvoicingViewModel>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      child: appButton(
        text: 'Next',
        onTap: () {
          if(selectedIinvoiceTypes == 'Recurring' && selectedRecurrencyType == null){
            showCustomToast('Please select Recurrency Type');
            return;
          }
          if(selectedIinvoiceTypes == 'Recurring' && selectedRecurrencyType == null){
            showCustomToast('Please select Recurrency Type');
            return;
          }
          customerInvoicingViewModel.addInvoiceDetailItem(
              type: selectedIinvoiceTypes.toLowerCase(),
              frequency: selectedIinvoiceTypes == 'Recurring' ? selectedRecurrencyType : 'once',
              purchaseOrderNumber: purchaseController.text,
              customerId: customerInvoicingViewModel.customerData?.id ?? '',
          );
          widget.onNext();
        },
        context: context,
      ),
    ).paddingSymmetric(horizontal: 16, vertical: 12);
  }

  Widget _selectCustomer() {
    final customerInvoicingViewModel = Provider.of<CustomerInvoicingViewModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Customer Name',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: textPrimaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
            ),
        ),
        FilterRowWidget(
            leftButtonText: customerInvoicingViewModel.customerData?.customerName ?? 'Select Customer',
            leftButtonIsActive: true,
            leftButtonOnTap: () {
              widget.onPrevious();
            },
            rightButtonText: '', // Not used when hidden
            rightButtonIsActive: false,
            rightButtonOnTap: () {},
            showRightButton: false, // Hide right button
          ),
      ],
    );
  }
  Widget _buildPurchaseOrder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Purchase Order',
              style: TextStyle(
                color: textPrimary,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '(Optional)',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 11,
              ),
            ),
          ],
        ),
        8.height,
        StyledTextField(
          textFieldType: TextFieldType.NAME,
          hintText: 'Purchase Order',
          focusNode: purchaseFocusNode,
          controller: purchaseController,
        ),
      ],
    );
  }
}

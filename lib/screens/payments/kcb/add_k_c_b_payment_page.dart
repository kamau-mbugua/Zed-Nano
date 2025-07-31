import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/models/business/BusinessDetails.dart';
import 'package:zed_nano/providers/business/BusinessProviders.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/common/common_webview_page.dart';
import 'package:zed_nano/screens/widget/auth/terms_checkbox.dart';
import 'package:zed_nano/viewmodels/payment_view_model.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/extensions.dart';


class AddKCBPaymentPage extends StatefulWidget {
  final String kcbAccountType;
  const AddKCBPaymentPage({super.key, required this.kcbAccountType});

  @override
  State<AddKCBPaymentPage> createState() => _AddKCBPaymentPageState();
}

class _AddKCBPaymentPageState extends State<AddKCBPaymentPage> {
  FocusNode accountNumberFocusNode = FocusNode();
  FocusNode accountNumberConfirmFocusNode = FocusNode();

  TextEditingController accountNumberController = TextEditingController();
  TextEditingController accountNumberConfirmController = TextEditingController();

  BusinessDetails? businessDetails;
  bool termsAccepted = false;








  Future<void> _addKCBPayment(Map<String, dynamic> requestData) async {
    await context
        .read<BusinessProviders>()
        .addKCBPayment(requestData: requestData, context: context)
        .then((value) {
      if (value.isSuccess) {
        showCustomToast(value.message ?? 'Category created successfully',
            isError: false);
        PaymentViewModel().setNeedsRefresh(true);
        Navigator.pop(context); // Return to the previous screen
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }



  @override
  void initState() {
    businessDetails = getBusinessDetails(context);
    super.initState();
  }


  @override
  void dispose() {
    accountNumberFocusNode.dispose();
    accountNumberConfirmFocusNode.dispose();

    accountNumberController.dispose();
    accountNumberConfirmController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    String itemName;
    if(widget.kcbAccountType == 'VOOMATILL'){
      itemName = 'Vooma Till';
    }else if(widget.kcbAccountType == 'KCBACCOUNT'){
      itemName = 'KCB Account';
    }else{
      itemName = 'KCB Account';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  AuthAppBar(title: 'Add Payment Method'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            // Category Name
            headings(
              label: '$itemName Number Setup',
              subLabel: 'Enter your $itemName number details',
            ),
            _formFields(itemName),
            const SizedBox(height: 32),
            appButton(
              text: 'Activate',
              context: context,
              onTap: () {
                final accountNumber = accountNumberController.text;
                final accountNumberConfirm = accountNumberConfirmController.text;



                if(!accountNumber.isValidInput){
                  showCustomToast('Please Provide a valid $itemName number', isError: true);
                  return;
                }
                if(!accountNumberConfirm.isValidInput){
                  showCustomToast('', isError: true);
                  return;
                }
                if(accountNumber != accountNumberConfirm){
                  showCustomToast('$itemName number does not match', isError: true);
                  return;
                }

                final requestData = <String, dynamic>{};
                requestData['accountNumber'] = accountNumber;
                requestData['kcbAccountType'] = widget.kcbAccountType;

                _addKCBPayment(requestData);

              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _formFields(String itemName) {

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name
          Text(
            "$itemName Number",
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: Color(0xFF484848),
            ),
          ),
          const SizedBox(height: 8),
          StyledTextField(
            textFieldType: TextFieldType.NUMBER,
            hintText: 'Enter $itemName Number',
            focusNode: accountNumberFocusNode,
            nextFocus: accountNumberConfirmFocusNode,
            controller: accountNumberController,
          ),
          16.height,
          Text(
            'Confirm $itemName Number',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: Color(0xFF484848),
            ),
          ),
          const SizedBox(height: 8),
          StyledTextField(
            textFieldType: TextFieldType.NUMBER,
            hintText: 'Enter $itemName Number',
            focusNode: accountNumberConfirmFocusNode,
            controller: accountNumberConfirmController,
          ),
          12.width,
          TermsCheckbox(
            initialValue: termsAccepted,
            onChanged: (value) {
              setState(() {
                termsAccepted = value;
              });
            },
            onClick: () {
              const CommonWebViewPage(
                url: 'https://zed.business/Terms%20&%20Conditions.html',
                showAppBar: false,
              );
            },
          ),
          24.height,
        ]);
  }
}

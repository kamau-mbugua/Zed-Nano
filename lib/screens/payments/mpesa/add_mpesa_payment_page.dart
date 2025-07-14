import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/models/business/BusinessDetails.dart';
import 'package:zed_nano/providers/business/BusinessProviders.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/widget/auth/terms_checkbox.dart';
import 'package:zed_nano/viewmodels/payment_view_model.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/extensions.dart';


class AddMpesaPaymentPage extends StatefulWidget {
  final String mpesaAccountType;
  const AddMpesaPaymentPage({super.key, required this.mpesaAccountType});

  @override
  State<AddMpesaPaymentPage> createState() => _AddMpesaPaymentPageState();
}

class _AddMpesaPaymentPageState extends State<AddMpesaPaymentPage> {
  FocusNode businessNameFocusNode = FocusNode();
  FocusNode accountNumberFocusNode = FocusNode();
  FocusNode storeNumberFocusNode = FocusNode();
  FocusNode consumerSecreteFocusNode = FocusNode();
  FocusNode consumerKeyFocusNode = FocusNode();
  FocusNode passKeyConfirmFocusNode = FocusNode();
  FocusNode hoNumberFocusNode = FocusNode();

  TextEditingController businessNameController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController storeNumberController = TextEditingController();
  TextEditingController consumerSecreteController = TextEditingController();
  TextEditingController consumerKeyController = TextEditingController();
  TextEditingController passKeyConfirmController = TextEditingController();
  TextEditingController hoNumberController = TextEditingController();
  BusinessDetails? businessDetails;

  bool termsAccepted = false;



  Future<void> _addMPESAPayment(Map<String, dynamic> requestData) async {
    await context
        .read<BusinessProviders>()
        .addMPESAPayment(requestData: requestData, context: context)
        .then((value) {
      if (value.isSuccess) {
        showCustomToast(value.message,
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
    businessNameController.dispose();
    accountNumberController.dispose();
    storeNumberController.dispose();
    consumerSecreteController.dispose();
    consumerKeyController.dispose();
    passKeyConfirmController.dispose();
    hoNumberController.dispose();

    businessNameFocusNode.dispose();
    accountNumberFocusNode.dispose();
    storeNumberFocusNode.dispose();
    consumerSecreteFocusNode.dispose();
    consumerKeyFocusNode.dispose();
    passKeyConfirmFocusNode.dispose();
    hoNumberFocusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    String itemName;
    if(widget.mpesaAccountType == 'MPESATILL'){
      itemName = 'Till';
    }else if(widget.mpesaAccountType == 'MPESAPAYBILL'){
      itemName = 'Paybill';
    }else{
      itemName = 'Till';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AuthAppBar(title: 'Add Payment Method'),
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
                final accountReference = accountNumberController.text;
                final consumerSecret = consumerSecreteController.text;
                final storeNumber = storeNumberController.text;
                final consumerKey = consumerKeyController.text;
                final passKey = passKeyConfirmController.text;
                final hoNumber = hoNumberController.text;
                final businessName = businessNameController.text;
                const TransactionType = 'CustomerBuyGoodsOnline';
                final businessShortCode = accountReference ;
                const thirdPartyCallback = 'https://zed.swerri.io/api/stkCallback';
                final tillNumber = accountReference;
                final isTermsAndConditionsChecked = termsAccepted;


                if (!businessName.isValidInput) {
                  showCustomToast("Please provide a valid $itemName business Name",);
                  return;
                }

                if (!accountReference.isValidInput) {
                  showCustomToast("Please provide a valid $itemName number",);
                  return;
                }

                if(widget.mpesaAccountType == 'MPESATILL'){
                  if (!storeNumber.isValidInput) {
                    showCustomToast("Please provide a valid $itemName store number",);
                    return;
                  }

                  if (!storeNumber.isValidInput) {
                    showCustomToast("Please provide a valid $itemName store number",);
                    return;
                  }

                  if (!hoNumber.isValidInput) {
                    showCustomToast("Please provide a valid $itemName HO number",);
                    return;
                  }
                }


                if (!consumerSecret.isValidInput) {
                  showCustomToast("Please provide a valid $itemName consumer secret",);
                  return;
                }

                if (!consumerKey.isValidInput) {
                  showCustomToast("Please provide a valid $itemName consumer key",);
                  return;
                }

                if (!passKey.isValidInput) {
                  showCustomToast("Please provide a valid $itemName pass key",);
                  return;
                }

                if (!isTermsAndConditionsChecked) {
                  showCustomToast("Please accept the terms and conditions",);
                  return;
                }


                final requestData = <String, dynamic>{};
                requestData['accountReference'] = accountReference;
                requestData['consumerSecret'] = consumerSecret;
                requestData['consumerKey'] = consumerKey;
                requestData['passKey'] = passKey;
                requestData['businessName'] = businessName;
                requestData['businessShortCode'] = businessShortCode;
                requestData['thirdPartyCallback'] = thirdPartyCallback;

                if(widget.mpesaAccountType == 'MPESATILL'){
                  requestData['storeNumber'] = storeNumber;
                  requestData['hoNumber'] = hoNumber;
                  requestData['transactionType'] = TransactionType;
                  requestData['tillNumber'] = tillNumber;
                }
                
                logger.e('requestData: $requestData');
                
                _addMPESAPayment(requestData);
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
            'Business Name',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: Color(0xFF484848),
            ),
          ),
          const SizedBox(height: 8),
          StyledTextField(
            textFieldType: TextFieldType.NAME,
            hintText: 'Enter Business Name',
            focusNode: businessNameFocusNode,
            nextFocus: accountNumberFocusNode,
            controller: businessNameController,
          ),
          16.height,
          Text(
            '$itemName Number',
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
            nextFocus: widget.mpesaAccountType == 'MPESAPAYBILL' ? consumerSecreteFocusNode : storeNumberFocusNode,
            controller: accountNumberController,
          ),
          16.height,
          if(widget.mpesaAccountType != 'MPESAPAYBILL')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Text(
            'Store Number',
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
            hintText: 'Store Number',
            focusNode: storeNumberFocusNode,
            nextFocus: hoNumberFocusNode,
            controller: storeNumberController,
          ),
          16.height,
          Text(
            'HO Number',
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
            hintText: 'Store Number',
            focusNode: hoNumberFocusNode,
            nextFocus: consumerSecreteFocusNode,
            controller: hoNumberController,
          ),
          ],
          ),
          16.height,
          Text(
            'Consumer Secret',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: Color(0xFF484848),
            ),
          ),
          const SizedBox(height: 8),
          StyledTextField(
            textFieldType: TextFieldType.PASSWORD,
            hintText: 'Consumer Secret',
            focusNode: consumerSecreteFocusNode,
            nextFocus: consumerKeyFocusNode,
            controller: consumerSecreteController,
          ),
          16.height,
          Text(
            'Consumer Key',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: Color(0xFF484848),
            ),
          ),
          const SizedBox(height: 8),
          StyledTextField(
            textFieldType: TextFieldType.PASSWORD,
            hintText: 'Consumer Key',
            focusNode: consumerKeyFocusNode,
            nextFocus: passKeyConfirmFocusNode,
            controller: consumerKeyController,
          ),
          16.height,
          Text(
            'Pass Key',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: Color(0xFF484848),
            ),
          ),
          const SizedBox(height: 8),
          StyledTextField(
            textFieldType: TextFieldType.PASSWORD,
            hintText: 'Pass Key',
            focusNode: passKeyConfirmFocusNode,
            controller: passKeyConfirmController,
          ),
          12.height,
          TermsCheckbox(
            initialValue: termsAccepted,
            onChanged: (value) {
              setState(() {
                termsAccepted = value;
              });
            },
          ),
          24.height,
        ]);
  }
}

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart' hide navigatorKey;
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/approvals/customers/customers_pending_approval_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/screens/widget/common/location_picker_field.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/extensions.dart';

class AddCustomers extends StatefulWidget {
  const AddCustomers({super.key});

  @override
  _AddCustomersState createState() => _AddCustomersState();
}

class _AddCustomersState extends State<AddCustomers> {
  String? _selectedLocation;
  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode locationFocusNode = FocusNode();
  FocusNode phoneNumberFocusNode = FocusNode();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  //create a list of customer types, Individual and Company
  List<String> customerTypes = ['Individual', 'Company'];
  String selectedCustomerType = 'Individual';

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    codeController.dispose();
    locationController.dispose();
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    emailFocusNode.dispose();
    phoneFocusNode.dispose();
    locationFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    super.dispose();
  }


  Future<void> _createCustomer(Map<String, dynamic> requestData) async {
    await getBusinessProvider(context).createCustomer(
        requestData: requestData,
        context: context,)
        .then((value) {
      if (value.isSuccess) {
        Navigator.pop(context);
        showCustomToast(value.message ?? 'Customer created successfully', isError: false, actionText: 'Approve', onPressed: (){
          Future.delayed(const Duration(milliseconds: 500), () {
            navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (context) => const CustomersPendingApprovalPage()),
            );
          });
        }, context: context);
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  const AuthAppBar(title: 'Add Customers'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headings(
              label: 'New Customer',
              subLabel: 'Enter your customer details.',
            ),
            16.height,
            _buildCustomerTypeSelector(),
            16.height,
            _buildInputNameFields(),
            16.height,
            _buildCustomerContactFields(),
            16.height,
          ],
        ).paddingSymmetric(horizontal: 18),
      ),
      bottomNavigationBar: _buildSubmitButton(),
    );
  }

  Widget _buildSubmitButton(){
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
        text: 'Add Customer',
        onTap: () {
          final selectedCustomer = customerTypes.firstWhere((element) => element == selectedCustomerType);
          final firstName = firstNameController.text;
          var lastName = lastNameController.text;
          final email = emailController.text;
          var phone = phoneController.text;
          final location = locationController.text;

          if(selectedCustomerType == 'Company'){
            lastName = '.';
          }

          if(!firstName.isValidInput){
            return showCustomToast('Please enter first name');
          }
          if(!lastName.isValidInput){
            return showCustomToast('Please enter last name');
          }
          if(!email.isValidEmail){
            return showCustomToast('Please enter valid email');
          }
          if(!phone.isValidPhoneNumber){
            return showCustomToast('Please enter valid phone number');
          }
          if(!location.isValidInput){
            return showCustomToast('Please enter location');
          }

          final phoneNumber = phoneController.text;
          final countryCode = codeController.text;
          phone = '$countryCode$phoneNumber';

          final requestData = {
            'firstName': firstName,
            'lastName': lastName,
            'email': email,
            'phone': phone,
            'customerAddress': location,
            'customerType': selectedCustomer,
            'paymentType': 'Normal',
            'serialVersionUID':'2576532132122260222L',
          };

          logger.d(requestData);

          _createCustomer(requestData);



        },
        context: context,
      ),
    ).paddingSymmetric(horizontal: 16, vertical: 12);
  }
  Widget _buildCustomerContactFields(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Phone Number',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: textPrimaryColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
          ),),
        8.height,
        PhoneInputField(
          controller: phoneController,
          codeController: codeController,
          focusNode: phoneFocusNode,
          nextFocus: emailFocusNode,
          maxLength: 10,
        ),
        16.height,
        const Text('Email Address',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: textPrimaryColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
          ),),
        8.height,
        StyledTextField(
          textFieldType: TextFieldType.NAME,
          hintText: 'Email Address',
          focusNode: emailFocusNode,
          nextFocus: locationFocusNode,
          controller: emailController,
        ),
        16.height,
        const Text('Location',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: textPrimaryColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
          ),),
        8.height,
        LocationPickerField(
          controller: locationController,
          focusNode: locationFocusNode,
          height: 50,
          onLocationSelected: (location) {
            setState(() {
              _selectedLocation = location;
            });
          },
        ),
      ],
    );
  }

  Widget _buildInputNameFields(){
    return Column(
      children: [
        if (selectedCustomerType != 'Company') Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'First Name',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: textPrimaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                8.height,
                StyledTextField(
                  textFieldType: TextFieldType.NAME,
                  hintText: 'First Name',
                  focusNode: firstNameFocusNode,
                  nextFocus: lastNameFocusNode,
                  controller: firstNameController,
                ),
              ],
            ),
          ),
          16.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Last Name',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: textPrimaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                8.height,
                StyledTextField(
                  textFieldType: TextFieldType.NAME,
                  hintText: 'Last Name',
                  focusNode: lastNameFocusNode,
                  nextFocus: phoneNumberFocusNode,
                  controller: lastNameController,
                ),
              ],
            ),
          ),
        ],) else Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Company Name',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: textPrimaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
              ),
            ),
            8.height,
            StyledTextField(
              textFieldType: TextFieldType.NAME,
              hintText: 'Company Name',
              focusNode: firstNameFocusNode,
              nextFocus: phoneFocusNode,
              controller: firstNameController,
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildCustomerTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customer Type',
          style: TextStyle(
            color: Color(0xff2f3036),
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: customerTypes.map((type) {
            final isSelected = selectedCustomerType == type;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedCustomerType = type;
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: type == customerTypes.first ? 8 : 0),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xfff2f4f5) : const Color(0xfffcfcfc),
                  border: Border.all(
                    color: isSelected ? const Color(0xff032541) : const Color(0xffc5c6cc),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  type,
                  style: TextStyle(
                    color: isSelected ? const Color(0xff032541) : const Color(0xff8f9098),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontFamily: 'Poppins',
                    fontStyle: FontStyle.normal,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

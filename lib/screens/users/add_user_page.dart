import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/models/get_business_roles/GetBusinessRolesResponse.dart';
import 'package:zed_nano/providers/business/BusinessProviders.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/screens/widget/common/location_picker_field.dart';
import 'package:zed_nano/screens/widget/common/sub_category_picker.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/extensions.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({Key? key}) : super(key: key);

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  String? _selectedLocation;
  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode locationFocusNode = FocusNode();
  FocusNode phoneNumberFocusNode = FocusNode();
  FocusNode userNameNameFocusNode = FocusNode();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  List<BusinessRole>? businessRole;

  String? selectedBusinessRole;


  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getBusinessRoles();
    });

    super.initState();
  }

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
    userNameNameFocusNode.dispose();
    userNameController.dispose();
    super.dispose();
  }

  Future<void> _addNewUser(Map<String, dynamic> requestData) async {
    await getBusinessProvider(context)
        .addNewUser(requestData: requestData, context: context)
        .then((value) {
      if (value.isSuccess) {
        showCustomToast(value.message ?? 'Customer created successfully',
            isError: false);
        Navigator.pop(context);
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }

  Future<void> getBusinessRoles() async {
    Map<String, dynamic> requestData = {};

    await getBusinessProvider(context)
        .getBusinessRoles(requestData: requestData, context: context)
        .then((value) {
      if (value.isSuccess) {
        setState(() {
          businessRole = value.data?.data;
        });
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AuthAppBar(title: 'Add Customers'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headings(
              label: 'New User',
              subLabel: 'Enter your user details.',
            ),
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

  Widget _buildSubmitButton() {
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
        text: 'Add User',
        onTap: () {
          var firstName = firstNameController.text;
          var lastName = lastNameController.text;
          var userName = userNameController.text;
          var email = emailController.text;
          var phone = phoneController.text;
          var location = locationController.text;

          if (!firstName.isValidInput) {
            return showCustomToast('Please enter first name');
          }
          if (!lastName.isValidInput) {
            return showCustomToast('Please enter last name');
          }

          if (!userName.isValidInput) {
            return showCustomToast('Please enter user name');
          }

          if (!email.isValidEmail) {
            return showCustomToast('Please enter valid email');
          }
          if (!phone.isValidPhoneNumber) {
            return showCustomToast('Please enter valid phone number');
          }

          var phoneNumber = phoneController.text;
          var countryCode = codeController.text;
          phone = "$countryCode$phoneNumber";

          var requestData = {
            'firstName': firstName,
            'secondName': lastName,
            'userEmail': email,
            'userPhone': phone,
            'userGroup': selectedBusinessRole,
            'userName': userName,
            'userState': 'Active',
          };

          if(!(selectedBusinessRole == 'Merchant')){
            requestData['branchId'] = getBusinessDetails(context)?.branchId;
          }

          logger.d(requestData);

          _addNewUser(requestData);
        },
        context: context,
      ),
    ).paddingSymmetric(horizontal: 16, vertical: 12);
  }

  Widget _buildCustomerContactFields() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text(
        'Phone Number',
        style: TextStyle(
          fontFamily: 'Poppins',
          color: textPrimaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal,
        ),
      ),
      8.height,
      PhoneInputField(
        controller: phoneController,
        codeController: codeController,
        focusNode: phoneFocusNode,
        nextFocus: emailFocusNode,
        maxLength: 10,
      ),
      16.height,
      const Text(
        'Email Address',
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
        hintText: 'Email Address',
        focusNode: emailFocusNode,
        nextFocus: locationFocusNode,
        controller: emailController,
      ),
      // 16.height,
      // const Text(
      //   'Location',
      //   style: TextStyle(
      //     fontFamily: 'Poppins',
      //     color: textPrimaryColor,
      //     fontSize: 12,
      //     fontWeight: FontWeight.w600,
      //     fontStyle: FontStyle.normal,
      //   ),
      // ),
      // 8.height,
      // LocationPickerField(
      //   controller: locationController,
      //   focusNode: locationFocusNode,
      //   label: 'Location',
      //   height: 50,
      //   onLocationSelected: (location) {
      //     setState(() {
      //       _selectedLocation = location;
      //     });
      //   },
      // ),
    ]);
  }

  Widget _buildInputNameFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
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
                    nextFocus: userNameNameFocusNode,
                    controller: lastNameController,
                  ),
                ],
              ),
            ),
          ],
        ),
        const Text(
          'User Name',
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
          hintText: 'User Name',
          focusNode: userNameNameFocusNode,
          nextFocus: phoneNumberFocusNode,
          controller: userNameController,
        ),
        8.height,
        const Text(
          'Select Role',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: textPrimaryColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
          ),
        ),
        8.height,
        SubCategoryPicker(
          label: 'Select Role',
          options: businessRole?.map((e) => e.name ?? '').toList() ?? [],
          selectedValue: selectedBusinessRole,
          onChanged: (value) {
            final selectedCat = value;
            setState(() {
              selectedBusinessRole = selectedCat;
            });
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/profile/ProfileResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/utils/extensions.dart';

class EditProfilePage extends StatefulWidget {

  const EditProfilePage({super.key, this.profileData});
  final ProfileData? profileData;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _firstNameController = TextEditingController(text: widget.profileData?.firstName ?? '');
    _lastNameController = TextEditingController(text: widget.profileData?.secondName ?? '');
    _usernameController = TextEditingController(text: widget.profileData?.userName ?? '');
    _emailController = TextEditingController(text: widget.profileData?.email ?? '');
    _phoneController = TextEditingController(text: widget.profileData?.phoneNumber ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: const AuthAppBar(
        title: 'Edit Profile',
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headings(
                label: 'Edit Profile',
                subLabel:
                'Edit your personal information.',
              ),
              _buildPersonalInfoSection(),
              _buildContactInfoSection(),
            ],
          ).paddingAll(16),
        ),
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
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Visibility(
                child: appButton(
                  text: _isLoading ? 'Saving...' : 'Save Changes',
                  onTap: _saveProfile,
                  context: context,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: appThemePrimary,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: rfCommonCachedNetworkImage(
                defaultAvatarIcon,
                fit: BoxFit.cover,
                height: 100,
                width: 100,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                // Handle image selection
                showCustomToast('Image selection coming soon');
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: appThemePrimary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorBackground,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 16,
                  color: colorBackground,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // _buildSectionHeader('Personal Information'),
        24.height,
        Row(
          children: [
            Expanded(
              child: _buildTextFormField(
                controller: _firstNameController,
                label: 'First Name',
                hint: 'Enter your first name',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'First name is required';
                  }
                  return null;
                },
              ),
            ),
            16.width,
            Expanded(
              child: _buildTextFormField(
                controller: _lastNameController,
                label: 'Last Name',
                hint: 'Enter your last name',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Last name is required';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),

        20.height,
        _buildTextFormField(
          controller: _usernameController,
          label: 'Username',
          hint: 'Enter your username',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Username is required';
            }
            if (value.length < 3) {
              return 'Username must be at least 3 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildContactInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextFormField(
          controller: _emailController,
          label: 'Email Address',
          hint: 'Enter your email address',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Email is required';
            }
            if (!value.isValidEmail) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
        20.height,
        _buildTextFormField(
          controller: _phoneController,
          label: 'Phone Number',
          hint: 'Enter your phone number',
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Phone number is required';
            }
            if (value.length < 10) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
        ),
      ],
    );
  }



  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: textPrimary,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        fontSize: 16,
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
            ),
        ),
        8.height,
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(
            color: textPrimary,
            fontFamily: 'Poppins',
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: textSecondary,
              fontFamily: 'Poppins',
              fontSize: 14,
            ),
            filled: true,
            fillColor: cardBackgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: appThemePrimary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: googleRed,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: googleRed,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: appButton(
        text: _isLoading ? 'Saving...' : 'Save Changes',
        onTap: _saveProfile,
        context: context,
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {

      //get current timestamp
      final now = DateTime.now();
      final timestamp = now.toIso8601String();

      final requestData = {
        'firstname': _firstNameController.text.trim(),
        'secondname': _lastNameController.text.trim(),
        'userName': _usernameController.text.trim(),
        'userEmail': _emailController.text.trim(),
        'userPhone': _phoneController.text.trim(),
        'id': getAuthProvider(context).loginResponse?.userId,
        'modifiedAtBy': getAuthProvider(context).loginResponse?.username,
        'modifiedAt': timestamp,
      };

      final response = await getBusinessProvider(context).updateUserProfile(
        requestData: requestData,
        context: context,
      );

      if (response.isSuccess) {
        showCustomToast('Profile updated successfully', isError: false);
        Navigator.of(context).pop(true); // Return true to indicate success
      } else {
        showCustomToast(response.message ?? 'Failed to update profile');
      }
    } catch (e) {
      showCustomToast('Failed to update profile');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

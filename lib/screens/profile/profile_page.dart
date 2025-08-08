import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/profile/ProfileResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/profile/delete_user_account_page.dart';
import 'package:zed_nano/screens/profile/edit_profile_page.dart';
import 'package:zed_nano/screens/profile/reset_pin_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_dialog.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Images.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileData? profileData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final response = await getBusinessProvider(context).getUserProfile(context: context);
      
      if (response.isSuccess && response.data != null) {
        setState(() {
          profileData = response.data!.data;
          isLoading = false;
        });
      } else {
        // Fallback to mock data if API fails
        _loadMockData();
      }
    } catch (e) {
      // Fallback to mock data if API fails
      _loadMockData();
    }
  }

  void _loadMockData() {
    // Mock data for demonstration
    setState(() {
      profileData = ProfileData(
        firstName: 'Mary',
        secondName: 'Koech',
        userName: 'marykoech',
        email: 'mary.koech@example.com',
        phoneNumber: '+254712345678',
      );
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AuthAppBar(
        title: 'Profile',
        actions: [
          TextButton(
            onPressed: _navigateToEditProfile,
            child: const Text(
              'Edit',
              style: TextStyle(
                color: appThemePrimary,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
        ? const Center(child: SizedBox())
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(),
                24.height,
                _buildProfileDetails(),
                40.height,
                _buildContactDetails(),
                40.height,
                _buildSecuritySection(),
              ],
            ).paddingAll(16),
          ),
    );
  }

  Future<void> _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(profileData: profileData),
      ),
    );
    
    // If profile was updated, reload the data
    if (result == true) {
      _loadProfileData();
    }
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profileData?.fullName ?? 'N/A',
                style: const TextStyle(
                  color: textPrimary,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontSize: 28,
                ),
              ),
              8.height,
              Text(
                profileData?.displayUserName ?? '@username',
                style: const TextStyle(
                  color: textSecondary,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        _buildProfileAvatar(),
      ],
    );
  }

  Widget _buildProfileAvatar() {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: colorWhite,
              width: 1.5,
            ),
          ),
          child: ClipOval(
            child: rfCommonCachedNetworkImage(
              defaultAvatarIcon,
              fit: BoxFit.cover,
              height: 80,
              width: 80,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: appThemePrimary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.edit,
              size: 12,
              color: colorWhite,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Profile Details'),
        24.height,
        _buildInfoItem('First Name', profileData?.firstName ?? 'N/A'),
        32.height,
        _buildInfoItem('Last Name', profileData?.secondName ?? 'N/A'),
        32.height,
        _buildInfoItem('Username', profileData?.userName ?? 'N/A'),
      ],
    );
  }

  Widget _buildContactDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Contact Details'),
        24.height,
        _buildInfoItem('Email Address', profileData?.email ?? 'N/A'),
        32.height,
        _buildInfoItem('Phone Number', profileData?.phoneNumber ?? 'N/A'),
      ],
    );
  }

  Widget _buildSecuritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Security & Account'),
        24.height,
        _buildActionCard(
          icon: resetPinIcon,
          iconColor: primaryOrangeTextColor,
          title: 'Reset PIN',
          subtitle: 'Change your security PIN for enhanced security.',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ResetPinPage()),
            );
          },
        ),
        16.height,
        _buildActionCard(
          icon: deleteAccount,
          iconColor: googleRed,
          title: 'Delete Account',
          subtitle: 'Permanently delete your account and all associated data.',
          onTap: _confirmDeleteUserAccount,
        ),
      ],
    );
  }

  void _confirmDeleteUserAccount() {
    showCustomDialog(
      context: context,
      title: 'Delete Account',
      subtitle: 'By deleting your account, you will lose your personal and business data. This action cannot be undone.',
      positiveButtonText: 'Delete',
      negativeButtonText: 'Cancel',
      positiveButtonColor: googleRed,
      onPositivePressed: () async {
        Navigator.pop(context);
        await const DeleteUserAccountPage().launch(context);
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: textPrimary,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        fontSize: 14,
      ),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Container(
      width: context.width(),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: textSecondary,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              fontSize: 14,
            ),
          ),
          8.height,
          Text(
            value,
            style: const TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: iconColor == googleRed ? googleRed.withOpacity(0.2) : primaryOrangeTextColor.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: rfCommonCachedNetworkImage(
                icon,
                color: iconColor,
                width: 15,
                height: 15,
                radius: 0,
              ),
            ),
            16.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: textPrimary,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                  ),
                  4.height,
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: textSecondary,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Delete Account',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: textPrimary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Are you sure you want to permanently delete your account?',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: textSecondary,
                ),
              ),
              16.height,
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: googleRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: googleRed.withOpacity(0.3),
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'This action will:',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: googleRed,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Delete all your personal data\n• Remove all transaction history\n• Cancel all active subscriptions\n• This action cannot be undone',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 11,
                        color: googleRed,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _confirmDeleteAccount();
              },
              child: const Text(
                'Delete Account',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: googleRed,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final confirmController = TextEditingController();
        
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Final Confirmation',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: googleRed,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Type "DELETE" to confirm account deletion:',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: textSecondary,
                ),
              ),
              16.height,
              TextFormField(
                controller: confirmController,
                style: const TextStyle(
                  color: textPrimary,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Type DELETE',
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
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (confirmController.text.toUpperCase() == 'DELETE') {
                  Navigator.of(context).pop();
                  _deleteAccount();
                } else {
                  showCustomToast('Please type DELETE to confirm');
                }
              },
              child: const Text(
                'Delete Forever',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: googleRed,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    try {
      final requestData = {
        'confirmation': 'DELETE',
        'reason': 'User requested account deletion',
      };

      final response = await getBusinessProvider(context).deleteUserAccount(
        requestData: requestData,
        context: context,
      );

      if (response.isSuccess) {
        showCustomToast('Account deletion requested successfully', isError: false);
        // Navigate to login or exit app
      } else {
        showCustomToast(response.message ?? 'Failed to delete account');
      }
    } catch (e) {
      showCustomToast('Failed to delete account');
    }
  }
}

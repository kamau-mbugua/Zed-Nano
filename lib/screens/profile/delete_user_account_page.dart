import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart' show Provider;
import 'package:zed_nano/providers/auth/authenticated_app_providers.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';

class DeleteUserAccountPage extends StatefulWidget {
  const DeleteUserAccountPage({Key? key}) : super(key: key);

  @override
  _DeleteUserAccountPageState createState() => _DeleteUserAccountPageState();
}

class _DeleteUserAccountPageState extends State<DeleteUserAccountPage> {

  final List<String> _listReasons = [
    'Poor Customer Service.',
    'App is slow.',
    'Complex checkout process.',
    'Unclear navigation.',
    'App is not responsive.',
    'Products offered are not what i was looking for.',
    'Privacy concern.',
    'Other.',
  ];

  String? _selectedReason;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(title: 'Delete Account'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headings(
            label: 'Delete Account',
            subLabel:
                'We’re sorry to see you go! Your feedback will help us understand what went wrong and improve our service for everyone.',
          ),
          _buildReason(),
        ],
      ).paddingSymmetric(horizontal: 16),
      bottomNavigationBar: _buildSubmitButton(),
    );
  }

  Widget _buildReason() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Duration',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        ..._listReasons.map((option) => _buildDurationOption(option)),
        if (_listReasons == 'Other') ...[
          const SizedBox(height: 24),
        ],
      ],
    );
  }


  Widget _buildDurationOption(String option) {
    final isSelected = _selectedReason == option;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedReason = option;
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: isSelected ? lightGreyColor : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:  Colors.grey.shade300,
              width:  1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                option,
                style: TextStyle(
                  color: isSelected ? appThemePrimary : textPrimary,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? appThemePrimary : Colors.grey.shade400,
                    width: 2,
                  ),
                  color: isSelected ? appThemePrimary : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(
                  Icons.circle,
                  size: 10,
                  color: Colors.white,
                )
                    : null,
              ),
            ],
          ),
        ),
      ),
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
                  text: 'Delete Account',
                  onTap: () async {
                    Map<String, dynamic> requestData = {
                      'reasons': _selectedReason,
                    };
                    final response = await getBusinessProvider(context).deleteUserAccount(
                      requestData: requestData,
                      context: context,
                    );

                    if (response.isSuccess) {
                      showCustomToast(response.message, isError: false);
                      await Provider.of<AuthenticatedAppProviders>(context, listen: false)
                          .logout(context);
                      await Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.getSplashPageRoute(),
                            (route) => false,
                      );
                    } else {
                      showCustomToast(response.message ?? 'Failed to reset PIN');
                    }
                  },
                  context: context,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

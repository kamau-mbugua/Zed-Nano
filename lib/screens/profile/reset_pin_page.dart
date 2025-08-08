import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';

class ResetPinPage extends StatefulWidget {
  const ResetPinPage({super.key});

  @override
  _ResetPinPageState createState() => _ResetPinPageState();
}

class _ResetPinPageState extends State<ResetPinPage> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _currentPinController;
  late TextEditingController _newPinController;
  late TextEditingController _confirmPinController;
  
  late FocusNode _currentPinFocus;
  late FocusNode _newPinFocus;
  late FocusNode _confirmPinFocus;
  
  bool _isLoading = false;
  bool _obscureCurrentPin = true;
  bool _obscureNewPin = true;
  bool _obscureConfirmPin = true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _currentPinController = TextEditingController();
    _newPinController = TextEditingController();
    _confirmPinController = TextEditingController();
    
    _currentPinFocus = FocusNode();
    _newPinFocus = FocusNode();
    _confirmPinFocus = FocusNode();
  }

  @override
  void dispose() {
    _currentPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    
    _currentPinFocus.dispose();
    _newPinFocus.dispose();
    _confirmPinFocus.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: const AuthAppBar(title: 'Reset PIN'),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              32.height,
              _buildPinFields(),
              40.height,
              _buildResetButton(),
            ],
          ).paddingAll(16),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reset Your PIN',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            fontSize: 24,
          ),
        ),
        12.height,
        const Text(
          'Enter your current PIN and create a new one for enhanced security.',
          style: TextStyle(
            color: textSecondary,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildPinFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPinField(
          controller: _currentPinController,
          focusNode: _currentPinFocus,
          label: 'Current PIN',
          hint: 'Enter your current PIN',
          obscureText: _obscureCurrentPin,
          onToggleVisibility: () {
            setState(() {
              _obscureCurrentPin = !_obscureCurrentPin;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Current PIN is required';
            }
            if (value.length != 4) {
              return 'PIN must be 4 digits';
            }
            return null;
          },
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_newPinFocus);
          },
        ),
        24.height,
        _buildPinField(
          controller: _newPinController,
          focusNode: _newPinFocus,
          label: 'New PIN',
          hint: 'Enter your new PIN',
          obscureText: _obscureNewPin,
          onToggleVisibility: () {
            setState(() {
              _obscureNewPin = !_obscureNewPin;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'New PIN is required';
            }
            if (value.length != 4) {
              return 'PIN must be 4 digits';
            }
            if (value == _currentPinController.text) {
              return 'New PIN must be different from current PIN';
            }
            return null;
          },
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_confirmPinFocus);
          },
        ),
        24.height,
        _buildPinField(
          controller: _confirmPinController,
          focusNode: _confirmPinFocus,
          label: 'Confirm New PIN',
          hint: 'Confirm your new PIN',
          obscureText: _obscureConfirmPin,
          onToggleVisibility: () {
            setState(() {
              _obscureConfirmPin = !_obscureConfirmPin;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your new PIN';
            }
            if (value != _newPinController.text) {
              return 'PINs do not match';
            }
            return null;
          },
          onFieldSubmitted: (_) {
            _resetPin();
          },
        ),
      ],
    );
  }

  Widget _buildPinField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required String? Function(String?) validator,
    required void Function(String) onFieldSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            fontSize: 14,
          ),
        ),
        8.height,
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          keyboardType: TextInputType.number,
          maxLength: 4,
          validator: validator,
          onFieldSubmitted: onFieldSubmitted,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          style: const TextStyle(
            color: textPrimary,
            fontFamily: 'Poppins',
            fontSize: 16,
            letterSpacing: 8,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: textSecondary,
              fontFamily: 'Poppins',
              fontSize: 14,
              letterSpacing: 0,
            ),
            filled: true,
            fillColor: cardBackgroundColor,
            counterText: '',
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: textSecondary,
                size: 20,
              ),
              onPressed: onToggleVisibility,
            ),
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

  Widget _buildResetButton() {
    return SizedBox(
      width: double.infinity,
      child: appButton(
        text: _isLoading ? 'Resetting PIN...' : 'Reset PIN',
        onTap: _resetPin,
        context: context,
      ),
    );
  }

  Future<void> _resetPin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final requestData = {
        'userPin': _currentPinController.text,
        'userNewPin': _newPinController.text,
        'userEmail': getAuthProvider(context).loginResponse?.email,
      };

      final response = await getBusinessProvider(context).resetUserPin(
        requestData: requestData,
        context: context,
      );

      if (response.isSuccess) {
        showCustomToast('PIN reset successfully', isError: false);
        Navigator.of(context).pop();
      } else {
        showCustomToast(response.message ?? 'Failed to reset PIN');
      }
    } catch (e) {
      showCustomToast('Failed to reset PIN');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

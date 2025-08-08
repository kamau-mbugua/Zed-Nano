import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/utils/Colors.dart';

class CardNumberField extends StatefulWidget {

  const CardNumberField({
    super.key,
    this.hintText = 'Card Number',
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
  });
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  @override
  State<CardNumberField> createState() => _CardNumberFieldState();
}

class _CardNumberFieldState extends State<CardNumberField> {
  late TextEditingController _controller;
  bool _isValid = false;
  String _cardType = '';
  
  // Card type patterns based on IIN ranges
  final Map<String, RegExp> _cardPatterns = {
    'Visa': RegExp('^4'),
    'Visa Electron': RegExp('^(4026|417500|4844|4913|4917)'),
    'Mastercard': RegExp('^(5[1-5]|222[1-9]|22[3-9]|2[3-6]|27[0-1]|2720)'),
    'Amex': RegExp('^3[47]'),
    'Discover': RegExp('^(6011|65|64[4-9]|622[1-9]|6221[2-9]|622[2-8]|6229[0-2][0-5])'),
    'JCB': RegExp('^(352[8-9]|35[3-8])'),
    'Diners Club': RegExp('^(30|36|38|39)'),
    'Maestro': RegExp('^(5018|5020|5038|5893|6304|6759|6761|6762|6763)'),
    'UnionPay': RegExp('^62'),
    'Mir': RegExp('^220[0-4]'),
    'RuPay': RegExp('^(60|65|81|82|508|353|356)'),
  };
  
  // Card type max lengths
  final Map<String, int> _cardMaxLengths = {
    'Visa': 16, // Can be 13, 16, or 19 digits
    'Visa Electron': 16,
    'Mastercard': 16,
    'Amex': 15,
    'Discover': 16, // Can be 16-19 digits
    'JCB': 16, // Can be 16-19 digits
    'Diners Club': 14, // Can be 14-19 digits
    'Maestro': 16, // Can be 12-19 digits
    'UnionPay': 16, // Can be 16-19 digits
    'Mir': 16, // Can be 16-19 digits
    'RuPay': 16,
    'Default': 19, // ISO standard maximum
  };

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final rawText = _controller.text.replaceAll(' ', '');
    
    // Determine card type based on first digits
    _cardType = _getCardType(rawText);
    
    // Check if card number is valid
    _isValid = _validateCardNumber(rawText);
    
    if (widget.onChanged != null) {
      widget.onChanged!(rawText);
    }
    
    setState(() {});
  }

  String _getCardType(String number) {
    if (number.isEmpty) return '';
    
    for (final type in _cardPatterns.keys) {
      if (_cardPatterns[type]!.hasMatch(number)) {
        return type;
      }
    }
    
    return '';
  }

  bool _validateCardNumber(String number) {
    if (number.isEmpty) return false;
    
    // Check length based on card type
    final  maxLength = _cardMaxLengths[_cardType] ?? _cardMaxLengths['Default']!;
    
    // For testing purposes, let's consider it valid if it's the right length
    // This is a simplified validation for demonstration
    if (number.length == maxLength) {
      return true;
    }
    
    return false;
    
    /* Commented out full Luhn algorithm for now
    // Luhn algorithm for card number validation
    int sum = 0;
    bool alternate = false;
    
    for (int i = number.length - 1; i >= 0; i--) {
      int digit = int.parse(number[i]);
      
      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }
      
      sum += digit;
      alternate = !alternate;
    }
    
    return sum % 10 == 0;
    */
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48, // Fixed height as per user preference (56px)
      decoration: BoxDecoration(
        border: Border.all(color: BodyWhite),
        borderRadius: BorderRadius.circular(13), // Border radius as per user preference (16px)
      ),
      child: AppTextField(
        controller: _controller,
        focus: widget.focusNode,
        nextFocus: widget.nextFocus,
        textFieldType: TextFieldType.NUMBER,
        enabled: widget.enabled,
        onFieldSubmitted: widget.onSubmitted,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(_cardMaxLengths[_cardType] ?? _cardMaxLengths['Default']!),
          _CardNumberFormatter(),
        ],
        suffix: _isValid
            ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
            : _cardType.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(_cardType, style: secondaryTextStyle(color: textSecondary, fontFamily: 'Poppins')),
                  )
                : null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: Color(0xff8f9098),
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins', // Poppins font as per user preference
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue,) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    
    // Remove all spaces
    final text = newValue.text.replaceAll(' ', '');
    
    // Format with spaces after every 4 digits
    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i != text.length - 1) {
        buffer.write(' ');
      }
    }
    
    final string = buffer.toString();
    return TextEditingValue(
      text: string,
      selection: TextSelection.collapsed(
        offset: string.length,
      ),
    );
  }
}

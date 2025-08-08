import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/screens/common/common_webview_page.dart';
import 'package:zed_nano/utils/Colors.dart';

/// A reusable terms and conditions checkbox with rich text links
class TermsCheckbox extends StatefulWidget {

  const TermsCheckbox({
    required this.onChanged, super.key,
    this.initialValue = false,
    this.activeColor,
    this.textColor,
    this.linkColor,
    this.onClick,
  });
  final bool initialValue;
  final Function(bool) onChanged;
  final VoidCallback? onClick;
  final Color? activeColor;
  final Color? textColor;
  final Color? linkColor;

  @override
  State<TermsCheckbox> createState() => _TermsCheckboxState();
}

class _TermsCheckboxState extends State<TermsCheckbox> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.textColor ?? const Color(0xff71727a);
    final linkColor = widget.linkColor ?? const Color(0xff032541);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: isChecked,
              activeColor: widget.activeColor ??appThemePrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              onChanged: (value) {
                setState(() {
                  isChecked = value ?? false;
                });
                widget.onChanged(isChecked);
              },
            ),
          ),
          12.width,
          Expanded(
            child: GestureDetector(
              onTap: (){

              },
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: textColor,
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    const TextSpan(
                      text: 'By creating an account, you agree to our ',
                    ),
                    TextSpan(
                      text: 'Terms and Conditions',
                      style: TextStyle(
                        color: linkColor,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          const CommonWebViewPage(
                            url: 'https://zed.business/Terms%20&%20Conditions.html',
                          ).launch(context);                        },
                    ),
                    const TextSpan(
                      text: ' and ',
                    ),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: linkColor,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          const CommonWebViewPage(
                            url: 'https://zed.business/Terms%20&%20Conditions.html',
                          ).launch(context);                        },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/screens/common/common_webview_page.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/utils/Colors.dart';

/// A reusable terms and conditions checkbox with rich text links
class TermsCheckbox extends StatefulWidget {
  final bool initialValue;
  final Function(bool) onChanged;
  final VoidCallback? onClick;
  final Color? activeColor;
  final Color? textColor;
  final Color? linkColor;

  const TermsCheckbox({
    Key? key,
    this.initialValue = false,
    required this.onChanged,
    this.activeColor,
    this.textColor,
    this.linkColor,
    this.onClick,
  }) : super(key: key);

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
    final textColor = widget.textColor ?? Color(0xff71727a);
    final linkColor = widget.linkColor ?? Color(0xff032541);
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
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
                    fontFamily: "Poppins",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
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
                            showAppBar: true,
                          ).launch(context);                        },
                    ),
                    TextSpan(
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
                            showAppBar: true,
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

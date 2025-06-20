import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/screens/widget/common/highlighted_rich_text.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.52; // 3/4 of the screen height

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section - takes 3/4 of screen height
                commonCachedNetworkImage(
                  onboardingImage,
                  width: context.width(),
                  height: imageHeight,
                  fit: BoxFit.cover,
                  usePlaceholderIfUrlEmpty: true,
                  radius: 0,
                ),
                
                // Content section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rich text heading
                      HighlightedRichText.connectingBusinesses(),
                      16.height,
                      
                      // Subtitle
                      const Text(
                        'Enjoy a set of business tools for your business enabling you manage inventory, accept payments and sell products via POS.',
                        style: TextStyle(
                          color: Color(0xff71727a),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      
                      32.height, // Add more space between text and buttons
                      
                      // Buttons section
                      outlineButton(
                        context: context,
                        text: 'Sign In',
                        onTap: () async {},
                      ),
                      18.height,
                      appButton(
                        context: context,
                        text: 'Get Started',
                        onTap: () async {},
                      ),
                      16.height, // Bottom padding
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

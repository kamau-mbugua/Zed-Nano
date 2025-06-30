import 'package:flutter/material.dart';
import 'package:zed_nano/screens/widget/common/fading_circular_progress.dart';

class ActivatingTrialScreen extends StatelessWidget {
  const ActivatingTrialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Circular Loader with gradient
                  const FadingCircularProgress(
                    width: 140,
                    height: 140,
                    color: Color(0xff032541),
                    backgroundColor: Color(0xffe8edf1),
                    strokeWidth: 10,
                    duration: Duration(seconds: 2),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Activating your\nfree trial",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                      color: Color(0xff1f2024),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 48.0),
                    child: Text(
                      "Please wait while we activate\nand setup your business.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                        color: Color(0xff71727a),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

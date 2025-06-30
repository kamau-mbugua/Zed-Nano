import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/Images.dart';

class BusinessCreatedPreviewPage extends StatefulWidget {
  final VoidCallback onNext;
  const BusinessCreatedPreviewPage({Key? key, required this.onNext}) : super(key: key);

  @override
  State<BusinessCreatedPreviewPage> createState() => _BusinessCreatedPreviewPageState();
}

class _BusinessCreatedPreviewPageState extends State<BusinessCreatedPreviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Create Your Business',
          style: TextStyle(
            color: Color(0xff1f2024),
            fontWeight: FontWeight.w500,
            fontFamily: "Poppins",
            fontSize: 16.0,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Header section
            Positioned(
              top: 16,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Business Summary",
                    style: TextStyle(
                      color: Color(0xff1f2024),
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                      fontSize: 28.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "A summary of your business information",
                    style: TextStyle(
                      color: Color(0xff71727a),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins",
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),

            // Logo section
            Positioned(
              top: 88,
              left: 16,
              child: Container(
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Stack(
                children: [
                  Center(
                    child : SvgPicture.asset(zedColoredIcon, fit: BoxFit.cover),
                  ),
                ],
              ),
            ),
            ),

            // Form section
            Positioned(
              top: 185,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Business Name
                  _buildInfoItem("Business Name", "Mama Koech Shop"),
                  _buildDivider(),

                  // Phone Number
                  _buildInfoItem("Phone Number", "+254 712 345 678"),
                  _buildDivider(),

                  // Email Address
                  _buildInfoItem("Email Address", "mamakoechshop@mail.com"),
                  _buildDivider(),

                  // Location
                  _buildInfoItem("Location", "Ukunda Road, Business Mall"),
                  _buildDivider(),

                  // Directors/Owners
                  _buildInfoItem("Directors/Owners", "Mary Kamau, John Kipkoech"),
                  _buildDivider(),

                  // Country and Currency (2-column layout)
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem("Country", "Kenya"),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoItem("Currency", "KES"),
                      ),
                    ],
                  ),
                  _buildDivider(),
                ],
              ),
            ),

            // Bottom buttons
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                children: [
                  outlineButton(
                      text: "Edit",
                      onTap: () {

                      },
                      context: context
                  ).paddingSymmetric(horizontal: 12),
                  10.height,
                  appButton(
                      text: "Next",
                      onTap: () {
                        widget.onNext();

                      },
                      context: context
                  ).paddingSymmetric(horizontal: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xff1f2024),
              fontWeight: FontWeight.w400,
              fontFamily: "Poppins",
              fontSize: 14.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              color: Color(0xff71727a),
              fontWeight: FontWeight.w400,
              fontFamily: "Poppins",
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: double.infinity,
      height: 0.5,
      decoration: BoxDecoration(
        color: const Color(0xffd4d6dd),
      ),
    );
  }
}

// Usage:
// Add this to your main.dart or route navigation:
// Navigator.push(
//   context,
//   MaterialPageRoute(builder: (context) => BusinessSummaryScreen()),
// );

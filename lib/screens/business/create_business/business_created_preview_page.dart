import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/contants/AppConstants.dart';
import 'package:zed_nano/models/get_business_info/BusinessInfoResponse.dart';
import 'package:zed_nano/providers/business/BusinessProviders.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
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

  BusinessInfoData? businessInfoData;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getBusinessInformation();
    });
    super.initState();
  }

  Future<void> getBusinessInformation() async {

    var businessId = getAuthProvider(context).businessDetails?.businessId;

    Map<String, dynamic> businessData = {
      'businessId':businessId
    };
    await context
        .read<BusinessProviders>()
        .getBusinessInfo(requestData:businessData,context: context)
        .then((value) async {
      if (value.isSuccess) {
        var businessInfo = value.data?.data;
        setState(() {
          businessInfoData = businessInfo;
        });

      } else {
        showCustomToast(
            value.message ?? 'Something went wrong');
      }
    });
  }

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
            fontFamily: 'Poppins',
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
                    'Business Summary',
                    style: TextStyle(
                      color: Color(0xff1f2024),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      fontSize: 28.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'A summary of your business information',
                    style: TextStyle(
                      color: Color(0xff71727a),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
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
              child: rfCommonCachedNetworkImage(
                '${AppConstants.baseUrl}staticimages/logos/${businessInfoData?.businessLogo}',
                fit: BoxFit.fitHeight,
                height: 90,
                width: 150,
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
                  _buildInfoItem('Business Name', businessInfoData?.businessName ?? ''),
                  _buildDivider(),

                  // Phone Number
                  _buildInfoItem('Phone Number', businessInfoData?.businessOwnerPhone ?? ''),
                  _buildDivider(),

                  // Email Address
                  _buildInfoItem('Email Address', businessInfoData?.businessOwnerEmail ?? ''),
                  _buildDivider(),

                  // Location
                  _buildInfoItem('Location', businessInfoData?.businessOwnerAddress ?? ''),
                  _buildDivider(),

                  // Directors/Owners
                  _buildInfoItem('Directors/Owners', businessInfoData?.businessOwnerName ?? ''),
                  _buildDivider(),

                  // Country and Currency (2-column layout)
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem('Country', businessInfoData?.country ?? ''),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoItem('Currency', businessInfoData?.localCurrency ?? ''),
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
                      text: 'Edit',
                      onTap: () {

                      },
                      context: context
                  ).paddingSymmetric(horizontal: 12),
                  10.height,
                  appButton(
                      text: 'Next',
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
              fontFamily: 'Poppins',
              fontSize: 14.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              color: Color(0xff71727a),
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
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

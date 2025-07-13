import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zed_nano/contants/AppConstants.dart';
import 'package:zed_nano/models/get_business_info/BusinessInfoResponse.dart';
import 'package:zed_nano/models/listsubscribed_billing_plans/SubscribedBillingPlansResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/business/get_started_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/extensions.dart';
import 'package:zed_nano/viewmodels/WorkflowViewModel.dart';

class BusinessProfilePage extends StatefulWidget {
  final BusinessInfoData businessData;

  const BusinessProfilePage({
    Key? key,
    required this.businessData,
  }) : super(key: key);

  @override
  State<BusinessProfilePage> createState() => _BusinessProfilePageState();
}

class _BusinessProfilePageState extends State<BusinessProfilePage> {

  SubscribedBillingPlansResponse? subscribedBillingPlansResponse;


  @override
  void initState() {
    subscribedBillingPlansResponse = getWorkflowViewModel(context).billingPlan;

    if (subscribedBillingPlansResponse == null) {
      getWorkflowViewModel(context).skipSetup(context).then((value) {
        setState(() {
          subscribedBillingPlansResponse = getWorkflowViewModel(context).billingPlan;
        });
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AuthAppBar(
        title:'Business Profile',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // Business Header Section
              _buildBusinessHeader(),

              const Divider(height: 32, thickness: 0.5),

              // Subscription Section
              _buildSubscriptionSection(),

              const Divider(height: 32, thickness: 0.5),

              // Business Details Section
              _buildBusinessDetailsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Business Name and Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.businessData.businessName ?? '',
                style: const TextStyle(
                  color: textPrimary,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontSize: 28.0,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    widget.businessData.businessCategory ?? '',
                    style: const TextStyle(
                      color: textSecondary,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      fontSize: 12.0,
                    ),
                  ),
                  const Text(
                    ' . ',
                    style: TextStyle(
                      color: textSecondary,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    widget.businessData.country ?? '',
                    style: const TextStyle(
                      color: textSecondary,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                widget.businessData.createdAt != null
                    ? 'Created ${widget.businessData.createdAt!.toFormattedDate()}'
                    : 'Creation date unavailable',
                style: const TextStyle(
                  color: textSecondary,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),

        // Business Logo
        Container(
          width: 104,
          height: 104,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: lightGreyColor, // highlightMainLightest
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: rfCommonCachedNetworkImage(
                '${AppConstants.baseUrl}staticimages/logos/${widget.businessData?.businessLogo}',
                fit: BoxFit.fill,
              )
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Subscription Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
              child: Text(
                'Subscription',
                style: TextStyle(
                  color: textPrimary,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontSize: 14.0,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                const GetStartedPage(initialStep:2, isExistingPlan:true).launch(context);
              },
              child: Text(
                'Change/Cancel',
                style: TextStyle(
                  color: accentRed, // highlightHighlightDarkest
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontSize: 12.0,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Subscription Details
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                '${subscribedBillingPlansResponse?.data?[0]?.billingPeriodName ?? ''} Subscription',
                  style: const TextStyle(
                    color: darkGreyColor, // neutralDarkDarkest
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${widget.businessData.localCurrency ?? 'KES'} ${subscribedBillingPlansResponse?.data?[0]?.totalBillingPlanAmount?.formatCurrency() ?? '0'}',
                      style: const TextStyle(
                        color: textSecondary, // neutralDarkLight
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        fontSize: 12.0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Due: ${subscribedBillingPlansResponse?.data?[0]?.dateSubscribed?.toFormattedDate()}',
                      style: const TextStyle(
                        color: textSecondary, // neutralDarkLight
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              subscribedBillingPlansResponse?.isActiveBillingPackage == true
                  ? 'Active'
                  : 'Inactive',
              style: TextStyle(
                color: subscribedBillingPlansResponse?.isActiveBillingPackage == true
                    ? success
                    : Colors.orange[700],
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
                fontSize: 18.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildBusinessDetailsSection() {
    // Business details items with dynamic data
    final List<Map<String, String>> details = [
      {'title': 'Business Name', 'value': widget.businessData.businessName ?? 'N/A', 'color': 'dark'},
      {'title': 'Phone Number', 'value': widget.businessData.businessOwnerPhone ?? 'N/A', 'color': 'medium'},
      {'title': 'Email Address', 'value': widget.businessData.businessOwnerEmail ?? 'N/A', 'color': 'medium'},
      {'title': 'Location', 'value': widget.businessData.businessOwnerAddress ?? 'N/A', 'color': 'dark'},
      {'title': 'Directors/Owners', 'value': widget.businessData.businessOwnerName ?? 'N/A', 'color': 'medium'},
      {'title': 'Currency', 'value': widget.businessData.localCurrency ?? 'KES', 'color': 'medium'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Business Details Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Text(
                'Business Details',
                style: TextStyle(
                  color: textPrimary,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontSize: 14.0,
                ),
              ),
            ),
            Text(
              'Edit',
              style: TextStyle(
                color: accentRed, // highlightHighlightDarkest
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                fontSize: 12.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // List of business details
        ...details.map((item) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['title']!,
                style: const TextStyle(
                  color: Colors.black45, // neutralDarkLightest
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  fontSize: 14.0,
                ),
              ),
              Flexible(
                child: Text(
                  item['value']!,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: darkGreyColor, // neutralDarkMedium
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    fontSize: 14.0,
                  ),
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }
}

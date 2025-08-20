import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/contants/AppConstants.dart';
import 'package:zed_nano/models/get_business_info/BusinessInfoResponse.dart';
import 'package:zed_nano/models/get_token_after_invite/GetTokenAfterInviteResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/business/get_started_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/extensions.dart';

class BusinessProfilePage extends StatefulWidget {
  const BusinessProfilePage({
    required this.businessData,
    super.key,
    this.onRefreshRequest,
  });

  final BusinessInfoData businessData;
  final Future<void> Function()? onRefreshRequest;

  @override
  State<BusinessProfilePage> createState() => _BusinessProfilePageState();
}

class _BusinessProfilePageState extends State<BusinessProfilePage> {
  NanoSubscription? subscribedBillingPlansResponse;

  @override
  void initState() {
    super.initState();

    // Fetch billing plan information after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSubscriptionData();
    });
  }

  Future<void> _loadSubscriptionData() async {
    final billingPlan = getWorkflowViewModel(context).billingPlan;

    if (mounted) {
      setState(() {
        subscribedBillingPlansResponse = billingPlan;
      });

      if (subscribedBillingPlansResponse == null) {
        await getWorkflowViewModel(context).skipSetup(context);

        if (mounted) {
          setState(() {
            subscribedBillingPlansResponse =
                getWorkflowViewModel(context).billingPlan;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AuthAppBar(
        title: 'Business Profile',
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (widget.onRefreshRequest != null) {
            await widget.onRefreshRequest!();
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // <--- important!
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBusinessHeader(),
              const Divider(height: 32, thickness: 0.5),
              if (subscribedBillingPlansResponse != null)
                _buildSubscriptionSection()
              else
                const SizedBox(height: 32),
              const Divider(height: 32, thickness: 0.5),
              _buildBusinessDetailsSection(),
              const SizedBox(height: 32), // for scrollable area
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
                  fontSize: 28,
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
                      fontSize: 12,
                    ),
                  ),
                  const Text(
                    ' . ',
                    style: TextStyle(
                      color: textSecondary,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    widget.businessData.country ?? '',
                    style: const TextStyle(
                      color: textSecondary,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      fontSize: 12,
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
                  fontSize: 12,
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
              padding: const EdgeInsets.all(8),
              child: rfCommonCachedNetworkImage(
                widget.businessData.businessLogo != null && widget.businessData.businessLogo!.isValidUrl ? '${widget.businessData.businessLogo}' : null,
                fit: BoxFit.fill,
                height: 80,
                width: 80,
                radius: 8,
              )),
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
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Subscription',
                style: TextStyle(
                  color: textPrimary,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                const GetStartedPage(initialStep: 2, isExistingPlan: true)
                    .launch(context);
              },
              child: const Text(
                'Change/Post Pay',
                style: TextStyle(
                  color: accentRed, // highlightHighlightDarkest
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if ((widget.businessData.businessBillingDetails?.nanoSubscription
                    ?.freeTrialStatus ==
                'Active') ==
            true)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Free Trial Subscription',
                    style: TextStyle(
                      color: darkGreyColor, // neutralDarkDarkest
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Due in:  ${widget.businessData.businessBillingDetails?.nanoSubscription?.freeTrialPeriodRemainingdays}',
                    style: const TextStyle(
                      color: textSecondary, // neutralDarkLight
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Text(
                widget.businessData.businessBillingDetails?.nanoSubscription
                            ?.isActiveBillingPackage ==
                        true
                    ? 'Active'
                    : 'Inactive',
                style: TextStyle(
                  color: widget.businessData.businessBillingDetails
                              ?.nanoSubscription?.isActiveBillingPackage ==
                          true
                      ? successTextColor
                      : Colors.orange[700],
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  fontSize: 18,
                ),
              ),
            ],
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.businessData.businessBillingDetails?.nanoSubscription?.data?[0].billingPeriodName ?? ''} Subscription',
                    style: const TextStyle(
                      color: darkGreyColor, // neutralDarkDarkest
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${widget.businessData.localCurrency ?? 'KES'} ${widget.businessData.businessBillingDetails?.nanoSubscription?.data?[0].totalBillingPlanAmount?.formatCurrency() ?? '0'}',
                        style: const TextStyle(
                          color: textSecondary, // neutralDarkLight
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '. Due: ${widget.businessData.businessBillingDetails?.nanoSubscription?.data?[0].dueDate?.toFormattedDate()}',
                        style: const TextStyle(
                          color: textSecondary, // neutralDarkLight
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                widget.businessData.businessBillingDetails?.nanoSubscription
                            ?.isActiveBillingPackage ==
                        true
                    ? 'Active'
                    : 'Inactive',
                style: TextStyle(
                  color: widget.businessData.businessBillingDetails
                              ?.nanoSubscription?.isActiveBillingPackage ==
                          true
                      ? successTextColor
                      : Colors.orange[700],
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  fontSize: 18,
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
    final details = <Map<String, String>>[
      {
        'title': 'Business Name',
        'value': widget.businessData.businessName ?? 'N/A',
        'color': 'dark',
      },
      {
        'title': 'Phone Number',
        'value': widget.businessData.businessOwnerPhone ?? 'N/A',
        'color': 'medium',
      },
      {
        'title': 'Email Address',
        'value': widget.businessData.businessOwnerEmail ?? 'N/A',
        'color': 'medium',
      },
      {
        'title': 'Location',
        'value': widget.businessData.businessOwnerAddress ?? 'N/A',
        'color': 'dark',
      },
      {
        'title': 'Owners',
        'value': widget.businessData.businessOwnerName ?? 'N/A',
        'color': 'medium',
      },
      {
        'title': 'Currency',
        'value': widget.businessData.localCurrency ?? 'KES',
        'color': 'medium',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Business Details Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Text(
                'Business Details',
                style: TextStyle(
                  color: textPrimary,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.getEditBusinessScreenRoute(),
                ).then((_) {
                  if (widget.onRefreshRequest != null) {
                    widget.onRefreshRequest!();
                  }
                });
              },
              child: const Text(
                'Edit',
                style: TextStyle(
                  color: accentRed, // highlightHighlightDarkest
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // List of business details
        ...details.map(
          (item) => Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 8,
            ),
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
                    fontSize: 14,
                  ),
                ),
                Flexible(
                  child: Text(
                    item['value']!,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: darkGreyColor, // neutralDarkMedium
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/customers_list/CustomerListResponse.dart';
import 'package:zed_nano/models/getZedPayItUserById/GetZedPayItUserByIdResponse.dart';
import 'package:zed_nano/models/get_customer_by_number/CustomerListResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/customers/details/customer_items_main_page.dart';
import 'package:zed_nano/screens/sell/sell_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/bottom_sheet_helper.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_dialog.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/utils/extensions.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserDetailsPage extends StatefulWidget {
  String? customerID;
  UserDetailsPage({Key? key, this.customerID}) : super(key: key);

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  bool _isContactDetailsExpanded = true;

  ZedPayItUserData? _cusomerData;

  @override
  void initState() {
    super.initState();
    // Defer the first data fetch until after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserByNumber();
    });
  }

  Future<void> getUserByNumber() async {
    try {
      final response =
      await getBusinessProvider(context).getUserByNumber(customerNumber: widget.customerID!, context: context);

      if (response.isSuccess) {
        setState(() {
          _cusomerData = response.data!.data;
        });
      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      showCustomToast('Failed to load product details');
    }
  }
  Future<void> activateCustomer() async {
    try {
      final response =
      await getBusinessProvider(context).changeStatus(customerNumber: widget.customerID!, status:"ACTIVE", context: context);

      if (response.isSuccess) {
        showCustomToast(response.message, isError: false);
        await getUserByNumber();
      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      showCustomToast('Failed to load product details');
    }
  }
  Future<void> suspendCustomer() async {
    try {
      final response =
      await getBusinessProvider(context).changeStatus(customerNumber: widget.customerID!, status: "SUSPENDED", context: context);

      if (response.isSuccess) {
        showCustomToast(response.message, isError: false);
        await getUserByNumber();

      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      showCustomToast('Failed to load product details');
    }
  }

  void _showSuspendCustomerBottomSheet() {
    showCustomDialog(
      context: context,
      title: 'Suspend User?',
      subtitle:
      "Are you sure you want to suspend ${_cusomerData?.firstName}?",
      negativeButtonText: 'Cancel',
      positiveButtonText: 'Suspend',
      onNegativePressed: () => Navigator.pop(context),
      onPositivePressed: () async {
        Navigator.pop(context); // Close dialog
        await suspendCustomer();
      },
    );
  }

  void _showRestoreCustomerBottomSheet() {
    showCustomDialog(
      context: context,
      title: 'Unsuspend User?',
      subtitle:
      "Are you sure you want to unsuspend ${_cusomerData?.firstName}? You’ll be able to create invoices and place orders for this customer.",
      negativeButtonText: 'Cancel',
      positiveButtonText: 'Unsuspend',
      onNegativePressed: () => Navigator.pop(context),
      onPositivePressed: () {
        // Add subscription cancellation logic here
        Navigator.pop(context); // Close dialog
        Navigator.pop(context); // Return to previous screen
      },
    );
  }

  void _showAwaitingCustomerBottomSheet() {
    showCustomDialog(
      context: context,
      title: 'Activate User?',
      subtitle:
      "Are you sure you want to activate ${_cusomerData?.firstName}?",
      negativeButtonText: 'Cancel',
      positiveButtonText: 'Activate',
      onNegativePressed: () => Navigator.pop(context),
      onPositivePressed: () async {
        // Add subscription cancellation logic here
        Navigator.pop(context); // Close dialog
        await activateCustomer();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  AuthAppBar(title: 'Customer Profile',
        actions: [
          TextButton(
            onPressed: () {
              if (_cusomerData?.userStatus?.toLowerCase() == 'active') {
                _showSuspendCustomerBottomSheet();
                return;
              }
              if (_cusomerData?.userStatus?.toLowerCase() == 'suspended') {
                _showAwaitingCustomerBottomSheet();
                return;
              }
              if (_cusomerData?.userStatus?.toLowerCase() == 'Awaiting') {
                _showAwaitingCustomerBottomSheet();
                return;
              }
            },
            child:  Text(
              _cusomerData?.userStatus?.toLowerCase() == 'active'
                  ? 'Suspend'
                  : _cusomerData?.userStatus?.toLowerCase() == 'suspended'
                  ? 'Restore'
                  : _cusomerData?.userStatus?.toLowerCase() == 'Awaiting'
                  ? 'Activate' : '',
              style: const TextStyle(
                color: accentRed,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],),
      body: RefreshIndicator(
        onRefresh: () async {
          await getUserByNumber();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              16.height,
              _buildCustomerHeader(),
              16.height,
              _buildCustomerDetails(),
              16.height,
              _buildeCustomerRole(),
              16.height,
            ],
          ).paddingSymmetric(horizontal: 18),
        ),
      ),
    );
  }
  Widget _buildeCustomerRole(){
    return    Container(
      width: context.width(),
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Role",
              style: TextStyle(
                fontFamily: 'Poppins',
                color: textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                letterSpacing: 0.12,

              )
          ),
          Text(_cusomerData?.userRole ?? "N/A",
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
              )
          )
        ],
      ),
    );
  }

  Widget _buildCustomerDetails(){
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isContactDetailsExpanded = !_isContactDetailsExpanded;
              });
            },
            child: Row(
              children: [
                const Expanded(
                  child: Text("User Details",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: textPrimaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      )
                  ),
                ),
                rfCommonCachedNetworkImage(
                    _isContactDetailsExpanded ? upIcon : dropIcon,
                    fit: BoxFit.cover,
                    height: 15,
                    width: 15,
                    radius: 8
                ),
              ],
            ).paddingSymmetric(vertical: 10),
          ),
          if (_isContactDetailsExpanded) ...[
            Row(
                children: [
                  rfCommonCachedNetworkImage(
                      phoneIconGray,
                      fit: BoxFit.cover,
                      height: 15,
                      width: 15,
                      radius: 8
                  ),
                  6.width,
                  Text("${_cusomerData?.userPhone ?? 'N/A'}",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.12,

                      )
                  )
                ]
            ).paddingSymmetric(vertical: 10),
            Row(
                children: [
                  rfCommonCachedNetworkImage(
                      emailIconGray,
                      fit: BoxFit.cover,
                      height: 15,
                      width: 15,
                      radius: 0
                  ),
                  6.width,
                  Text("${_cusomerData?.userEmail ?? 'N/A'}",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.12,

                      )
                  )
                ]
            ).paddingSymmetric(vertical: 10),
            Row(
                children: [
                  rfCommonCachedNetworkImage(
                      locationIcon,
                      fit: BoxFit.cover,
                      height: 15,
                      width: 15,
                      radius: 0
                  ),
                  6.width,
                  Expanded(
                    child: Text("${_cusomerData?.userName ?? 'N/A'}",
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.12,
                        )
                    ),
                  )
                ]
            ).paddingSymmetric(vertical: 10),
          ],
        ],
      ),
    );
  }

  Widget _buildCustomerHeader(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child:   rfCommonCachedNetworkImage(
              customerIndividualIcon,
              fit: BoxFit.cover,
              height: 40,
              width: 40,
              radius: 8
          ),
        ).paddingSymmetric(vertical: 10),
        Row(
          children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${_cusomerData?.fullName ?? 'N/A'}",
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: textPrimaryColor,
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        )
                    ).paddingSymmetric(vertical: 10),
                    Row(
                        children: [
                          rfCommonCachedNetworkImage(
                              calenderIcon,
                              fit: BoxFit.fitHeight,
                              height: 20,
                              width: 20,
                              radius: 0
                          ),

                          10.width,
                          Text("Created on ${_cusomerData?.dateAdded?.toFormattedDate() ?? 'N/A'}",
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                letterSpacing: 0.12,

                              )
                          )
                        ]
                    ).paddingSymmetric(vertical: 10)
                  ]
              ),
            ),

          ],
        ),
        16.height,
        Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _cusomerData?.userStatus?.toLowerCase() == "active"
                      ?lightGreenColor
                      : _cusomerData?.userStatus?.toLowerCase() == "pending"
                      ?lightOrange
                      :primaryYellowTextColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_cusomerData?.userStatus?.toLowerCase() ?? "",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: _cusomerData?.userStatus?.toLowerCase() == "active"
                          ? successTextColor
                          : _cusomerData?.userStatus?.toLowerCase() == "pending"
                          ? primaryOrangeTextColor
                          : googleRed,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    )
                ),
              ).paddingSymmetric(vertical: 10),

            ]
        )

      ],
    );
  }
}

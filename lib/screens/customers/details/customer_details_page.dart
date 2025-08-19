import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/get_customer_by_number/CustomerListResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/customers/details/customer_items_main_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/bottom_sheet_helper.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_dialog.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/utils/extensions.dart';
import 'package:zed_nano/viewmodels/data_refresh_extensions.dart';

class CustomerDetailsPage extends StatefulWidget {
  CustomerDetailsPage({super.key, this.customerID});
  String? customerID;

  @override
  _CustomerDetailsPageState createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  bool _isContactDetailsExpanded = false;

  CustomerData? _cusomerData;

  @override
  void initState() {
    super.initState();
    // Defer the first data fetch until after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCustomerByNumber();
    });
  }

  Future<void> getCustomerByNumber() async {
    try {
      final response =
      await getBusinessProvider(context).getCustomerByNumber(customerNumber: widget.customerID!, context: context);

      if (response.isSuccess) {
        setState(() {
          _cusomerData = response.data!.data.first;
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
      await getBusinessProvider(context).activateCustomer(customerNumber: widget.customerID!, context: context);

      if (response.isSuccess) {
        showCustomToast(response.message, isError: false);
        context.dataRefresh.refreshCustomersAfterMajorOperation(operation: 'customers_updated');
        await getCustomerByNumber();

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
      await getBusinessProvider(context).suspendCustomer(customerNumber: widget.customerID!, context: context);

      if (response.isSuccess) {
        showCustomToast(response.message, isError: false);
        await getCustomerByNumber();

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
      title: 'Suspend Customer?',
      subtitle:
      'Are you sure you want to suspend ${_cusomerData?.firstName}?',
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
      title: 'Unsuspend Customer??',
      subtitle:
      'Are you sure you want to unsuspend ${_cusomerData?.firstName}? You’ll be able to create invoices and place orders for this customer.',
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
      title: 'Activate Customer?',
      subtitle:
      'Are you sure you want to activate ${_cusomerData?.firstName}?',
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
            if (_cusomerData?.status == 'Active') {
              _showSuspendCustomerBottomSheet();
              return;
            }
            if (_cusomerData?.status == 'Suspended') {
              _showAwaitingCustomerBottomSheet();
              return;
            }
            if (_cusomerData?.status == 'Awaiting') {
              _showAwaitingCustomerBottomSheet();
              return;
            }
          },
          child:  Text(
            _cusomerData?.status == 'Active'
                ? 'Suspend'
                : _cusomerData?.status == 'Suspended'
                ? 'Restore'
                : _cusomerData?.status == 'Awaiting'
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
          await getCustomerByNumber();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              16.height,
              _buildCustomerHeader(),
              16.height,
              _buildCustomerDetails(),
              16.height,
              if (_cusomerData?.status != 'Active')
                _buildCustomerSummary() else
                  _buildeCustomerItems(),
              16.height,
            ],
          ).paddingSymmetric(horizontal: 18),
        ),
      ),
      floatingActionButton: _cusomerData?.status == 'Active' 
        ? FloatingActionButton(
            onPressed: () async {
              BottomSheetHelper.showCustomerOptionsBottomSheet(context, customerData: _cusomerData!);
            },
            backgroundColor: inactiveButton,
            child: SvgPicture.asset(
              fabMenuIcon,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(textPrimary, BlendMode.srcIn),
            ),
          )
        : null,
    );
  }
  Widget _buildeCustomerItems(){
    return CustomerItemsMainPage(customerID:widget.customerID);
  }

  Widget _buildCustomerSummary(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Summary',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xff000000),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
            ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(
              horizontal: 12, vertical: 6,),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text('Created by',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.12,

                        ),
                    ),
                  ),
                  Expanded(
                    child: Text(_cusomerData?.createdByName ?? 'N/A',
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: textPrimaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.12,

                        ),
                    ),
                  ),
                ],
              ).paddingSymmetric(vertical: 10),
               Row(
                children: [
                  const Expanded(
                    child: Text('Created on',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.12,

                        ),
                    ),
                  ),
                  Expanded(
                    child: Text('${_cusomerData?.createdAt?.toFormattedDate()}',
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: textPrimaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.12,

                        ),
                    ),
                  ),
                ],
              ).paddingSymmetric(vertical: 10),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildCustomerDetails(){
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 6,),
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
                  child: Text('Contact Details',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: textPrimaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                  ),
                ),
                rfCommonCachedNetworkImage(
                    _isContactDetailsExpanded ? upIcon : dropIcon,
                    fit: BoxFit.cover,
                    height: 15,
                    width: 15,
                    radius: 8,
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
                    radius: 8,
                ),
                6.width,
                Text(_cusomerData?.phone ?? 'N/A',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,

                    ),
                ),
              ],
            ).paddingSymmetric(vertical: 5),
            Row(
              children: [
                rfCommonCachedNetworkImage(
                    emailIconGray,
                    fit: BoxFit.cover,
                    height: 15,
                    width: 15,
                    radius: 0,
                ),
                6.width,
                 Text(_cusomerData?.email ?? 'N/A',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,

                    ),
                ),
              ],
            ).paddingSymmetric(vertical: 5),
            Row(
                children: [
                  rfCommonCachedNetworkImage(
                      locationIcon,
                      fit: BoxFit.cover,
                      height: 15,
                      width: 15,
                      radius: 0,
                  ),
                  6.width,
                  Expanded(
                    child: Text(_cusomerData?.customerAddress ?? 'N/A',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.12,
                        ),
                    ),
                  ),
                ],
            ).paddingSymmetric(vertical: 5),
          ],
        ],
      ),
    );
  }

  Widget _buildCustomerHeader(){
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text("${_cusomerData?.firstName ?? 'N/A'} ${_cusomerData?.lastName ?? 'N/A'}",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: textPrimaryColor,
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                  ),
                  Row(
                    children: [
                      rfCommonCachedNetworkImage(
                          calenderIcon,
                          fit: BoxFit.fitHeight,
                          height: 20,
                          width: 20,
                          radius: 0,
                      ),

                      10.width,
                      Text("Created on ${_cusomerData?.createdAt?.toFormattedDate() ?? 'N/A'}",
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            letterSpacing: 0.12,

                          ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child:   rfCommonCachedNetworkImage(
                  _cusomerData?.customerType == 'Individual'
                      ? customerIndividualIcon
                      : customerCompanyIcon,
                  fit: BoxFit.cover,
                  height: 40,
                  width: 40,
                  radius: 8,
              ),
            ),
            // rfCommonCachedNetworkImage(
            //     _cusomerData?.customerType == 'Individual'
            //         ? customerIndividualIcon
            //         : customerCompanyIcon,
            //     fit: BoxFit.cover,
            //     height: 40,
            //     width: 40,
            //     radius: 8
            // ),
          ],
        ),
        16.height,
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6,),
              decoration: BoxDecoration(
                color: _cusomerData?.status == 'Active'
                ?lightGreenColor
                : _cusomerData?.status == 'Pending'
                ?lightOrange
                :primaryYellowTextColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(_cusomerData?.status ?? '',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: _cusomerData?.status == 'Active'
                        ? successTextColor
                        : _cusomerData?.status == 'Pending'
                        ? primaryOrangeTextColor
                        : googleRed,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6,),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(_cusomerData?.customerType ?? '',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: textPrimaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  ),
              ),
            ),
          ],
        ),

      ],
    );
  }
}

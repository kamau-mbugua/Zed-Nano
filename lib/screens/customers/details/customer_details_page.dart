import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/customers_list/CustomerListResponse.dart';
import 'package:zed_nano/models/get_customer_by_number/CustomerListResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/customers/details/customer_items_main_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/utils/extensions.dart';

class CustomerDetailsPage extends StatefulWidget {
  String? customerID;
  CustomerDetailsPage({Key? key, this.customerID}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AuthAppBar(title: 'Customer Profile'),
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
    );
  }
  Widget _buildeCustomerItems(){
    return CustomerItemsMainPage(customerID:widget.customerID);
  }

  Widget _buildCustomerSummary(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Summary",
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xff000000),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
            )
        ),
        Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(
              horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text("Created by",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.12,

                        )
                    )
                  ),
                  Expanded(
                    child: new Text("${_cusomerData?.createdByName ?? 'N/A'}",
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: textPrimaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.12,

                        )
                    )
                  ),
                ],
              ).paddingSymmetric(vertical: 10),
               Row(
                children: [
                  const Expanded(
                    child: Text("Created on",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.12,

                        )
                    )
                  ),
                  Expanded(
                    child: Text("${_cusomerData?.createdAt?.toFormattedDate()}",
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: textPrimaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.12,

                        )
                    )
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
                  child: Text("Contact Details",
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
                Text("${_cusomerData?.phone ?? 'N/A'}",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,

                    )
                )
              ]
            ).paddingSymmetric(vertical: 5),
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
                 Text("${_cusomerData?.email ?? 'N/A'}",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,

                    )
                )
              ]
            ).paddingSymmetric(vertical: 5),
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
                    child: Text("${_cusomerData?.customerAddress ?? 'N/A'}",
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
                      )
                  ),
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
                      Text("Created on ${_cusomerData?.createdAt?.toFormattedDate() ?? 'N/A'}",
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
                  )
                ]
              ),
            ),
            rfCommonCachedNetworkImage(
                _cusomerData?.customerType == 'Individual'
                    ? customerIndividualIcon
                    : customerCompanyIcon,
                fit: BoxFit.cover,
                height: 40,
                width: 40,
                radius: 8
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
                color: _cusomerData?.status == "Active"
                ?lightGreenColor
                : _cusomerData?.status == "Pending"
                ?lightOrange
                :primaryYellowTextColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(_cusomerData?.status ?? "",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: _cusomerData?.status == "Active"
                        ? successTextColor
                        : _cusomerData?.status == "Pending"
                        ? primaryOrangeTextColor
                        : googleRed,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  )
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(_cusomerData?.customerType ?? "",
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: textPrimaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  )
              ),
            ),
          ]
        )

      ],
    );
  }
}

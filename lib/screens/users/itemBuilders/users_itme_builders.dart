import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/customers_list/CustomerListResponse.dart';
import 'package:zed_nano/models/listUsers/ListUsersResponse.dart';
import 'package:zed_nano/screens/customers/details/customer_details_page.dart';
import 'package:zed_nano/screens/users/detail/user_details_page.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Images.dart';

Widget listUsersItemBuilder(ListUserData customer) {
  return Builder(
    builder: (context) => GestureDetector(
      onTap: () {
        // CustomerDetailsPage(customerID: customer.id,).launch(context);
        UserDetailsPage(customerID: customer.userId).launch(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:   rfCommonCachedNetworkImage(
                      customerIndividualIcon,
                      fit: BoxFit.cover,
                      height: 30,
                      width: 30,
                      radius: 8
                  ),
                ),

                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${customer.firstName ?? ''} ${customer.secondName ?? ''}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          )
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text('${customer.userPhone}',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0.15,

                            ),

                          ),
                          const Text(
                              '.',
                              style: TextStyle(
                                  color:  textSecondary,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                  fontStyle:  FontStyle.normal,
                                  fontSize: 10.0
                              ),
                              textAlign: TextAlign.left
                          ),
                          Text('${customer.userRole}',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: textPrimary,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                              )
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                rfCommonCachedNetworkImage(
                    arrowItem,
                    fit: BoxFit.fitHeight,
                    height: 10,
                    width: 10,
                    radius: 8
                )
              ],
            ),
            16.height,
            const Divider(height: 1, thickness: 0.9),
          ],
        ),
      ),
    ),
  );
}

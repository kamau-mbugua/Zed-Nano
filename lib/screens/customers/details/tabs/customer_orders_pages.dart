import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/utils/Colors.dart';

class CustomerOrdersPages extends StatefulWidget {
  String customerId;
  CustomerOrdersPages({Key? key, required this.customerId}) : super(key: key);

  @override
  _CustomerOrdersPagesState createState() => _CustomerOrdersPagesState();
}

class _CustomerOrdersPagesState extends State<CustomerOrdersPages> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Orders',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xff000000),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                )
            ),
            Text('View All',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: accentRed,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                )
            )
          ],
        )
      ],
    ).paddingSymmetric(horizontal: 16);
  }
}

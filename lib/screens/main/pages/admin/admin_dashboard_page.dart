import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nb_utils/nb_utils.dart' as nb_utils hide Color;
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/routes/routes_helper.dart';
import 'package:zed_nano/screens/widgets/drawer_widget.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      drawer: const DrawerWidget(),
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: colorBackground,
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: SvgPicture.asset(
              menuIcon,
              width: 25,
              height: 25,
              colorFilter: const ColorFilter.mode(darkGreyColor, BlendMode.srcIn),
            ),
          );
        }),
        title: Text(
          'Business Dashboard',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: darkGreyColor),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.pushNamed(context, AppRoutes.getNotificationsPageRoute());
            },
            icon: SvgPicture.asset(
              userIcon,
              width: 30,
              height: 30,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Hello Mary", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: darkGreyColor)),
                        SizedBox(height: 4),
                        Text("We are glad to have you with us.", style: TextStyle(fontSize: 12, color: textSecondary)),
                      ]),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        border: Border.all(color: accentRed), borderRadius: BorderRadius.circular(6)),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: "14 ", style: TextStyle(color: accentRed, fontWeight: FontWeight.w600, fontSize: 16)),
                          TextSpan(text: "Days Trial Left", style: TextStyle(color: accentRed, fontSize: 10)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              10.height,
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffffb37c)),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Complete setting up your business",
                        style: TextStyle(fontSize: 14, color: darkGreyColor)),
                    CircularProgressIndicator(
                      strokeWidth: 5,
                      valueColor: AlwaysStoppedAnimation(Color(0xffe86339)),
                      backgroundColor: Color(0xffffb37c),
                    )
                  ],
                ),
              ),
              10.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Overview", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  DropdownButton<String>(
                    value: 'Today',
                    underline: SizedBox(),
                    items: ['Today', 'This Week', 'This Month']
                        .map((val) => DropdownMenuItem<String>(
                      value: val,
                      child: Text(val, style: TextStyle(fontSize: 12)),
                    ))
                        .toList(),
                    onChanged: (_) {},
                  )
                ],
              ),
              10.height,
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  buildOverviewCard('Total Sales', 'KES 0.00', totalSalesIcon,lightGreen),
                  buildOverviewCard('Products Sold', '0', productIcon,lightGrey),
                  buildOverviewCard('Pending Payment', 'KES 0.00', pendingPaymentsIcon,lightOrange),
                  buildOverviewCard('Customers', '0', customerCreatedIcon,lightBlue),
                ],
              ),
              10.height,
              Text("Payment Summary", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              10.height,
              buildEmptyCard("Nothing here. For Now!", "Total sales for each payment method will be displayed here."),
              10.height,
              Text("Recent Sales", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              buildEmptyCard("Nothing here. For Now!", "Recent sales will be displayed here."),
              10.height

            ],
          ),
        ),

      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('Sell', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
        icon: Icon(Icons.lock, color: Colors.white),
        backgroundColor: appThemePrimary,
      ),
    );
  }
}

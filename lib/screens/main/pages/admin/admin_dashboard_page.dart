import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nb_utils/nb_utils.dart' as nb_utils hide Color;
import 'package:provider/provider.dart';
import 'package:zed_nano/models/posLoginVersion2/login_response.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/business/get_started_page.dart';
import 'package:zed_nano/screens/business/setup_bottom_sheet.dart';
import 'package:zed_nano/screens/widget/common/custom_app_bar.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/routes/routes_helper.dart';
import 'package:zed_nano/screens/widgets/drawer_widget.dart';
import 'package:zed_nano/viewmodels/WorkflowViewModel.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {

  LoginResponse? loginResponse;
  String? workflowState;

  @override
  void initState() {
    loginResponse = getAuthProvider(context).loginResponse;
    super.initState();
  }


  double getValue(WorkflowViewModel viewModel) {
    final state = viewModel.workflowState?.toLowerCase() ?? '';
    switch (state) {
      case "basic":
        return 0.2;
      case "billing":
        return 0.4;
      case "category":
        return 0.6;
      case "products":
        return 0.8;
      default:
        return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      drawer: const DrawerWidget(),
      appBar: const CustomDashboardAppBar(),
      body: Consumer<WorkflowViewModel>(
        builder: (context, viewModel, _) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Hello ${loginResponse?.username ?? ''}", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: darkGreyColor)),
                            const SizedBox(height: 4),
                            const Text("We are glad to have you with us.", style: TextStyle(fontSize: 12, color: textSecondary)),
                          ]),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                            border: Border.all(color: accentRed), borderRadius: BorderRadius.circular(6)),
                        child: RichText(
                          text: const TextSpan(
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
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        builder: (context) => SetupStepBottomSheet(currentStep: viewModel.workflowState!.toLowerCase()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xffffb37c)),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Complete setting up your business",
                              style: TextStyle(fontSize: 14, color: darkGreyColor)),
                          CircularProgressIndicator(
                            value: getValue(viewModel),
                            strokeWidth: 5,
                            valueColor: const AlwaysStoppedAnimation(Color(0xffe86339)),
                            backgroundColor: const Color(0xffffb37c),
                          )
                        ],
                      ),
                    ),
                  ),
                  10.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Overview", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: DropdownButton<String>(
                          value: 'Today',
                          underline: const SizedBox(),
                          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                          isDense: true,
                          items: ['Today', 'This Week', 'This Month']
                              .map((val) => DropdownMenuItem<String>(
                            value: val,
                            child: Text(val, style: const TextStyle(fontSize: 12, fontFamily: 'Poppins')),
                          ))
                              .toList(),
                          onChanged: (_) {},
                        ),
                      )
                    ],
                  ),
                  10.height,
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // Calculate the width for each card based on available space
                      // For 2 cards per row with spacing of 16 between them
                      final cardWidth = (constraints.maxWidth - 16) / 2;

                      return GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: cardWidth / 120, // Maintain the height of 120
                        children: [
                          buildOverviewCard('Total Sales', 'KES 0.00', totalSalesIcon, lightGreenColor, width: cardWidth),
                          buildOverviewCard('Products Sold', '0', productIcon, lightGrey, width: cardWidth),
                          buildOverviewCard('Pending Payment', 'KES 0.00', pendingPaymentsIcon, lightOrange, width: cardWidth),
                          buildOverviewCard('Customers', '0', customerCreatedIcon, lightBlue, width: cardWidth),
                        ],
                      );
                    },
                  ),
                  10.height,
                  const Text("Payment Summary", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  10.height,
                  buildEmptyCard("Nothing here. For Now!", "Total sales for each payment method will be displayed here."),
                  10.height,
                  const Text("Recent Sales", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  buildEmptyCard("Nothing here. For Now!", "Recent sales will be displayed here."),
                  10.height

                ],
              ),
            ),

          );
        }
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
        },
        label: const Text('Sell', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
        icon: const Icon(Icons.lock, color: Colors.white),
        backgroundColor: appThemePrimary,
      ),
    );
  }
}

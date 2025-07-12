import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nb_utils/nb_utils.dart' as nb_utils hide Color;
import 'package:provider/provider.dart';
import 'package:zed_nano/models/branch-store-summary/BranchStoreSummaryResponse.dart';
import 'package:zed_nano/models/get_branch_transaction_by_date/BranchTransactionByDateResponse.dart';
import 'package:zed_nano/models/posLoginVersion2/login_response.dart';
import 'package:zed_nano/providers/business/BusinessProviders.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/business/get_started_page.dart';
import 'package:zed_nano/screens/business/bottomsheets/setup_bottom_sheet.dart';
import 'package:zed_nano/screens/widget/common/bottom_sheet_helper.dart';
import 'package:zed_nano/screens/widget/common/custom_app_bar.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/routes/routes_helper.dart';
import 'package:zed_nano/screens/widgets/drawer_widget.dart';
import 'package:zed_nano/viewmodels/WorkflowViewModel.dart';
import 'package:zed_nano/utils/date_range_util.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {

  LoginResponse? loginResponse;
  BranchStoreSummaryResponse? branchStoreSummaryResponse;
  BranchTransactionByDateResponse? branchTransactionByDateResponse;
  String? workflowState;
  String? businessName;

  // Default selected range label
  String _selectedRangeLabel = 'this_month';
  late Map<String, String> _dateRange;

  final _dateRangeOptions = [
    'today',
    'this_week',
    'this_month',
    'this_year',
  ];

  @override
  void initState() {
    super.initState();
    loginResponse = getAuthProvider(context).loginResponse;
    businessName = getAuthProvider(context).businessDetails?.businessName;
    WorkflowViewModel viewModel = Provider.of<WorkflowViewModel>(context, listen: false);

    _dateRange = DateRangeUtil.getDateRange(_selectedRangeLabel);

    fetchBranchStoreSummary();

  }

  Future<void> fetchBranchStoreSummary() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var requestData = {
        'branchId': getAuthProvider(context).businessDetails?.branchId,
        'endDate':_dateRange.values.last,
        'startDate':_dateRange.values.first,
      };
      await branchStoreSummary(requestData:requestData);
      await getBranchTransactionByDate(requestData:requestData);
    });
  }
  Future<void> branchStoreSummary({required Map<String, dynamic> requestData}) async {

    await context
        .read<BusinessProviders>()
        .branchStoreSummary(context: context, requestData:requestData)
        .then((value) async {
      if (value.isSuccess) {
        setState(() {
          branchStoreSummaryResponse = value.data;
        });
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }
  Future<void> getBranchTransactionByDate({required Map<String, dynamic> requestData}) async {
    requestData['type'] = "ALL";
    await context
        .read<BusinessProviders>()
        .getBranchTransactionByDate(context: context, requestData:requestData)
        .then((value) async {
      if (value.isSuccess) {
        setState(() {
          branchTransactionByDateResponse = value.data;
        });
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
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
      case "product":
        return 0.8;
      default:
        return 1.0;
    }
  }

  void _onRangeChanged(String? newLabel) {
    if (newLabel == null) return;
    setState(() {
      _selectedRangeLabel = newLabel;
      _dateRange = DateRangeUtil.getDateRange(_selectedRangeLabel);
    });
    fetchBranchStoreSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      drawer: const DrawerWidget(),
      appBar: CustomDashboardAppBar(title: businessName ?? '',),
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
                      Visibility(
                        visible: viewModel.billingPlan?.freeTrialStatus != "InActive",
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                              border: Border.all(color: accentRed), borderRadius: BorderRadius.circular(6)),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(text: "${viewModel.billingPlan?.freeTrialPeriodRemainingdays ?? 0} ", style: TextStyle(color: accentRed, fontWeight: FontWeight.w600, fontSize: 16)),
                                TextSpan(text: "Days Trial Left", style: TextStyle(color: accentRed, fontSize: 10)),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  10.height,
                  GestureDetector(
                    onTap: () async {

                      if (viewModel.workflowState == null) {
                        await viewModel.skipSetup(context);
                        return;
                      }
                      BottomSheetHelper.showSetupStepBottomSheet(
                          context,
                        currentStep: viewModel.workflowState!.toLowerCase(),
                      );
                      // showModalBottomSheet(
                      //   context: context,
                      //   backgroundColor: Colors.white,
                      //   shape: const RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      //   ),
                      //   builder: (context) => SetupStepBottomSheet(currentStep: viewModel.workflowState!.toLowerCase()),
                      // );
                    },
                    child: Visibility(
                      visible: viewModel.workflowState != "COMPLETE",
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
                        child:DropdownButton<String>(
                          value: _selectedRangeLabel,
                          items: _dateRangeOptions.map((val) => DropdownMenuItem(
                            value: val,
                            child: Text(val), // You can use a user-friendly label here if needed
                          )).toList(),
                          onChanged: _onRangeChanged,
                        )
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
                          buildOverviewCard('Total Sales', 'KES ${branchStoreSummaryResponse?.data?.totalSales?.amount?? '0.00'}', totalSalesIcon, lightGreenColor, width: cardWidth),
                          buildOverviewCard('Products Sold', '${branchStoreSummaryResponse?.data?.soldStock?.businessSoldStockQuantity?? '0.00'}', productIcon, lightGrey, width: cardWidth),
                          buildOverviewCard('Pending Payment', 'KES ${branchStoreSummaryResponse?.data?.unpaidTotals?.totalUnpaid ?? '0.00'}', pendingPaymentsIcon, lightOrange, width: cardWidth),
                          buildOverviewCard('Customers', '${branchStoreSummaryResponse?.data?.customerCount?.totalCustomers ?? '0.00'}', customerCreatedIcon, lightBlue, width: cardWidth),
                        ],
                      );
                    },
                  ),
                  10.height,
                  const Text("Payment Summary", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  10.height,
                  buildSalesSummaryList(),
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
  Widget buildSalesSummaryList() {
    final summaryList = branchTransactionByDateResponse?.data ?? [];

    if (summaryList.isEmpty) {
      return buildEmptyCard("Nothing here. For Now!", "Total sales for each payment method will be displayed here.");
    }

    // Optionally define color per payment type
    Color getBarColor(String type) {
      switch (type.toUpperCase()) {
        case "MPESA": return Colors.green;
        case "CASH": return Colors.blue;
        case "Kcb Mpesa": return Colors.orange;
        default: return Colors.teal;
      }
    }

    return Column(
      children: summaryList.map<Widget>((item) {
        return buildSalesSummaryRow(
          name: item?.transationType ?? "",
          currency: item?.currency ?? "",
          amount: item?.amount ?? 0,
          percentage: item?.percentageOfTotal?.toDouble() ?? 0,
          color: getBarColor(item?.transationType ?? ""),
        );
      }).toList(),
    );
  }
}



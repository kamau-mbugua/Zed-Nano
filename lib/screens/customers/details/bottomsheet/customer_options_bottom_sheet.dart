import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/models/customers_list/CustomerListResponse.dart';
import 'package:zed_nano/models/get_customer_by_number/CustomerListResponse.dart';
import 'package:zed_nano/screens/sell/sell_stepper_page.dart';
import 'package:zed_nano/screens/widget/common/base_bottom_sheet.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/viewmodels/CustomerInvoicingViewModel.dart';

class CustomerOptionsBottomSheet extends StatelessWidget {
  CustomerOptionsBottomSheet({required this.customerData, super.key});
  CustomerData? customerData;


  final List<String> steps = [
    'Create Invoice',
    'Place Order',
  ];


  @override
  Widget build(BuildContext context) {
    final customerInvoicingViewModel = Provider.of<CustomerInvoicingViewModel>(context);
    return BaseBottomSheet(
      title: 'More Actions',
      initialChildSize: 0.5,
      headerContent:  const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select an option to proceed.',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              color: Color(0xff71727a),
            ),
          ),
        ],
      ).paddingTop(16),
      bodyContent: SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        child: ListView.builder(
          itemCount: steps.length,
          itemBuilder: (context, index) {
            return arrowListItem(
              index: index,
              steps: steps,
              onTab: (index) {
                //get the step name
                final stepName = steps[index as int];
                switch (stepName) {
                  case 'Create Invoice':

                    final customer = Customer(
                      id: customerData?.id ?? '',
                      customerType: customerData?.customerType ?? '',
                      paymentType: customerData?.paymentType ?? 'Normal',
                      isParentPrimary: customerData?.isParentPrimary ?? false,
                      parentType: customerData?.parentType ?? '',
                      limit: customerData?.limit ?? 0,
                      amountReceived: customerData?.amountReceived ?? 0,
                      status: customerData?.status ?? 'Active',
                      billableItems: customerData?.billableItems ?? [],
                      customerName: '${customerData?.firstName ?? ''} ${customerData?.lastName ?? ''}'.trim(),
                      physicalAddress: customerData?.customerAddress ?? '',
                      mobileNumber: customerData?.phone ?? '',
                      email: customerData?.email ?? '',
                      createdOn: DateTime.tryParse(customerData?.createdAt ?? '') ?? DateTime.now(),
                      userId: customerData?.userId ?? '',
                      servicesCount: 0, 
                      services: [], 
                      pendingInvoices: customerData?.pendingInvoicesCount ?? 0,
                      pendingAmount: customerData?.pendingAmount ?? 0,
                      numberOfActiveHouses: 0,
                      createdByName: customerData?.createdByName,
                    );

                    customerInvoicingViewModel.setCustomerData(customer);
                    const SellStepperPage(stepType: SellStepType.Invoice,initialStep:1).launch(context);
                  case 'Place Order':
                    logger.d('Place Order' );
                    SellStepperPage(customerId: customerData!.id).launch(context);
                  default:
                    break;
                }
              },
            );
          },
        ),
      ),
    );
  }
}

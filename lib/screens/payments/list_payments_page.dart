import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/models/get_payment_methods_with_status/PaymentMethodsResponse.dart';
import 'package:zed_nano/providers/business/BusinessProviders.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/bottom_sheet_helper.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/viewmodels/WorkflowViewModel.dart';
import 'package:zed_nano/viewmodels/payment_view_model.dart';

// Class to hold filtered payment method data
class FilteredPaymentMethod {

  FilteredPaymentMethod({
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.key,
  });
  final String iconPath;
  final String title;
  final String subtitle;
  final bool status;
  final String key;
}

class AddPaymentMethodScreen extends StatefulWidget {

  const AddPaymentMethodScreen({super.key, this.isWorkFlow = true});

  //add a defult isworkFlow to true
  final bool isWorkFlow;

  @override
  State<AddPaymentMethodScreen> createState() => _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState extends State<AddPaymentMethodScreen> {
  List<FilteredPaymentMethod> filteredPaymentMethods = [];
  late PaymentViewModel _paymentViewModel;

  List<PaymentMethod>? paymentMethod;

  @override
  void initState() {
    super.initState();
    _paymentViewModel = PaymentViewModel();
    // Listen for payment method updates
    _paymentViewModel.addListener(_checkForRefresh);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getPaymentMethods();
    });
  }

  // Check if payment methods need to be refreshed
  void _checkForRefresh() {
    if (_paymentViewModel.needsRefresh) {
      getPaymentMethods();
      _paymentViewModel.setNeedsRefresh(false);
    }
  }

  @override
  void dispose() {
    _paymentViewModel.removeListener(_checkForRefresh);
    super.dispose();
  }

  Future<void> refresh() async {
    try {
      final viewModel = Provider.of<WorkflowViewModel>(context, listen: false);
      await viewModel.skipSetup(context);

      if (mounted) {
        Navigator.pop(context); // Pop current screen
      }

    } catch (e) {
      logger.e('Error in refresh: $e');
    }
  }

  Future<void> getPaymentMethods() async {
    await context
        .read<BusinessProviders>()
        .getPaymentMethodsWithStatus(context: context)
        .then((value) async {
      if (value.isSuccess) {
        setState(() {
          paymentMethod = value.data!.data;
          _filterPaymentMethods();
        });
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }

  Future<void> _enableCashPayment(String status) async {
    final requestData = <String, dynamic>{};

    await context
        .read<BusinessProviders>()
        .enableCashPayment(context: context, requestData:requestData, status: status)
        .then((value) async {
      if (value.isSuccess) {
        showCustomToast(value.message, isError: false);
        await getPaymentMethods();
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }

  Future<void> _enableSettleInvoiceStatus(Map<String, dynamic> requestData) async {

    await context
        .read<BusinessProviders>()
        .enableSettleInvoiceStatus(context: context, requestData:requestData)
        .then((value) async {
      if (value.isSuccess) {
        showCustomToast(value.message, isError: false);
        await getPaymentMethods();
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }

  Future<void> _updateBusinessSetupStatus(Map<String, dynamic> requestData) async {

    await context
        .read<BusinessProviders>()
        .updateBusinessSetupStatus(context: context, requestData:requestData)
        .then((value) async {
      if (value.isSuccess) {
        showCustomToast(value.message, isError: false);
        await refresh();
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }
  
  // Method to filter payment methods based on requirements
  void _filterPaymentMethods() {
    filteredPaymentMethods = [];
    
    if (paymentMethod == null) {
      getPaymentMethods();
      return;
    }
    
    // Find Mpesa
    final mpesaMethod = paymentMethod!.firstWhere(
      (method) => method.name?.toLowerCase() == 'mpesa',
      orElse: () => PaymentMethod(name: 'Mpesa', status: false),
    );
    filteredPaymentMethods.add(
      FilteredPaymentMethod(
        iconPath: mpesaIcon,
        title: 'MPESA',
        subtitle: 'Paybill Number, Till Number',
        status: mpesaMethod.status ?? false,
        key: 'Mpesa',
      ),
    );
    
    // Find Cash
    final cashMethod = paymentMethod!.firstWhere(
      (method) => method.name?.toLowerCase() == 'cash',
      orElse: () => PaymentMethod(name: 'Cash', status: false),
    );
    filteredPaymentMethods.add(
      FilteredPaymentMethod(
        iconPath: cashIcon,
        title: 'Cash',
        subtitle: 'Accept Cash',
        status: cashMethod.status ?? false,
        key: 'Cash',
      ),
    );
    
    // Find Settle Invoice
    final settleInvoiceMethod = paymentMethod!.firstWhere(
      (method) => method.name?.toLowerCase() == 'settleinvoicestatus',
      orElse: () => PaymentMethod(name: 'settleInvoiceStatus', status: false),
    );
    filteredPaymentMethods.add(
      FilteredPaymentMethod(
        iconPath: settleInvoiceIcon,
        title: 'Settle Invoice',
        subtitle: 'Reconcile payments from bank transfers, RTGS, PesaLink, EFT and Cheque',
        status: settleInvoiceMethod.status ?? false,
        key: 'settleInvoiceStatus',
      ),
    );
    
    // Find KCB Mobile Money
    var kcbMobileMoneyStatus = false;
    final banksMethod = paymentMethod!.firstWhere(
      (method) => method.name?.toLowerCase() == 'banks',
      orElse: () => PaymentMethod(name: 'Banks', status: false),
    );
    
    if (banksMethod.paymentOptions != null) {
      final kcbOption = banksMethod.paymentOptions!.firstWhere(
        (option) => option.name?.toLowerCase() == 'kcb',
        orElse: () => PaymentOption(name: 'KCB'),
      );
      
      if (kcbOption.kcb != null) {
        final mobileMoney = kcbOption.kcb!.firstWhere(
          (bank) => bank.name?.toLowerCase() == 'mobile money',
          orElse: () => BankPayment(name: 'Mobile Money', status: false),
        );
        kcbMobileMoneyStatus = mobileMoney.status ?? false;
      }
    }
    
    filteredPaymentMethods.add(
      FilteredPaymentMethod(
        iconPath: kcbIcon,
        title: 'KCB Bank Mobile Money',
        subtitle: 'Vooma Till, Account Number',
        status: kcbMobileMoneyStatus,
        key: 'KCB_Mobile_Money',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AuthAppBar(title: 'Add Payment Method'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headings(
              label: 'Payment Methods',
              subLabel: 'Setup how you will receive your payments.',
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                    itemCount: filteredPaymentMethods.length,
                    itemBuilder: (context, index) {
                      final method = filteredPaymentMethods[index];
                      return _buildPaymentOptionTile(
                        iconPath: method.iconPath,
                        title: method.title,
                        subtitle: method.subtitle,
                        keyName: method.key,
                        isActive: method.status,
                      );
                    },
                  ),
            ),
            const SizedBox(height: 10),
            if(widget.isWorkFlow)
            appButton(text: 'Complete', onTap: () {
              final requestData = <String, dynamic>{
                'workflowState': 'COMPLETE',
              };
              _updateBusinessSetupStatus(requestData);
            }, context: context,),
            const SizedBox(height: 16),

          ],
        ),
      ),
    );
  }
  Widget _buildPaymentOptionTile({
    required String iconPath,
    required String title,
    required String subtitle,
    required String keyName,
    required bool isActive,
  }) {
    return ListTile(
      onTap: () => _onPaymentMethodTap(keyName),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Container(
        width: 48,
        height: 48,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade100,
        ),
        child: SvgPicture.asset(
          iconPath,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          fontFamily: 'Poppins',
          color: Colors.grey,
        ),
      ),
      trailing: Switch(
        value: filteredPaymentMethods.firstWhere((method) => method.key == keyName).status,
        onChanged: (val) {
          setState(() {
            _onPaymentMethodTap(keyName);
            // final index = filteredPaymentMethods.indexWhere((method) => method.key == keyName);
            // if (index != -1) {
            //   filteredPaymentMethods[index] = FilteredPaymentMethod(
            //     iconPath: filteredPaymentMethods[index].iconPath,
            //     title: filteredPaymentMethods[index].title,
            //     subtitle: filteredPaymentMethods[index].subtitle,
            //     status: val,
            //     key: filteredPaymentMethods[index].key,
            //   );
            // }
          });
        },
      ),
    );
  }

  // Handle tapping on payment methods
  void _onPaymentMethodTap(String keyName) {
    switch (keyName) {
      case 'Mpesa':
        final status = filteredPaymentMethods.firstWhere((method) => method.key == 'Mpesa').status;
        if (!status) {
          BottomSheetHelper.showAddMpesaOptionsBottomsheet(context);
        }
      case 'KCB_Mobile_Money':
        final status = filteredPaymentMethods.firstWhere((method) => method.key == 'KCB_Mobile_Money').status;
        if (!status) {
          BottomSheetHelper.showAddKcbOptionsBottomsheet(context);
        }
      case 'Cash':
        final status = filteredPaymentMethods.firstWhere((method) => method.key == 'Cash').status;
        _enableCashPayment(!status ? 'true' : 'false');
      case 'settleInvoiceStatus':
        final status = filteredPaymentMethods.firstWhere((method) => method.key == 'settleInvoiceStatus').status;
        final requestData = <String, dynamic>{};
        requestData['status'] = !status;
        requestData['name'] = 'settleInvoiceStatus';
        _enableSettleInvoiceStatus(requestData);
      default:
        // Handle any other payment methods
        showCustomToast('This payment method will be available soon');
    }
  }
}

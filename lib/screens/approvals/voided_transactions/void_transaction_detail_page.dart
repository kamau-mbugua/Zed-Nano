import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/models/by-transaction-id/TransactionDetailResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Constants.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/utils/extensions.dart';

class VoidTransactionDetailPage extends StatefulWidget {
  final String? transactionId;

  const VoidTransactionDetailPage({
    Key? key,
    required this.transactionId,
  }) : super(key: key);

  @override
  State<VoidTransactionDetailPage> createState() => _VoidTransactionDetailPageState();
}

class _VoidTransactionDetailPageState extends State<VoidTransactionDetailPage> {
  bool _isProcessing = false;

  ByTransactionIdDetailResponse? byTransactionIdDetailResponse;

  @override
  void initState() {
    super.initState();
    // Defer the first data fetch until after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getOrderPaymentStatus();
    });
  }

  Future<void> getOrderPaymentStatus() async {
    final requestData = <String, dynamic>{'transactionId': widget.transactionId};

    try {
      final response = await getBusinessProvider(context)
          .getTransactionByTransactionId(
        requestData: requestData, context: context,);

      if (response.isSuccess) {
        setState(() {
          byTransactionIdDetailResponse = response.data;
        });
      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      logger.e('getOrderPaymentStatus $e');
      showCustomToast('Failed to load Order details');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AuthAppBar(title: 'Void Transaction Request'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transaction Header Section
            _buildTransactionHeader(),
            
            32.height,
            
            // Payment Summary Section
            _buildPaymentSummary(),
            
            24.height,
            
            // Order Summary Section
            _buildOrderSummary(),
            
            24.height,
            
            // Request Summary Section
            _buildRequestSummary(),
            
            40.height,
            
            _buildActionButtons(),
            
            24.height,
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Transaction ID Label
          const Text(
            'Transaction ID:',
            style: TextStyle(
              color: Color(0xFF71727A),
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
            ),
          ),
          8.height,

          // Transaction ID and Status Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Transaction ID
              Expanded(
                child: Text(
                  byTransactionIdDetailResponse?.data?.transactionID ?? 'N/A',
                  style: const TextStyle(
                    color: Color(0xFF1F2024),
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),

              // Status Badge
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getStatusBackgroundColor(byTransactionIdDetailResponse?.data?.voidStatus ?? ''),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  byTransactionIdDetailResponse?.data?.voidStatus ?? 'N/A',
                  style: TextStyle(
                    color: _getStatusTextColor(byTransactionIdDetailResponse?.data?.status ?? ''),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),

          16.height,

          // Date Row
          Row(
            children: [
              rfCommonCachedNetworkImage(
                calenderIcon,
                height: 16,
                width: 16,
                color: const Color(0xFF9CA3AF),
                radius: 0
              ),
              8.width,
              Text(
                  byTransactionIdDetailResponse?.data?.voidStatus == 'DECLINED'
                      ? byTransactionIdDetailResponse?.data?.dateVoidDeclined?.toFormattedDate() ?? 'N/A'
                      : byTransactionIdDetailResponse?.data?.voidStatus == 'VOIDED'
                          ? byTransactionIdDetailResponse?.data?.dateVoided?.toFormattedDate() ?? 'N/A'
                          : byTransactionIdDetailResponse?.data?.dateVoidRequested?.toFormattedDate() ?? 'N/A',
                  style: const TextStyle(
                  color: Color(0xFF71727A),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return _buildSection(
      title: 'Payment Summary',
      child: _buildSummaryCard([
        _buildSummaryRow('Amount Paid', byTransactionIdDetailResponse?.data?.transamount?.formatCurrency() ?? '0', isAmount: true),
        _buildSummaryRow('Paid via', byTransactionIdDetailResponse?.data?.transactionType ?? 'N/A'),
      ]),
    );
  }

  Widget _buildOrderSummary() {
    return _buildSection(
      title: 'Order Summary',
      child: _buildSummaryCard([
        _buildSummaryRow('Order Number', byTransactionIdDetailResponse?.data?.orderNo ?? 'N/A'),
        _buildSummaryRow('No. of Items', byTransactionIdDetailResponse?.data?.items?.length?.toString() ?? '0'),
      ]),
    );
  }

  Widget _buildRequestSummary() {
    return _buildSection(
      title: 'Request Summary',
      child:byTransactionIdDetailResponse?.data?.voidStatus == 'VOIDED' ? _buildSummaryCard([
        _buildSummaryRow('Approved By', byTransactionIdDetailResponse?.data?.voidedBy ?? 'N/A'),
        _buildSummaryRow('Approved On', byTransactionIdDetailResponse?.data?.dateVoided ?? 'N/A'),
        _buildSummaryRow('Reason', byTransactionIdDetailResponse?.data?.voidComments ?? 'N/A', isMultiline: true),
      ])
          : byTransactionIdDetailResponse?.data?.voidStatus == 'DECLINED'
        ? _buildSummaryCard([
        _buildSummaryRow('Declined By', byTransactionIdDetailResponse?.data?.voidDeclinedBy ?? 'N/A'),
        _buildSummaryRow('Declined On', byTransactionIdDetailResponse?.data?.dateVoidDeclined ?? 'N/A'),
        _buildSummaryRow('Reason', byTransactionIdDetailResponse?.data?.voidComments ?? 'N/A', isMultiline: true),
      ])
          :
      _buildSummaryCard([
        _buildSummaryRow('Requested By', byTransactionIdDetailResponse?.data?.voidRequestedBy ?? 'N/A'),
        _buildSummaryRow('Requested On', byTransactionIdDetailResponse?.data?.dateVoidRequested ?? 'N/A'),
        _buildSummaryRow('Reason', byTransactionIdDetailResponse?.data?.voidComments ?? 'N/A', isMultiline: true),
      ])
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF000000),
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        12.height,
        child,
      ],
    );
  }

  Widget _buildSummaryCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isAmount = false, bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF71727A),
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
            ),
          ),
          
          if (isMultiline)
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Color(0xFF1F2024),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  height: 1.4,
                ),
              ),
            )
          else
            Text(
              value,
              style: TextStyle(
                color: const Color(0xFF1F2024),
                fontSize: isAmount ? 14 : 12,
                fontWeight: isAmount ? FontWeight.w600 : FontWeight.w400,
                fontFamily: 'Poppins',
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Visibility(
      visible: byTransactionIdDetailResponse?.data?.voidStatus != 'DECLINED' && byTransactionIdDetailResponse?.data?.voidStatus != 'VOIDED',
      child: Row(
        children: [
          // Decline Button
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFDC3545),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: _isProcessing ? null : () => _handleDecline(),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDC3545)),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.close,
                            color: Color(0xFFDC3545),
                            size: 18,
                          ),
                          8.width,
                          const Text(
                            'Decline',
                            style: TextStyle(
                              color: Color(0xFFDC3545),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),

          16.width,

          // Approve Button
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF17AE7B),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: _isProcessing ? null : () => _handleApprove(),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 18,
                          ),
                          8.width,
                          const Text(
                            'Approve',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'request':
        return lightOrange;
      case 'voided':
        return lightGreenColor;
      case 'declined':
        return primaryYellowTextColor;
      default:
        return lightOrange;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'request':
        return primaryOrangeTextColor;
      case 'voided':
        return successTextColor;
      case 'declined':
        return googleRed;
      default:
        return primaryOrangeTextColor;
    }
  }

  void _handleApprove() async {
    var payload = {
      "comments": 'approve transaction ${widget.transactionId}',
      "action": "approve",
      "transactionId": widget.transactionId
    };

    await getBusinessProvider(context).voidTransaction(requestData: payload, context: context).then((value) {
      if (value.isSuccess) {
        showCustomToast(value.message ?? 'Transaction Declined');
        finish(context);
      } else {
        showCustomToast(value.message ?? 'Failed to load product details');
      }
    });

  }

  void _handleDecline() async {
    var payload = {
      "comments": 'decline transaction ${widget.transactionId}',
      "action": "decline",
      "transactionId": widget.transactionId
    };
    await getBusinessProvider(context).voidTransaction(requestData: payload, context: context).then((value) {
      if (value.isSuccess) {
        showCustomToast(value.message ?? 'Transaction Declined');
        finish(context);
      } else {
        showCustomToast(value.message ?? 'Failed to load product details');
      }
    });
  }
}

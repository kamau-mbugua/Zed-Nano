import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/GifsImages.dart';

class SalesByDaySummaryPage extends StatefulWidget {
  String startDate;
  String endDate;
  SalesByDaySummaryPage({Key? key, required this.startDate, required this.endDate}) : super(key: key);

  @override
  _SalesByDaySummaryPageState createState() => _SalesByDaySummaryPageState();
}

class _SalesByDaySummaryPageState extends State<SalesByDaySummaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:       Center(
        child: _orderHearder(),
      ),
      bottomNavigationBar: _buildSubmitButton(),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Visibility(
                child: appButton(
                  text: 'Done',
                  onTap: () {
                    finish(context);
                  },
                  context: context,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _orderHearder() {
    return CompactSuccessGifDisplayWidget(
      gifPath: successGif,
      title: 'Report Request Received Successfully',
      subtitle: 'Your Sales Report By Day from ${widget.startDate} to ${widget.endDate} has been received and will be sent to your email address.',
        textAlign: TextAlign.center
    );
  }
}

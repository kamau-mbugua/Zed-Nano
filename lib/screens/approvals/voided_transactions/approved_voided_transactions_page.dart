import 'package:flutter/material.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';

class ApprovedVoidedTransactionsPage extends StatefulWidget {
  const ApprovedVoidedTransactionsPage({Key? key}) : super(key: key);

  @override
  _ApprovedVoidedTransactionsPageState createState() =>
      _ApprovedVoidedTransactionsPageState();
}

class _ApprovedVoidedTransactionsPageState
    extends State<ApprovedVoidedTransactionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(title: 'Approved Voided Transactions'),
      body: Container(),
    );
  }
}

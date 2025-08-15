import 'package:flutter/material.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';

class PendingVoidedTransactionsPage extends StatefulWidget {
  const PendingVoidedTransactionsPage({Key? key}) : super(key: key);

  @override
  _PendingVoidedTransactionsPageState createState() =>
      _PendingVoidedTransactionsPageState();
}

class _PendingVoidedTransactionsPageState
    extends State<PendingVoidedTransactionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(title: 'Pending Voided Transactions'),
      body: Container(),
    );
  }
}

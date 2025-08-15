import 'package:flutter/material.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';

class DeclinedVoidedTransactionsPage extends StatefulWidget {
  const DeclinedVoidedTransactionsPage({Key? key}) : super(key: key);

  @override
  _DeclinedVoidedTransactionsPageState createState() =>
      _DeclinedVoidedTransactionsPageState();
}

class _DeclinedVoidedTransactionsPageState
    extends State<DeclinedVoidedTransactionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(title: 'Declined Voided Transactions'),
      body: Container(),
    );
  }
}

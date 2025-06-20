import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../routes/routes.dart';
import '../../../../utils/dimensions.dart';
import '../../../../utils/styles.dart';
import 'confirmation_dialog.dart';


class SignOutConfirmationDialog extends StatelessWidget {
  const SignOutConfirmationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      title: "Sign Out",
      message: "Are you sure you want to sign out?",
      icon: Icons.error_outline,
      positiveText: "YES",
      negativeText: "NO",
      onPositive: () {

      },
      iconColor: Theme.of(context).primaryColor,
    );
  }
}


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../routes/routes.dart';
import '../../../../utils/dimensions.dart';
import '../../../../utils/styles.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String positiveText;
  final String negativeText;
  final VoidCallback onPositive;
  final VoidCallback? onNegative;
  final Color? iconColor;
  final bool isLoading;

  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.icon,
    required this.positiveText,
    required this.negativeText,
    required this.onPositive,
    this.onNegative,
    this.iconColor,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 300,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 30,
            backgroundColor: iconColor ?? Theme.of(context).primaryColor,
            child: Icon(icon, size: 50, color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Column(
              children: [
                Text(title, style: rubikBold, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(message, style: rubikMedium, textAlign: TextAlign.center),
              ],
            ),
          ),
          Container(height: 0.5, color: Theme.of(context).hintColor),
          !isLoading ? Row(children: [
            Expanded(child: InkWell(
              onTap: onPositive,
              child: Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                alignment: Alignment.center,
                decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
                child: Text(positiveText, style: rubikBold.copyWith(color: Theme.of(context).primaryColor)),
              ),
            )),
            Expanded(child: InkWell(
              onTap: onNegative ?? () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10)),
                ),
                child: Text(negativeText, style: rubikBold.copyWith(color: Colors.white)),
              ),
            )),
          ]) : Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          ),
        ]),
      ),
    );
  }
}

// For backward compatibility
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
        // Provider.of<AuthenticatedAppProviders>(context, listen: false)
        //     .clearSharedData()
        //     .then((condition) {
        //   Navigator.pushNamedAndRemoveUntil(context, AppRoutes.getSplashPageRoute(), (route) => false);
        // });
      },
      iconColor: Theme.of(context).primaryColor,
    );
  }
}

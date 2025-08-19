import 'package:flutter/material.dart';
import 'package:zed_nano/utils/Colors.dart';

class CustomExtendedFAB extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;
  final double? iconSize;
  final TextStyle? labelStyle;

  const CustomExtendedFAB({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor = Colors.white,
    this.textColor = Colors.white,
    this.iconSize = 24,
    this.labelStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: backgroundColor ?? appThemePrimary,
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: iconColor,
        size: iconSize,
      ),
      label: Text(
        label,
        style: labelStyle ?? TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// Predefined common FABs for specific use cases
class GeneratePdfFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final String? customLabel;

  const GeneratePdfFAB({
    Key? key,
    required this.onPressed,
    this.customLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomExtendedFAB(
      label: customLabel ?? 'Generate PDF',
      icon: Icons.document_scanner,
      onPressed: onPressed,
    );
  }
}

class ExportReportFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final String? customLabel;

  const ExportReportFAB({
    Key? key,
    required this.onPressed,
    this.customLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomExtendedFAB(
      label: customLabel ?? 'Export Report',
      icon: Icons.file_download,
      onPressed: onPressed,
    );
  }
}

class ShareReportFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final String? customLabel;

  const ShareReportFAB({
    Key? key,
    required this.onPressed,
    this.customLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomExtendedFAB(
      label: customLabel ?? 'Share Report',
      icon: Icons.share,
      onPressed: onPressed,
    );
  }
}

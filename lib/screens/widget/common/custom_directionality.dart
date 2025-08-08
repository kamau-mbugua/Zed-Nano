import 'package:flutter/material.dart';

class CustomDirectionality extends StatelessWidget {
  const CustomDirectionality({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.ltr, child: child);
  }
}
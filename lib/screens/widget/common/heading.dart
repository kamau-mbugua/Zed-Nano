import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';

Widget headings({required String label,required String subLabel}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 8),
      Text(
        label,
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
          color: Color(0xFF1F2024),
        ),
      ),
      4.height,
      Text(
        subLabel,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: 'Poppins',
          color: Color(0xFF8A8D9F),
        ),
      ),
      18.height,
    ]
  );
}
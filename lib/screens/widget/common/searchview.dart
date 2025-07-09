import 'package:flutter/material.dart';

Widget buildSearchBar({
  required TextEditingController controller,
  required Function(String) onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Container(
      height: 48, // Fixed height for better control
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6), // light grey background
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center( // Center the TextField vertically
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
          ),
          decoration: InputDecoration(
            isDense: true, // Makes the input field more compact
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            hintText: 'Search category',
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontFamily: 'Poppins',
            ),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 12, right: 8),
              child: Icon(Icons.search, color: Color(0xFF7C7C7C)),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 40,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    ),
  );
}

import 'package:flutter/material.dart';

/// A flexible RichText widget that allows you to specify different colors
/// for different text segments.
class FlexibleRichText extends StatelessWidget {
  /// List of text segments with their respective colors
  final List<TextSegment> segments;
  
  /// The font size for the text.
  final double fontSize;
  
  /// The font family for the text.
  final String fontFamily;
  
  /// The font weight for the text.
  final FontWeight fontWeight;
  
  /// Text alignment
  final TextAlign textAlign;

  /// Creates a [FlexibleRichText] widget.
  ///
  /// The [segments] list should contain [TextSegment] objects with
  /// text and color for each segment.
  const FlexibleRichText({
    Key? key,
    required this.segments,
    this.fontSize = 14,
    this.fontFamily = 'Poppins',
    this.fontWeight = FontWeight.w400,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: segments.map((segment) => TextSpan(
          text: segment.text,
          style: TextStyle(
            color: segment.color,
            fontSize: fontSize,
            fontFamily: fontFamily,
            fontWeight: fontWeight,
          ),
        )).toList(),
      ),
      textAlign: textAlign,
    );
  }

  /// Factory constructor for Supplier information
  /// Usage: FlexibleRichText.supplier("Malki and Sons General Supplies", context)
  factory FlexibleRichText.supplier(String supplierName, BuildContext context) {
    return FlexibleRichText(
      segments: [
        TextSegment(
          text: 'Supplier: ',
          color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey,
        ),
        TextSegment(
          text: supplierName,
          color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
        ),
      ],
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
  }

  /// Factory constructor for label-value pairs
  /// Usage: FlexibleRichText.labelValue("Status: ", "Active", context)
  factory FlexibleRichText.labelValue(
    String label, 
    String value, 
    BuildContext context, {
    Color? labelColor,
    Color? valueColor,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return FlexibleRichText(
      segments: [
        TextSegment(
          text: label,
          color: labelColor ?? Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey,
        ),
        TextSegment(
          text: value,
          color: valueColor ?? Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
        ),
      ],
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }
}

/// A data class to represent a text segment with its color
class TextSegment {
  final String text;
  final Color color;

  const TextSegment({
    required this.text,
    required this.color,
  });
}

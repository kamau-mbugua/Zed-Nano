import 'package:flutter/material.dart';

/// A reusable widget that displays rich text with alternating normal and highlighted text.
/// 
/// This widget allows you to create a text pattern where some words are highlighted
/// in a different color (typically used for emphasis in headings or important text).
class HighlightedRichText extends StatelessWidget {
  
  /// Creates a [HighlightedRichText] widget.
  ///
  /// The [textSegments] list should contain the text segments to display,
  /// where even-indexed items (0, 2, 4, ...) will be displayed in [normalColor]
  /// and odd-indexed items (1, 3, 5, ...) will be displayed in [highlightColor].
  const HighlightedRichText({
    required this.textSegments, super.key,
    this.normalColor = Colors.black,
    this.highlightColor = const Color(0xffdc3545),
    this.fontSize = 28,
    this.fontFamily = 'Poppins',
    this.fontWeight = FontWeight.w600,
  });

  factory HighlightedRichText.connectingBusinesses() {
    return const HighlightedRichText(
      textSegments: [
        'Connecting \n',
        'Businesses',
        ' to\n',
        'Payments',
      ],
    );
  }
  /// List of text segments to be displayed.
  /// Each segment alternates between normal and highlighted text.
  final List<String> textSegments;
  
  /// The color for the normal (non-highlighted) text.
  final Color normalColor;
  
  /// The color for the highlighted text segments.
  final Color highlightColor;
  
  /// The font size for the text.
  final double fontSize;
  
  /// The font family for the text.
  final String fontFamily;
  
  /// The font weight for the text.
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: _buildTextSpans(),
      ),
      style: TextStyle(
        color: normalColor,
        fontSize: fontSize,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
      ),
    );
  }

  List<TextSpan> _buildTextSpans() {
    final spans = <TextSpan>[];
    
    for (var i = 0; i < textSegments.length; i++) {
      final isHighlighted = i % 2 == 1; // Odd indices are highlighted
      
      spans.add(
        TextSpan(
          text: textSegments[i],
          style: TextStyle(
            color: isHighlighted ? highlightColor : normalColor,
            fontSize: fontSize,
            fontFamily: fontFamily,
            fontWeight: fontWeight,
          ),
        ),
      );
    }
    
    return spans;
  }
}

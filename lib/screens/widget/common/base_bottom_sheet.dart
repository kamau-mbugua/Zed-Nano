import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

/// A base bottom sheet widget that can be extended for various use cases.
/// This widget provides a consistent structure for bottom sheets in the app.
class BaseBottomSheet extends StatelessWidget {
  /// Title displayed at the top of the bottom sheet
  final String title;
  
  /// Whether to show the close button
  final bool showCloseButton;
  
  /// Initial size of the bottom sheet (0.0 to 1.0)
  final double initialChildSize;
  
  /// Minimum size of the bottom sheet (0.0 to 1.0)
  final double minChildSize;
  
  /// Maximum size of the bottom sheet (0.0 to 1.0)
  final double maxChildSize;
  
  /// Widget displayed in the header area (below title)
  final Widget? headerContent;
  
  /// Main content of the bottom sheet
  final Widget bodyContent;
  
  /// Padding for the bottom sheet content
  final EdgeInsets contentPadding;
  
  /// Background color of the bottom sheet
  final Color backgroundColor;
  
  /// Border radius for the top of the bottom sheet
  final BorderRadius borderRadius;
  
  /// Callback when close button is pressed
  final VoidCallback? onClose;

  const BaseBottomSheet({
    Key? key,
    required this.title,
    this.showCloseButton = true,
    this.initialChildSize = 0.9,
    this.minChildSize = 0.5,
    this.maxChildSize = 1.0,
    this.headerContent,
    required this.bodyContent,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.backgroundColor = Colors.white,
    this.borderRadius = const BorderRadius.vertical(top: Radius.circular(20)),
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      builder: (context, scrollController) {
        return Container(
          padding: contentPadding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 16),
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xffe0e0e0),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              
              // Title and close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Color(0xff1f2024),
                    ),
                  ),
                  if (showCloseButton)
                    GestureDetector(
                      onTap: () {
                        if (onClose != null) {
                          onClose!();
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: const Icon(
                        Icons.close,
                        color: Color(0xff032541),
                        size: 20,
                      ),
                    ),
                ],
              ).paddingTop(14),
              
              const SizedBox(height: 10),
              
              // Optional header content
              if (headerContent != null) ...[
                headerContent!,
                const SizedBox(height: 10),
              ],
              
              // Main content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: bodyContent,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

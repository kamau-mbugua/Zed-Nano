import 'package:flutter/material.dart';
import 'package:zed_nano/screens/widget/common/reusable_stepper_widget.dart';
import 'package:zed_nano/utils/Colors.dart';

/// Base widget for stepper step pages
/// Provides common layout and navigation functionality
class StepperStepPage extends StatelessWidget {
  /// Main content of the step
  final Widget child;
  
  /// Title of the step (optional)
  final String? title;
  
  /// Subtitle/description of the step (optional)
  final String? subtitle;
  
  /// Custom next button text (default: "Next")
  final String? nextButtonText;
  
  /// Custom previous button text (default: "Previous")
  final String? previousButtonText;
  
  /// Whether to show the next button (default: true)
  final bool showNextButton;
  
  /// Whether to show the previous button (default: true)
  final bool showPreviousButton;
  
  /// Custom validation before moving to next step
  final bool Function()? canProceed;
  
  /// Custom action when next is pressed (if null, uses default stepper navigation)
  final VoidCallback? onNext;
  
  /// Custom action when previous is pressed (if null, uses default stepper navigation)
  final VoidCallback? onPrevious;
  
  /// Whether the next button should be enabled (default: true)
  final bool nextButtonEnabled;
  
  /// Loading state for next button
  final bool isLoading;
  
  /// Custom next button widget (overrides default button)
  final Widget? customNextButton;
  
  /// Custom previous button widget (overrides default button)
  final Widget? customPreviousButton;
  
  /// Additional actions to show in the button row
  final List<Widget>? additionalActions;

  const StepperStepPage({
    Key? key,
    required this.child,
    this.title,
    this.subtitle,
    this.nextButtonText,
    this.previousButtonText,
    this.showNextButton = true,
    this.showPreviousButton = true,
    this.canProceed,
    this.onNext,
    this.onPrevious,
    this.nextButtonEnabled = true,
    this.isLoading = false,
    this.customNextButton,
    this.customPreviousButton,
    this.additionalActions,
  }) : super(key: key);

  void _handleNext(BuildContext context) {
    if (canProceed != null && !canProceed!()) {
      return;
    }
    
    if (onNext != null) {
      onNext!();
    } else {
      StepperController.nextStep(context);
    }
  }

  void _handlePrevious(BuildContext context) {
    if (onPrevious != null) {
      onPrevious!();
    } else {
      StepperController.previousStep(context);
    }
  }

  Widget _buildDefaultNextButton(BuildContext context) {
    final isLastStep = StepperController.isLastStep(context);
    
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: nextButtonEnabled && !isLoading ? () => _handleNext(context) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: appThemePrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              nextButtonText ?? (isLastStep ? "Complete" : "Next"),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
      ),
    );
  }

  Widget _buildDefaultPreviousButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: () => _handlePrevious(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: appThemePrimary,
          side: BorderSide(color: appThemePrimary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          previousButtonText ?? "Previous",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header section
        if (title != null || subtitle != null) ...[
          if (title != null)
            Text(
              title!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: textPrimary,
              ),
            ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                color: textPrimary,
              ),
            ),
          ],
          const SizedBox(height: 24),
        ],
        
        // Main content
        Expanded(child: child),
        
        // Button section
        if (showNextButton || showPreviousButton || additionalActions != null) ...[
          const SizedBox(height: 16),
          Column(
            children: [
              // Additional actions
              if (additionalActions != null) ...[
                Row(
                  children: additionalActions!,
                ),
                const SizedBox(height: 12),
              ],
              
              // Navigation buttons
              if (showNextButton && showPreviousButton) ...[
                // Both buttons in a row
                Row(
                  children: [
                    Expanded(
                      child: customPreviousButton ?? _buildDefaultPreviousButton(context),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: customNextButton ?? _buildDefaultNextButton(context),
                    ),
                  ],
                ),
              ] else if (showNextButton) ...[
                // Only next button
                customNextButton ?? _buildDefaultNextButton(context),
              ] else if (showPreviousButton) ...[
                // Only previous button
                customPreviousButton ?? _buildDefaultPreviousButton(context),
              ],
            ],
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}

/// Simplified version for basic step pages
class SimpleStepperStepPage extends StatelessWidget {
  final Widget child;
  final String? title;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final bool canProceed;

  const SimpleStepperStepPage({
    Key? key,
    required this.child,
    this.title,
    this.onNext,
    this.onPrevious,
    this.canProceed = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StepperStepPage(
      title: title,
      onNext: onNext,
      onPrevious: onPrevious,
      canProceed: () => canProceed,
      child: child,
    );
  }
}

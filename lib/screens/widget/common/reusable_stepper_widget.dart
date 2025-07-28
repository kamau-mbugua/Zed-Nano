import 'package:flutter/material.dart';
import 'package:zed_nano/utils/Colors.dart';

/// A reusable stepper widget that manages multi-step flows
/// 
/// Features:
/// - Customizable step indicator
/// - Page navigation management
/// - Callback support for step changes
/// - Flexible step content
/// - Consistent styling
class ReusableStepperWidget extends StatefulWidget {
  /// List of step pages/widgets to display
  final List<Widget> steps;
  
  /// Initial step index (default: 0)
  final int initialStep;
  
  /// Callback when step changes
  final Function(int currentStep)? onStepChanged;
  
  /// Callback when stepper is completed (reaches last step)
  final VoidCallback? onCompleted;
  
  /// Callback when stepper is cancelled/back pressed from first step
  final VoidCallback? onCancelled;
  
  /// Custom background color (default: colorBackground)
  final Color? backgroundColor;
  
  /// Custom step indicator colors
  final Color? activeStepColor;
  final Color? inactiveStepColor;
  
  /// Custom padding around the content
  final EdgeInsets? contentPadding;
  
  /// Custom padding around the step indicator
  final EdgeInsets? indicatorPadding;
  
  /// Height of the step indicator bars
  final double? indicatorHeight;
  
  /// Whether to show step numbers instead of progress bars
  final bool showStepNumbers;
  
  /// Custom step titles (optional)
  final List<String>? stepTitles;

  /// Data to be passed between steps
  final Map<String, dynamic>? stepData;

  /// Callback when step data changes
  final Function(Map<String, dynamic>)? onStepDataChanged;

  const ReusableStepperWidget({
    Key? key,
    required this.steps,
    this.initialStep = 0,
    this.onStepChanged,
    this.onCompleted,
    this.onCancelled,
    this.backgroundColor,
    this.activeStepColor,
    this.inactiveStepColor,
    this.contentPadding,
    this.indicatorPadding,
    this.indicatorHeight,
    this.showStepNumbers = false,
    this.stepTitles,
    this.stepData,
    this.onStepDataChanged,
  }) : super(key: key);

  @override
  State<ReusableStepperWidget> createState() => _ReusableStepperWidgetState();
}

class _ReusableStepperWidgetState extends State<ReusableStepperWidget> {
  late int currentStep;
  late Map<String, dynamic> _stepData;

  @override
  void initState() {
    super.initState();
    currentStep = widget.initialStep;
    _stepData = widget.stepData ?? {};
  }

  /// Navigate to next step
  void goToNextStep() {
    if (currentStep < widget.steps.length - 1) {
      setState(() {
        currentStep += 1;
      });
      widget.onStepChanged?.call(currentStep);
    } else {
      // Reached the end
      widget.onCompleted?.call();
    }
  }

  /// Navigate to previous step
  void goToPreviousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep -= 1;
      });
      widget.onStepChanged?.call(currentStep);
    } else {
      // At the beginning
      widget.onCancelled?.call();
    }
  }

  /// Navigate to specific step
  void goToStep(int step) {
    if (step >= 0 && step < widget.steps.length) {
      setState(() {
        currentStep = step;
      });
      widget.onStepChanged?.call(currentStep);
    }
  }

  // skip and close
  void skipAndClose() {
    widget.onCancelled?.call();
  }

  /// Update step data
  void updateStepData(Map<String, dynamic> data) {
    setState(() {
      _stepData = data;
    });
    widget.onStepDataChanged?.call(data);
  }

  /// Build progress bar style indicator
  Widget _buildProgressIndicator() {
    return Row(
      children: List.generate(widget.steps.length, (index) {
        final isActive = index <= currentStep;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            height: widget.indicatorHeight ?? 5,
            decoration: BoxDecoration(
              color: isActive 
                ? (widget.activeStepColor ?? const Color(0xff00c382))
                : (widget.inactiveStepColor ?? const Color(0xffe4e4ed)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }),
    );
  }

  /// Build numbered step indicator
  Widget _buildNumberedIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.steps.length, (index) {
        final isActive = index <= currentStep;
        final isCurrent = index == currentStep;
        
        return Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isActive 
                  ? (widget.activeStepColor ?? const Color(0xff00c382))
                  : (widget.inactiveStepColor ?? const Color(0xffe4e4ed)),
                shape: BoxShape.circle,
                border: isCurrent ? Border.all(
                  color: widget.activeStepColor ?? const Color(0xff00c382),
                  width: 2,
                ) : null,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.grey[600],
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            if (widget.stepTitles != null && index < widget.stepTitles!.length) ...[
              const SizedBox(height: 8),
              Text(
                widget.stepTitles![index],
                style: TextStyle(
                  fontSize: 12,
                  color: isActive 
                    ? (widget.activeStepColor ?? const Color(0xff00c382))
                    : Colors.grey[600],
                  fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor ?? colorBackground,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: widget.indicatorPadding ?? const EdgeInsets.symmetric(horizontal: 16.0),
              child: widget.showStepNumbers 
                ? _buildNumberedIndicator()
                : _buildProgressIndicator(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 16.0),
                child: _StepperContent(
                  child: widget.steps[currentStep],
                  onNext: goToNextStep,
                  onPrevious: goToPreviousStep,
                  onGoToStep: goToStep,
                  currentStep: currentStep,
                  skipAndClose: skipAndClose,
                  totalSteps: widget.steps.length,
                  stepData: _stepData,
                  updateStepData: updateStepData,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Wrapper widget that provides stepper context to child widgets
class _StepperContent extends InheritedWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final Function(int) onGoToStep;
  final int currentStep;
  final int totalSteps;
  final VoidCallback skipAndClose;
  final Map<String, dynamic> stepData;
  final Function(Map<String, dynamic>) updateStepData;

  const _StepperContent({
    required Widget child,
    required this.onNext,
    required this.onPrevious,
    required this.onGoToStep,
    required this.currentStep,
    required this.totalSteps,
    required this.skipAndClose,
    required this.stepData,
    required this.updateStepData,
  }) : super(child: child);

  static _StepperContent? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_StepperContent>();
  }

  @override
  bool updateShouldNotify(_StepperContent oldWidget) {
    return currentStep != oldWidget.currentStep || stepData != oldWidget.stepData;
  }
}

/// Helper class to access stepper functions from child widgets
class StepperController {
  static void nextStep(BuildContext context) {
    final stepperContent = _StepperContent.of(context);
    stepperContent?.onNext();
  }

  static void previousStep(BuildContext context) {
    final stepperContent = _StepperContent.of(context);
    stepperContent?.onPrevious();
  }

  static void goToStep(BuildContext context, int step) {
    final stepperContent = _StepperContent.of(context);
    stepperContent?.onGoToStep(step);
  }

  static void skipAndClose(BuildContext context) {
    final stepperContent = _StepperContent.of(context);
    stepperContent?.skipAndClose();
  }

  static int getCurrentStep(BuildContext context) {
    final stepperContent = _StepperContent.of(context);
    return stepperContent?.currentStep ?? 0;
  }

  static int getTotalSteps(BuildContext context) {
    final stepperContent = _StepperContent.of(context);
    return stepperContent?.totalSteps ?? 0;
  }

  static bool isFirstStep(BuildContext context) {
    return getCurrentStep(context) == 0;
  }

  static bool isLastStep(BuildContext context) {
    final stepperContent = _StepperContent.of(context);
    return stepperContent?.currentStep == (stepperContent?.totalSteps ?? 1) - 1;
  }

  static Map<String, dynamic> getStepData(BuildContext context) {
    final stepperContent = _StepperContent.of(context);
    return stepperContent?.stepData ?? {};
  }

  static void updateStepData(BuildContext context, Map<String, dynamic> data) {
    final stepperContent = _StepperContent.of(context);
    stepperContent?.updateStepData(data);
  }
}

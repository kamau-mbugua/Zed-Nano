import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class FlutterHorizontalSteppers extends StatefulWidget {
  const FlutterHorizontalSteppers({
    super.key,
    required this.steps,
    required this.radius,
    required this.currentStep,
    required this.circleWidgets,
    required this.stepContents,
    this.titleStyle,
    this.inActiveStepColor = Colors.grey,
    this.currentStepColor = Colors.blue,
    this.completeStepColor = Colors.green,
    this.thickness = 1,
    this.onClick,
  })  : assert(currentStep <= steps.length),
        assert(steps.length > 1 && steps.length < 7),
        assert(currentStep > 0),
        assert(radius >= 45 && radius <= 90),
        assert(thickness > 0 && thickness < 6),
        assert(circleWidgets.length == steps.length),
        assert(stepContents.length == steps.length);

  /// Step labels
  final List<String> steps;

  /// Circle size (radius between 45 to 90)
  final double radius;

  /// Current active step (1-based index)
  final int currentStep;

  /// Widgets to display inside the step circles
  final List<Widget> circleWidgets;

  /// Actual content of each step (like pages)
  final List<Widget> stepContents;

  /// Style for step titles
  final TextStyle? titleStyle;

  /// Color for inactive steps
  final Color inActiveStepColor;

  /// Color for current active step
  final Color currentStepColor;

  /// Color for completed steps
  final Color completeStepColor;

  /// Thickness of the stepper line
  final double thickness;

  /// Click listener for steps
  final Function(int)? onClick;

  @override
  State<FlutterHorizontalSteppers> createState() =>
      _FlutterHorizontalStepperState();
}

class _FlutterHorizontalStepperState extends State<FlutterHorizontalSteppers> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Stack(
            children: [
              // The connecting lines
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int i = 0; i < widget.steps.length - 1; i++) ...{
                    Flexible(
                      child: Container(
                        color: getStatusColor(i),
                        margin: EdgeInsets.only(
                          top: widget.radius / 2,
                          left: i == 0 ? widget.radius : 0,
                          right: i == widget.steps.length - 2
                              ? widget.radius
                              : 0,
                        ),
                        height: widget.thickness,
                      ),
                    ),
                  },
                ],
              ),
              // The step circles & titles
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int i = 0; i < widget.steps.length; i++) ...{
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            child: Container(
                              height: widget.radius,
                              width: widget.radius,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: getStatusColor(i),
                                shape: BoxShape.circle,
                              ),
                              child: getStatusWidget(i),
                            ),
                            onTap: () {
                              if (widget.onClick != null) {
                                if (getStatusColor(i) !=
                                    widget.inActiveStepColor) {
                                  widget.onClick!(i);
                                }
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.steps[i].split(' ').join('\n'),
                            textAlign: TextAlign.center,
                            style: widget.titleStyle,
                          )
                        ],
                      ),
                    )
                  },
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Display the current step content below the stepper
        Expanded(
          child: widget.stepContents[widget.currentStep - 1],
        ),
      ],
    );
  }

  Color getStatusColor(int index) {
    if (index + 1 == widget.currentStep) {
      return widget.currentStepColor;
    } else if (index + 1 < widget.currentStep) {
      return widget.completeStepColor;
    }
    return widget.inActiveStepColor;
  }

  Widget getStatusWidget(int index) {
    if (index + 1 < widget.currentStep) {
      return const Icon(Icons.check, color: Colors.white);
    }
    return widget.circleWidgets[index];
  }
}

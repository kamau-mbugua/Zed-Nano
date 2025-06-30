import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A customizable fading circular progress indicator widget.
/// 
/// This widget creates a circular progress indicator with a fading effect,
/// similar to a conic gradient animation. It can be customized with different
/// colors, sizes, and can optionally include a shadow effect.
class FadingCircularProgress extends StatefulWidget {
  /// The width of the progress indicator.
  final double width;
  
  /// The height of the progress indicator.
  final double height;
  
  /// The color of the progress indicator.
  final Color color;
  
  /// The background color of the progress indicator.
  final Color backgroundColor;
  
  /// The width of the stroke.
  final double strokeWidth;
  
  /// The duration of one complete animation cycle.
  final Duration duration;
  
  /// Whether to show a shadow effect.
  final bool showShadow;
  
  /// The color of the shadow, if enabled.
  final Color? shadowColor;
  
  /// The blur radius of the shadow, if enabled.
  final double shadowBlurRadius;
  
  /// The offset of the shadow, if enabled.
  final Offset shadowOffset;

  const FadingCircularProgress({
    Key? key,
    this.width = 140,
    this.height = 140,
    this.color = const Color(0xff032541),
    this.backgroundColor = const Color(0xffe8edf1),
    this.strokeWidth = 10,
    this.duration = const Duration(seconds: 2),
    this.showShadow = false,
    this.shadowColor,
    this.shadowBlurRadius = 10,
    this.shadowOffset = const Offset(0, 4),
  }) : super(key: key);

  @override
  State<FadingCircularProgress> createState() => _FadingCircularProgressState();
}

class _FadingCircularProgressState extends State<FadingCircularProgress> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: FadingCircularProgressPainter(
              progress: _controller.value,
              color: widget.color,
              backgroundColor: widget.backgroundColor,
              strokeWidth: widget.strokeWidth,
              showShadow: widget.showShadow,
              shadowColor: widget.shadowColor ?? widget.color.withOpacity(0.3),
              shadowBlurRadius: widget.shadowBlurRadius,
              shadowOffset: widget.shadowOffset,
            ),
          );
        },
      ),
    );
  }
}

/// Custom painter for the fading circular progress indicator.
class FadingCircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;
  final bool showShadow;
  final Color shadowColor;
  final double shadowBlurRadius;
  final Offset shadowOffset;

  FadingCircularProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
    required this.showShadow,
    required this.shadowColor,
    required this.shadowBlurRadius,
    required this.shadowOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - strokeWidth / 2;
    
    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    
    canvas.drawCircle(center, radius, backgroundPaint);
    
    // Draw progress arc with gradient
    final rect = Rect.fromCircle(center: center, radius: radius);
    
    // Create a shader that transitions from transparent to solid color
    final gradient = SweepGradient(
      center: Alignment.center,
      startAngle: 0,
      endAngle: math.pi * 2,
      tileMode: TileMode.repeated,
      colors: [
        color.withOpacity(0.0),
        color.withOpacity(0.0),
        color,
      ],
      stops: const [0.0, 0.0001, 1.0],
      transform: GradientRotation(-math.pi / 2 + 2 * math.pi * progress),
    );
    
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    
    if (showShadow) {
      // Add shadow to the progress arc
      canvas.saveLayer(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint(),
      );
      
      // Draw shadow
      final shadowPaint = Paint()
        ..color = shadowColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlurRadius);
      
      canvas.save();
      canvas.translate(shadowOffset.dx, shadowOffset.dy);
      canvas.drawCircle(center, radius, shadowPaint);
      canvas.restore();
      
      // Draw actual progress with gradient
      progressPaint.shader = gradient.createShader(rect);
      canvas.drawCircle(center, radius, progressPaint);
      
      canvas.restore();
    } else {
      // Draw without shadow
      progressPaint.shader = gradient.createShader(rect);
      canvas.drawCircle(center, radius, progressPaint);
    }
    
    // Draw the small circle indicator at the end of the progress
    final indicatorPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    if (showShadow) {
      // Add shadow to the indicator
      final indicatorShadowPaint = Paint()
        ..color = shadowColor
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlurRadius / 2);
      
      final indicatorPosition = Offset(
        center.dx + radius * math.cos(2 * math.pi * progress - math.pi / 2),
        center.dy + radius * math.sin(2 * math.pi * progress - math.pi / 2),
      );
      
      canvas.save();
      canvas.translate(shadowOffset.dx / 2, shadowOffset.dy / 2);
      canvas.drawCircle(indicatorPosition, strokeWidth / 2, indicatorShadowPaint);
      canvas.restore();
    }
    
    final indicatorPosition = Offset(
      center.dx + radius * math.cos(2 * math.pi * progress - math.pi / 2),
      center.dy + radius * math.sin(2 * math.pi * progress - math.pi / 2),
    );
    
    canvas.drawCircle(indicatorPosition, strokeWidth / 2, indicatorPaint);
  }

  @override
  bool shouldRepaint(FadingCircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.showShadow != showShadow ||
        oldDelegate.shadowColor != shadowColor ||
        oldDelegate.shadowBlurRadius != shadowBlurRadius ||
        oldDelegate.shadowOffset != shadowOffset;
  }
}

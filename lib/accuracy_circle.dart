library;

import 'dart:math' as math;
import 'package:flutter/material.dart';

class AccuracyCircle extends StatefulWidget {
  final int percentage;
  final double size;
  final double strokeWidth;
  final Color progressColor;
  final Color backgroundColor;
  final Duration animationDuration;

  const AccuracyCircle({
    super.key,
    required this.percentage,
    this.size = 50,
    this.strokeWidth = 6,
    this.progressColor = const Color(0xff4F378A),
    this.backgroundColor = const Color(0xffE8DEF8),
    this.animationDuration = const Duration(milliseconds: 1500),
  });

  @override
  State<AccuracyCircle> createState() => _AccuracyCircleState();
}

class _AccuracyCircleState extends State<AccuracyCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double animatedProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _animation =
        Tween<double>(begin: 0.0, end: widget.percentage / 100).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        )..addListener(() {
          setState(() => animatedProgress = _animation.value);
        });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: CircularProgressPainter(
              progress: animatedProgress,
              backgroundColor: widget.backgroundColor,
              progressColor: widget.progressColor,
              strokeWidth: widget.strokeWidth,
            ),
          ),
          Text(
            '${widget.percentage}%',
            style: TextStyle(
              fontSize: widget.size * 0.25,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  static const double gapAngle = 12.0;

  CircularProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2;
    const sweepTotal = 2 * math.pi;
    final gap = gapAngle * math.pi / 180;

    if (progress >= 1.0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepTotal,
        false,
        fgPaint,
      );
      return;
    }

    double sweepProgress = sweepTotal * progress - gap;
    if (sweepProgress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepProgress,
        false,
        fgPaint,
      );
    }

    // Partie background
    double sweepBg = sweepTotal * (1 - progress) - gap;
    if (sweepBg > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + sweepTotal * progress + gap,
        sweepBg,
        false,
        bgPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CircularProgressPainter old) =>
      old.progress != progress ||
      old.backgroundColor != backgroundColor ||
      old.progressColor != progressColor ||
      old.strokeWidth != strokeWidth;
}

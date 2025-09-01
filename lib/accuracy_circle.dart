library;

import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Un widget qui affiche un cercle de progression avec animation.
///
/// - De 0% à 99% :
///   - Partie non colorée toujours visible.
///   - Séparation avec arrondi aux extrémités.
/// - À 100% :
///   - Cercle complètement colorié.
///   - Pas de séparation, pas d’arrondi.
class AccuracyCircle extends StatefulWidget {
  /// Pourcentage de progression (0–100).
  final int percentage;

  /// Taille du cercle (largeur/hauteur).
  final double size;

  /// Largeur du trait.
  final double strokeWidth;

  /// Couleur du cercle coloré.
  final Color progressColor;

  /// Couleur du fond (partie non colorée).
  final Color backgroundColor;

  const AccuracyCircle({
    super.key,
    required this.percentage,
    this.size = 50,
    this.strokeWidth = 6,
    this.progressColor = const Color(0xff4F378A),
    this.backgroundColor = const Color(0xffE8DEF8),
  });

  @override
  State<AccuracyCircle> createState() => _AccuracyCircleState();
}

class _AccuracyCircleState extends State<AccuracyCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double animatedPercent = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation =
        Tween<double>(begin: 0.0, end: widget.percentage.toDouble()).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        )..addListener(() {
          setState(() {
            animatedPercent = _animation.value;
          });
        });

    // Démarrer après petit délai
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _controller.forward();
    });
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
        children: [
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _AccuracyCirclePainter(
              percentage: animatedPercent,
              strokeWidth: widget.strokeWidth,
              progressColor: widget.progressColor,
              backgroundColor: widget.backgroundColor,
            ),
          ),
          Center(
            child: Text(
              '${widget.percentage}%',
              style: TextStyle(
                fontSize: widget.size * 0.25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccuracyCirclePainter extends CustomPainter {
  final double percentage;
  final double strokeWidth;
  final Color progressColor;
  final Color backgroundColor;

  _AccuracyCirclePainter({
    required this.percentage,
    required this.strokeWidth,
    required this.progressColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Peinture du fond
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Peinture du progrès
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = (percentage >= 100)
          ? StrokeCap
                .butt // bord plat quand 100%
          : StrokeCap.round; // arrondi sinon

    // Dessiner le cercle complet du fond
    canvas.drawCircle(center, radius, backgroundPaint);

    if (percentage <= 0) return;

    // Garde un petit gap si < 100%
    final adjustedPercent = (percentage >= 100)
        ? 1.0
        : (percentage / 100) * 0.98;

    final startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * adjustedPercent;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

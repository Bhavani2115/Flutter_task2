import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Three short purple rays (the little "pop" accent next to titles).
class Sparkle extends StatelessWidget {
  const Sparkle({super.key, this.size = 28, this.angleDeg = 0});
  final double size;
  final double angleDeg;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angleDeg * math.pi / 180,
      child: CustomPaint(size: Size(size, size), painter: _SparklePainter()),
    );
  }
}

class _SparklePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = AppColors.purple
      ..strokeWidth = size.width * 0.11
      ..strokeCap = StrokeCap.round;
    final origin = Offset(size.width / 2, size.height);
    for (final a in [-0.75, 0.0, 0.75]) {
      final dir = Offset(math.sin(a), -math.cos(a));
      canvas.drawLine(origin + dir * size.height * 0.55, origin + dir * size.height * 0.95, p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Dashed circle used as a decoration on the Forgot-password header.
class DashedRing extends StatelessWidget {
  const DashedRing({super.key, required this.size});
  final double size;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size(size, size), painter: _DashedRingPainter());
}

class _DashedRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x885B6EF0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    final path = Path()..addOval(Offset.zero & size);
    for (final m in path.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        canvas.drawPath(m.extractPath(d, d + 6), paint);
        d += 12;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

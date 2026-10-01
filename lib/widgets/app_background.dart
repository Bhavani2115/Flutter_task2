import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Soft lavender background with big blobs, bottom waves and leaves.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const RepaintBoundary(
      child: CustomPaint(size: Size.infinite, painter: _BackgroundPainter()),
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  const _BackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final full = Offset.zero & size;

    // base
    canvas.drawRect(
      full,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF7F8FE), Color(0xFFF1F4FD)],
        ).createShader(full),
    );

    // top-right blobs
    canvas.drawCircle(Offset(w * 0.95, h * 0.10), w * 0.62,
        Paint()..color = const Color(0x40C7CBF6));
    canvas.drawCircle(Offset(w * 1.05, h * 0.07), w * 0.34,
        Paint()..color = const Color(0x30B7BDF4));

    // left soft hill (mid-height)
    final hill = Path()
      ..moveTo(0, h * 0.40)
      ..quadraticBezierTo(w * 0.22, h * 0.34, w * 0.5, h * 0.44)
      ..lineTo(0, h * 0.50)
      ..close();
    canvas.drawPath(hill, Paint()..color = const Color(0x22C9CEF6));

    // bottom waves
    final top = h * 0.80;
    final wave1 = Path()
      ..moveTo(0, top)
      ..cubicTo(w * 0.25, top - h * 0.03, w * 0.55, top + h * 0.06, w, top - h * 0.01)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(
      wave1,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x55D8DAFA), Color(0x99A9B2F6)],
        ).createShader(Rect.fromLTWH(0, top - 40, w, h - top + 40)),
    );

    final top2 = h * 0.88;
    final wave2 = Path()
      ..moveTo(0, top2 + h * 0.02)
      ..cubicTo(w * 0.3, top2 + h * 0.06, w * 0.55, top2 - h * 0.05, w, top2 + h * 0.02)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(
      wave2,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xAA8B8EF2), Color(0xCC6F8BF2)],
        ).createShader(Rect.fromLTWH(0, top2 - 40, w, h - top2 + 40)),
    );

    final top3 = h * 0.94;
    final wave3 = Path()
      ..moveTo(0, top3)
      ..cubicTo(w * 0.35, top3 - h * 0.035, w * 0.65, top3 + h * 0.03, w, top3 - h * 0.02)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(
      wave3,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF7C6FF0), Color(0xFF8AA6F7)],
        ).createShader(Rect.fromLTWH(0, top3 - 40, w, h - top3 + 40)),
    );

    // leaves (bottom-left)
    final base = Offset(w * 0.04, h + 6);
    final len = math.min(w, 520) * 0.34;
    _leaf(canvas, base, len * 0.95, -0.38, const Color(0xFF5B72F0));
    _leaf(canvas, base, len * 1.15, -0.05, const Color(0xFF4F63E8));
    _leaf(canvas, base, len * 0.80, 0.34, const Color(0xFF7A8CF5));
    _leaf(canvas, base, len * 0.60, 0.70, const Color(0xFF6A80F2));
  }

  void _leaf(Canvas canvas, Offset base, double len, double angle, Color color) {
    canvas.save();
    canvas.translate(base.dx, base.dy);
    canvas.rotate(angle);
    final p = Path()
      ..moveTo(0, 0)
      ..cubicTo(-len * 0.30, -len * 0.30, -len * 0.22, -len * 0.80, 0, -len)
      ..cubicTo(len * 0.22, -len * 0.80, len * 0.30, -len * 0.30, 0, 0)
      ..close();
    canvas.drawPath(
      p,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [color.withAlpha(235), color.withAlpha(150)],
        ).createShader(Rect.fromLTWH(-len * 0.3, -len, len * 0.6, len)),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

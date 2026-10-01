import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/ui.dart';

/// Bonus: "Continue with Google / Apple" (design only – no auth wired).
class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('or',
                  style: AppText.style(14, FontWeight.w500, AppColors.hint)),
            ),
            const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
          ],
        ),
        const SizedBox(height: 14),
        _SocialButton(
          label: 'Continue with Google',
          icon: const SizedBox(width: 22, height: 22, child: CustomPaint(painter: _GoogleGPainter())),
          onTap: () => showSnack(context, 'Google sign-in is design only for now'),
        ),
        const SizedBox(height: 12),
        _SocialButton(
          label: 'Continue with Apple',
          icon: const Icon(Icons.apple, size: 26, color: Colors.black),
          onTap: () => showSnack(context, 'Apple sign-in is design only for now'),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: AppColors.border, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          foregroundColor: AppColors.navy,
          padding: const EdgeInsets.symmetric(horizontal: 14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 10),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: AppText.style(
                    15.5,
                    FontWeight.w600,
                    AppColors.navy,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleGPainter extends CustomPainter {
  const _GoogleGPainter();

  double _rad(double d) => d * math.pi / 180;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final stroke = size.width * 0.22;
    final r = size.width / 2 - stroke / 2;
    final rect = Rect.fromCircle(center: c, radius: r);
    Paint p(Color color) => Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    canvas.drawArc(rect, _rad(-40), _rad(-95), false, p(const Color(0xFFEA4335))); // red
    canvas.drawArc(rect, _rad(-135), _rad(-90), false, p(const Color(0xFFFBBC05))); // yellow
    canvas.drawArc(rect, _rad(135), _rad(-90), false, p(const Color(0xFF34A853))); // green
    canvas.drawArc(rect, _rad(45), _rad(-50), false, p(const Color(0xFF4285F4))); // blue
    canvas.drawLine(
      c,
      Offset(c.dx + r + stroke / 2, c.dy),
      Paint()
        ..color = const Color(0xFF4285F4)
        ..strokeWidth = stroke * 0.9,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

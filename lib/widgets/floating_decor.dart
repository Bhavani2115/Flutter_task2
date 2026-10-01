import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'sparkle.dart';

/// "Track Loans" + "Make Payments" tilted glass chips (login & sign-up).
List<Widget> loanChips(double w, {double top1 = 0.04, double top2 = 0.16}) => [
      Positioned(
        right: 14,
        top: w * top1,
        child: Transform.rotate(
          angle: -0.08,
          child: const _InfoChip(
            icon: 'assets/images/icon_chart.png',
            label: 'Track Loans',
          ),
        ),
      ),
      Positioned(
        right: 8,
        top: w * top2,
        child: Transform.rotate(
          angle: -0.08,
          child: const _InfoChip(
            icon: 'assets/images/icon_card.png',
            label: 'Make Payments',
          ),
        ),
      ),
    ];

/// Decor for the Forgot-password header: dashed ring, envelope and shield.
List<Widget> securityBehind(double w) => [
      Positioned(
        right: w * 0.02,
        top: w * 0.37,
        child: DashedRing(size: w * 0.24),
      ),
    ];

List<Widget> securityFloating(double w) => [
      Positioned(
        right: 12,
        top: w * 0.025,
        child: Image.asset('assets/images/icon_shield.png', width: w * 0.18),
      ),
      Positioned(
        right: w * 0.16,
        top: w * 0.07,
        child: Image.asset('assets/images/icon_mail.png', width: w * 0.13),
      ),
    ];

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
  });

  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xF2FFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xE6FFFFFF), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x185B4FE0),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(icon, width: 22, height: 22),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppText.style(
              11.5,
              FontWeight.w600,
              const Color(0xFF2C3250),
              height: 1.2,
            ),
          ),
          const SizedBox(width: 2),
          const Icon(
            Icons.chevron_right_rounded,
            size: 14,
            color: Color(0xB25B6275),
          ),
        ],
      ),
    );
  }
}



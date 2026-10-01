import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Full-width purple→blue pill button with trailing arrow and loading spinner.
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.showArrow = true,
  });

  final String label;
  final VoidCallback onPressed;
  final bool loading;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(28));
    return Container(
      decoration: const BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Color(0x404A5CE8),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: Ink(
          decoration: const BoxDecoration(
            gradient: AppColors.buttonGradient,
            borderRadius: radius,
          ),
          child: InkWell(
            borderRadius: radius,
            onTap: loading ? null : onPressed,
            child: SizedBox(
              height: 54,
              width: double.infinity,
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: loading
                      ? const SizedBox(
                          key: ValueKey('spinner'),
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.8,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          key: const ValueKey('label'),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              label,
                              style: AppText.style(
                                18,
                                FontWeight.w700,
                                Colors.white,
                              ),
                            ),
                            if (showArrow) ...[
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ],
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


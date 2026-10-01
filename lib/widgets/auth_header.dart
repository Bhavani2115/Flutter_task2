import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Header block: logo, 2-line title, subtitle, illustration and floating decor.
///
/// The text column uses the left half of the screen ([textWidth]) and the
/// illustration sits on the right. Floating chips sit neatly in the open area.
class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.w,
    required this.cardTop,
    required this.logoTop,
    required this.logoSize,
    required this.titleTop,
    required this.line1,
    required this.line2,
    required this.subtitle,
    required this.girlSize,
    this.textWidth = 0.50,
    this.titleScale = 0.086,
    this.girlRight = 0.0,
    this.behind = const [],
    this.floating = const [],
    this.onBack,
  });

  final double w;
  final double cardTop; // where the white card starts (fraction of w)
  final double logoTop;
  final double logoSize;
  final double titleTop;
  final String line1;
  final String line2;
  final String subtitle;
  final double girlSize;
  final double textWidth;
  final double titleScale;
  final double girlRight;
  final List<Widget> behind;
  final List<Widget> floating;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final titleSize = w * titleScale;
    final girl = girlSize * w;
    final titleStyle1 = AppText.style(
      titleSize,
      FontWeight.w800,
      AppColors.navy,
      height: 1.05,
      letterSpacing: -0.6,
    );
    final titleStyle2 = AppText.style(
      titleSize,
      FontWeight.w800,
      AppColors.purple,
      height: 1.08,
      letterSpacing: -0.6,
    );

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: SizedBox(
        width: double.infinity,
        height: w * cardTop,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ...behind,
            // Illustration: sits on right, completely within bounds
            Positioned(
              right: w * girlRight,
              bottom: 0,
              width: girl,
              child: Image.asset('assets/images/girl.png', fit: BoxFit.contain),
            ),
            ...floating,
            if (onBack != null)
              Positioned(
                left: 16,
                top: 10,
                child: Material(
                  color: const Color(0xD9FFFFFF),
                  shape: const CircleBorder(),
                  elevation: 2,
                  shadowColor: const Color(0x205B4FE0),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onBack,
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.navy,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              left: 20,
              top: w * logoTop,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(w * logoSize * 0.22),
                child: Image.asset(
                  'assets/images/logo_ez.png',
                  width: w * logoSize,
                  height: w * logoSize,
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: w * titleTop,
              width: w * textWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      line1,
                      style: titleStyle1,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      line2,
                      style: titleStyle2,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ),
                  SizedBox(height: w * 0.02),
                  Text(
                    subtitle,
                    style: AppText.style(
                      w * 0.033,
                      FontWeight.w500,
                      AppColors.textGrey,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


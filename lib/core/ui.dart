import 'package:flutter/material.dart';
import 'app_colors.dart';

void showSnack(BuildContext context, String message, {bool error = false}) {
  final m = ScaffoldMessenger.of(context);
  m.hideCurrentSnackBar();
  m.showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: error ? AppColors.error : AppColors.navy,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    content: Text(message, style: AppText.style(14, FontWeight.w600, Colors.white)),
  ));
}

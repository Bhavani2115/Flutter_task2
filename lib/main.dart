import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/app_colors.dart';
import 'core/scroll_behavior.dart';
import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark, // Android
    statusBarBrightness: Brightness.light, // iOS
  ));
  runApp(const EzLoansApp());
}

class EzLoansApp extends StatelessWidget {
  const EzLoansApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.purple),
      scaffoldBackgroundColor: AppColors.bg,
    );
    return MaterialApp(
      title: 'EZ Loans',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const AppScrollBehavior(),
      theme: base.copyWith(
        textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme),
      ),
      home: const LoginScreen(),
    );
  }
}

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'app_background.dart';

/// Shared page shell: fixed background + smooth scrollable column (max 480 px wide
/// for phone/tablet/web responsive centering) containing a header and a white card.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.header, required this.card});

  /// Builds the header given the effective content width.
  final Widget Function(double w) header;
  final Widget card;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.bg,
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fixed background locked to full screen dimensions so it never squishes when keyboard opens
          Positioned(
            top: 0,
            left: 0,
            width: screenSize.width,
            height: screenSize.height,
            child: const AppBackground(),
          ),
          SafeArea(
            top: true,
            bottom: true,
            child: LayoutBuilder(
              builder: (context, c) {
                final w = math.min(c.maxWidth, 440.0);
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: c.maxHeight,
                    ),
                    child: Center(
                      child: SizedBox(
                        width: w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 8),
                            header(w),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: card,
                            ),
                            SizedBox(
                              height: math.max(24.0, bottomPadding + 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// The big white rounded form card with soft layered shadow.
class AuthCard extends StatelessWidget {
  const AuthCard({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFEFEFF),
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A5B4FE0),
            blurRadius: 36,
            offset: Offset(0, 14),
          ),
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}


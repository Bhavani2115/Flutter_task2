import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_config.dart';
import '../core/validators.dart';
import '../widgets/app_text_field.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/floating_decor.dart';
import '../widgets/gradient_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _emailFocus = FocusNode();
  final _emailKey = GlobalKey();

  bool _emailTouched = false;
  bool _loading = false;
  String? _sentTo;

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus && _email.text.isNotEmpty) {
        setState(() => _emailTouched = true);
      }
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  void _scrollToKey(GlobalKey key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = key.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          alignment: 0.2,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  Future<void> _send() async {
    final emailErr = Validators.email(_email.text);
    if (emailErr != null) {
      setState(() => _emailTouched = true);
      _emailFocus.requestFocus();
      _scrollToKey(_emailKey);
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _loading = true;
      _sentTo = null;
    });
    await Future.delayed(kFakeNetworkDelay);
    if (!mounted) return;
    setState(() {
      _loading = false;
      _sentTo = _email.text.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      header: (w) => AuthHeader(
        w: w,
        cardTop: 0.78,
        logoTop: 0.12,
        logoSize: 0.13,
        titleTop: 0.30,
        line1: 'Forgot',
        line2: 'Password?',
        subtitle:
            "No worries! Enter your email address and we'll send you a reset link.",
        textWidth: 0.48,
        titleScale: 0.086,
        girlSize: 0.54,
        onBack: () => Navigator.of(context).maybePop(),
        behind: securityBehind(w),
        floating: securityFloating(w),
      ),
      card: AuthCard(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                key: _emailKey,
                label: 'Email address',
                hint: 'Enter your email',
                icon: Icons.mail_outline_rounded,
                controller: _email,
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.email],
                autovalidateMode: _emailTouched
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                onChanged: (_) {
                  if (!_emailTouched) setState(() => _emailTouched = true);
                },
                validator: Validators.email,
                onSubmitted: _send,
                bottomGap: 14,
              ),
              if (_sentTo != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF8EF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF86EFAC),
                      width: 1.2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0F16A34A),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.success,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reset link sent!',
                              style: AppText.style(
                                14,
                                FontWeight.w700,
                                const Color(0xFF15803D),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'We sent recovery instructions to $_sentTo. Please check your inbox.',
                              style: AppText.style(
                                13,
                                FontWeight.w500,
                                const Color(0xFF166534),
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 6),
              GradientButton(
                label: 'Send reset link',
                loading: _loading,
                onPressed: _send,
              ),
              const SizedBox(height: 14),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.purple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_back_rounded,
                        size: 20,
                        color: AppColors.purple,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Back to Login',
                        style: AppText.style(
                          15.5,
                          FontWeight.w700,
                          AppColors.purple,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


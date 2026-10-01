import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_config.dart';
import '../core/routes.dart';
import '../core/ui.dart';
import '../core/validators.dart';
import '../widgets/app_text_field.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/floating_decor.dart';
import '../widgets/gradient_button.dart';
import '../widgets/social_buttons.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  final _emailKey = GlobalKey();
  final _passwordKey = GlobalKey();

  bool _emailTouched = false;
  bool _passwordTouched = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus && _email.text.isNotEmpty) {
        setState(() => _emailTouched = true);
      }
    });
    _passwordFocus.addListener(() {
      if (!_passwordFocus.hasFocus && _password.text.isNotEmpty) {
        setState(() => _passwordTouched = true);
      }
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
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

  Future<void> _login() async {
    final emailErr = Validators.email(_email.text);
    final passErr = (_password.text.isEmpty) ? 'Password is required' : null;

    setState(() {
      _emailTouched = true;
      _passwordTouched = true;
    });

    if (emailErr != null) {
      _emailFocus.requestFocus();
      _scrollToKey(_emailKey);
      return;
    }

    if (passErr != null) {
      _passwordFocus.requestFocus();
      _scrollToKey(_passwordKey);
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    await Future.delayed(kFakeNetworkDelay); // fake request: spinner for 2 s
    if (!mounted) return;
    setState(() => _loading = false);
    showSnack(context, 'Login successful (demo)');
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      header: (w) => AuthHeader(
        w: w,
        cardTop: 0.82,
        logoTop: 0.12,
        logoSize: 0.13,
        titleTop: 0.30,
        line1: 'Welcome',
        line2: 'back',
        subtitle: 'Sign in to manage your loans, payments and more.',
        girlSize: 0.58,
        floating: loanChips(w),
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
                autofillHints: const [AutofillHints.email],
                autovalidateMode: _emailTouched
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                onChanged: (_) {
                  if (!_emailTouched) setState(() => _emailTouched = true);
                },
                validator: Validators.email,
              ),
              AppTextField(
                key: _passwordKey,
                label: 'Password',
                hint: 'Enter your password',
                icon: Icons.lock_outline_rounded,
                controller: _password,
                focusNode: _passwordFocus,
                isPassword: true,
                bottomGap: 4,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                autovalidateMode: _passwordTouched
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                onChanged: (_) {
                  if (!_passwordTouched) setState(() => _passwordTouched = true);
                },
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Password is required' : null,
                onSubmitted: _login,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).push(
                    fadeSlideRoute(const ForgotPasswordScreen()),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.purple,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Forgot password?',
                    style: AppText.style(
                      14.5,
                      FontWeight.w700,
                      AppColors.purple,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              GradientButton(
                label: 'Login',
                loading: _loading,
                onPressed: _login,
              ),
              if (kShowSocialButtons) ...[
                const SizedBox(height: 18),
                const SocialButtons(),
              ],
              const SizedBox(height: 14),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: AppText.style(
                        14.5,
                        FontWeight.w500,
                        AppColors.textGrey,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).push(
                        fadeSlideRoute(const SignUpScreen()),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.purple,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Sign up',
                            style: AppText.style(
                              15.5,
                              FontWeight.w700,
                              AppColors.purple,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                            color: AppColors.purple,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


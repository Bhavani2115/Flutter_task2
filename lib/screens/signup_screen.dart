import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_colors.dart';
import '../core/app_config.dart';
import '../core/ui.dart';
import '../core/validators.dart';
import '../widgets/app_text_field.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/floating_decor.dart';
import '../widgets/gradient_button.dart';
import '../widgets/social_buttons.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  final _nameKey = GlobalKey();
  final _emailKey = GlobalKey();
  final _phoneKey = GlobalKey();
  final _passwordKey = GlobalKey();
  final _confirmKey = GlobalKey();
  final _termsKey = GlobalKey();

  bool _nameTouched = false;
  bool _emailTouched = false;
  bool _phoneTouched = false;
  bool _passwordTouched = false;
  bool _confirmTouched = false;
  bool _termsTouched = false;
  bool _loading = false;
  bool _agreed = false;

  @override
  void initState() {
    super.initState();
    _nameFocus.addListener(() {
      if (!_nameFocus.hasFocus && _name.text.isNotEmpty) {
        setState(() => _nameTouched = true);
      }
    });
    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus && _email.text.isNotEmpty) {
        setState(() => _emailTouched = true);
      }
    });
    _phoneFocus.addListener(() {
      if (!_phoneFocus.hasFocus && _phone.text.isNotEmpty) {
        setState(() => _phoneTouched = true);
      }
    });
    _passwordFocus.addListener(() {
      if (!_passwordFocus.hasFocus && _password.text.isNotEmpty) {
        setState(() => _passwordTouched = true);
      }
    });
    _confirmFocus.addListener(() {
      if (!_confirmFocus.hasFocus && _confirm.text.isNotEmpty) {
        setState(() => _confirmTouched = true);
      }
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
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

  Future<void> _signUp() async {
    final nameErr = Validators.required(_name.text, 'Full name');
    final emailErr = Validators.email(_email.text);
    final phoneErr = Validators.phone(_phone.text);
    final passErr = Validators.password(_password.text);
    final confirmErr =
        Validators.confirmPassword(_confirm.text, _password.text);

    if (_agreed) {
      // Checkbox is checked: validate all fields
      setState(() {
        _nameTouched = true;
        _emailTouched = true;
        _phoneTouched = true;
        _passwordTouched = true;
        _confirmTouched = true;
      });

      if (nameErr != null) {
        _nameFocus.requestFocus();
        _scrollToKey(_nameKey);
        return;
      }

      if (emailErr != null) {
        _emailFocus.requestFocus();
        _scrollToKey(_emailKey);
        return;
      }

      if (phoneErr != null) {
        _phoneFocus.requestFocus();
        _scrollToKey(_phoneKey);
        return;
      }

      if (passErr != null) {
        _passwordFocus.requestFocus();
        _scrollToKey(_passwordKey);
        return;
      }

      if (confirmErr != null) {
        _confirmFocus.requestFocus();
        _scrollToKey(_confirmKey);
        return;
      }
    } else {
      // Checkbox is NOT checked: show checkbox warning and only warn for fields the user actually entered
      setState(() {
        _termsTouched = true;
        if (_name.text.isNotEmpty) _nameTouched = true;
        if (_email.text.isNotEmpty) _emailTouched = true;
        if (_phone.text.isNotEmpty) _phoneTouched = true;
        if (_password.text.isNotEmpty) _passwordTouched = true;
        if (_confirm.text.isNotEmpty) _confirmTouched = true;
      });

      if (_name.text.isNotEmpty && nameErr != null) {
        _nameFocus.requestFocus();
        _scrollToKey(_nameKey);
      } else if (_email.text.isNotEmpty && emailErr != null) {
        _emailFocus.requestFocus();
        _scrollToKey(_emailKey);
      } else if (_phone.text.isNotEmpty && phoneErr != null) {
        _phoneFocus.requestFocus();
        _scrollToKey(_phoneKey);
      } else if (_password.text.isNotEmpty && passErr != null) {
        _passwordFocus.requestFocus();
        _scrollToKey(_passwordKey);
      } else if (_confirm.text.isNotEmpty && confirmErr != null) {
        _confirmFocus.requestFocus();
        _scrollToKey(_confirmKey);
      } else {
        _scrollToKey(_termsKey);
      }
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    await Future.delayed(kFakeNetworkDelay);
    if (!mounted) return;
    setState(() => _loading = false);
    showSnack(context, 'Account created (demo). Please log in.');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      header: (w) => AuthHeader(
        w: w,
        cardTop: 0.74,
        logoTop: 0.095,
        logoSize: 0.125,
        titleTop: 0.27,
        line1: 'Create',
        line2: 'Account',
        subtitle: 'Join us and take control of your financial journey.',
        girlSize: 0.54,
        onBack: () => Navigator.of(context).maybePop(),
        floating: loanChips(w, top1: 0.035, top2: 0.155),
      ),
      card: AuthCard(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                key: _nameKey,
                label: 'Full name',
                hint: 'Enter your full name',
                icon: Icons.person_outline_rounded,
                controller: _name,
                focusNode: _nameFocus,
                keyboardType: TextInputType.name,
                autofillHints: const [AutofillHints.name],
                autovalidateMode: _nameTouched
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                onChanged: (_) {
                  if (!_nameTouched) setState(() => _nameTouched = true);
                },
                validator: (v) => Validators.required(v, 'Full name'),
              ),
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
                key: _phoneKey,
                label: 'Phone number',
                hint: 'Enter your phone number',
                icon: Icons.phone_outlined,
                controller: _phone,
                focusNode: _phoneFocus,
                keyboardType: TextInputType.phone,
                autofillHints: const [AutofillHints.telephoneNumber],
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s\-]'))
                ],
                autovalidateMode: _phoneTouched
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                onChanged: (_) {
                  if (!_phoneTouched) setState(() => _phoneTouched = true);
                },
                validator: Validators.phone,
              ),
              AppTextField(
                key: _passwordKey,
                label: 'Password',
                hint: 'Enter your password',
                icon: Icons.lock_outline_rounded,
                controller: _password,
                focusNode: _passwordFocus,
                isPassword: true,
                autovalidateMode: _passwordTouched
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                onChanged: (_) {
                  if (!_passwordTouched) {
                    setState(() => _passwordTouched = true);
                  } else {
                    setState(() {});
                  }
                },
                validator: Validators.password,
              ),
              AppTextField(
                key: _confirmKey,
                label: 'Confirm password',
                hint: 'Confirm your password',
                icon: Icons.lock_outline_rounded,
                controller: _confirm,
                focusNode: _confirmFocus,
                isPassword: true,
                bottomGap: 8,
                textInputAction: TextInputAction.done,
                autovalidateMode: _confirmTouched
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                onChanged: (_) {
                  if (!_confirmTouched) setState(() => _confirmTouched = true);
                },
                validator: (v) =>
                    Validators.confirmPassword(v, _password.text),
                onSubmitted: _signUp,
              ),
              _TermsCheckbox(
                key: _termsKey,
                value: _agreed,
                hasError: _termsTouched && !_agreed,
                errorMessage: 'You must agree to the terms',
                onChanged: (v) => setState(() {
                  _agreed = v;
                  if (v) _termsTouched = false;
                }),
              ),
              const SizedBox(height: 12),
              GradientButton(
                label: 'Sign Up',
                loading: _loading,
                onPressed: _signUp,
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
                      'Already have an account?',
                      style: AppText.style(
                        14.5,
                        FontWeight.w500,
                        AppColors.textGrey,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
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
                            'Log in',
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

/// "I agree to the Terms of Service and Privacy Policy" – validated checkbox.
class _TermsCheckbox extends StatelessWidget {
  const _TermsCheckbox({
    super.key,
    required this.value,
    required this.hasError,
    required this.errorMessage,
    required this.onChanged,
  });

  final bool value;
  final bool hasError;
  final String errorMessage;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final base = AppText.style(13.5, FontWeight.w500, AppColors.textGrey);
    final link = AppText.style(13.5, FontWeight.w700, AppColors.purple);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: Checkbox(
                value: value,
                activeColor: AppColors.purple,
                side: BorderSide(
                  color: hasError ? AppColors.error : AppColors.textGrey,
                  width: 1.6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                onChanged: (v) => onChanged(v ?? false),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(!value),
                child: Text.rich(
                  TextSpan(
                    style: base,
                    children: [
                      const TextSpan(text: 'I agree to the '),
                      TextSpan(text: 'Terms of Service', style: link),
                      const TextSpan(text: ' and '),
                      TextSpan(text: 'Privacy Policy', style: link),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 6, top: 4),
            child: Text(
              errorMessage,
              style: AppText.style(
                12,
                FontWeight.w600,
                AppColors.error,
                height: 1.3,
              ),
            ),
          ),
      ],
    );
  }
}


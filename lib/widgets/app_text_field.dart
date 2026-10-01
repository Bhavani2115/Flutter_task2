import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';

/// Labelled text field with leading icon, optional show/hide eye and a red
/// validation message underneath.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.isPassword = false,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    this.autofillHints,
    this.inputFormatters,
    this.bottomGap = 16,
    this.focusNode,
    this.autovalidateMode,
    this.onChanged,
  });

  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool isPassword;
  final TextInputAction textInputAction;
  final VoidCallback? onSubmitted;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final double bottomGap;
  final FocusNode? focusNode;
  final AutovalidateMode? autovalidateMode;
  final ValueChanged<String>? onChanged;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure = widget.isPassword;

  OutlineInputBorder _border(Color c, [double width = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: c, width: width),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            widget.label,
            style: AppText.style(14.5, FontWeight.w600, AppColors.navy),
          ),
        ),
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          validator: widget.validator,
          autovalidateMode: widget.autovalidateMode,
          onChanged: widget.onChanged,
          scrollPadding: const EdgeInsets.only(bottom: 140, top: 20),
          obscureText: _obscure,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          autofillHints: widget.autofillHints,
          inputFormatters: widget.inputFormatters,
          onFieldSubmitted: (_) => widget.onSubmitted?.call(),
          enableSuggestions: !widget.isPassword,
          autocorrect: !widget.isPassword,
          cursorColor: AppColors.purple,
          style: AppText.style(15.5, FontWeight.w500, AppColors.navy),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppText.style(15, FontWeight.w400, AppColors.hint),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 14, right: 10),
              child: Icon(widget.icon, color: AppColors.textGrey, size: 24),
            ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            suffixIcon: widget.isPassword
                ? IconButton(
                    splashRadius: 20,
                    tooltip: _obscure ? 'Show password' : 'Hide password',
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textGrey,
                      size: 22,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : null,
            border: _border(AppColors.border),
            enabledBorder: _border(AppColors.border),
            focusedBorder: _border(AppColors.purple, 1.6),
            errorBorder: _border(AppColors.error, 1.4),
            focusedErrorBorder: _border(AppColors.error, 1.6),
            errorStyle: AppText.style(
              12,
              FontWeight.w600,
              AppColors.error,
              height: 1.3,
            ),
            errorMaxLines: 2,
          ),
        ),
        SizedBox(height: widget.bottomGap),
      ],
    );
  }
}

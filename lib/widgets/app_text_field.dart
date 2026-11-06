import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

/// One text field style for the whole app.
///
/// The field draws its own background and border, so don't wrap it in a
/// Container with a fixed height. It sizes itself to the font, which keeps
/// text from being clipped on small or large screens.
class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign textAlign;
  final int? maxLength;
  final bool autofocus;
  final bool enabled;
  final String? errorText;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.icon,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.maxLength,
    this.autofocus = false,
    this.enabled = true,
    this.errorText,
    this.onSubmitted,
    this.onChanged,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure = widget.isPassword;

  OutlineInputBorder _border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: color, width: width),
      );

  @override
  Widget build(BuildContext context) {
    final iconSize = 17.sp;

    return TextField(
      controller: widget.controller,
      obscureText: _obscure,
      enableSuggestions: !widget.isPassword,
      autocorrect: false,
      keyboardType: widget.isPassword
          ? TextInputType.visiblePassword
          : widget.keyboardType,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      textCapitalization: widget.textCapitalization,
      inputFormatters: widget.inputFormatters,
      textAlign: widget.textAlign,
      maxLength: widget.maxLength,
      autofocus: widget.autofocus,
      enabled: widget.enabled,
      onSubmitted: widget.onSubmitted,
      onChanged: widget.onChanged,
      cursorColor: Colors.white,
      style: GoogleFonts.inter(color: Colors.white, fontSize: 16.sp),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: GoogleFonts.inter(
          color: Colors.white.withValues(alpha: 0.40),
          fontSize: 16.sp,
        ),
        errorText: widget.errorText,
        errorStyle: GoogleFonts.inter(
          color: const Color(0xFFFF8A8A),
          fontSize: 13.sp,
        ),
        counterText: "",
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.10),
        isDense: false,
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
        prefixIcon: widget.icon == null
            ? null
            : Icon(
                widget.icon,
                color: Colors.white.withValues(alpha: 0.55),
                size: iconSize,
              ),
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white.withValues(alpha: 0.55),
                  size: iconSize,
                ),
              )
            : null,
        border: _border(Colors.white.withValues(alpha: 0.20)),
        enabledBorder: _border(Colors.white.withValues(alpha: 0.20)),
        disabledBorder: _border(Colors.white.withValues(alpha: 0.10)),
        focusedBorder: _border(Colors.white.withValues(alpha: 0.70), 1.4),
        errorBorder: _border(const Color(0xFFFF8A8A)),
        focusedErrorBorder: _border(const Color(0xFFFF8A8A), 1.4),
      ),
    );
  }
}

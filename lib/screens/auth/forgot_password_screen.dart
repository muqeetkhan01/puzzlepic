import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../config/colors.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_text_field.dart';
import '../../services/haptics.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String initialEmail;
  const ForgotPasswordScreen({super.key, this.initialEmail = ""});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController emailC = TextEditingController(
    text: widget.initialEmail,
  );
  bool loading = false;
  bool sent = false;
  String? errorText;

  @override
  void dispose() {
    emailC.dispose();
    super.dispose();
  }

  String? _validate() {
    final email = emailC.text.trim();
    if (email.isEmpty) return "Email is required";
    final regex = RegExp(r"^[\w\.\+-]+@[\w\.-]+\.\w+$");
    if (!regex.hasMatch(email)) return "Please enter a valid email address";
    return null;
  }

  Future<void> _sendEmail() async {
    FocusScope.of(context).unfocus();
    if (loading) return;

    final invalid = _validate();
    if (invalid != null) {
      Haptics.error();
      setState(() => errorText = invalid);
      return;
    }

    setState(() {
      loading = true;
      errorText = null;
    });

    final err = await AuthService.to.resetPassword(emailC.text.trim());

    if (!mounted) return;
    err != null ? Haptics.error() : Haptics.success();
    setState(() {
      loading = false;
      if (err != null) {
        errorText = err;
      } else {
        sent = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: 100.w,
        height: 100.h,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.backgroundGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  "Forgot Password",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  sent
                      ? "Check your inbox"
                      : "Enter your email and we will send you a reset link.",
                  style: GoogleFonts.inter(
                    color: AppColors.white70,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                if (sent) _sentCard() else ..._form(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _form() => [
    Text(
      "Email",
      style: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),
    ),
    SizedBox(height: 1.h),
    AppTextField(
      controller: emailC,
      hint: "your@email.com",
      icon: Icons.mail,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.send,
      autofillHints: const [AutofillHints.email],
      errorText: errorText,
      onChanged: (_) {
        if (errorText != null) setState(() => errorText = null);
      },
      onSubmitted: (_) => _sendEmail(),
    ),
    SizedBox(height: 4.h),
    _button(
      loading ? "Sending..." : "Send Reset Link",
      loading ? null : _sendEmail,
    ),
  ];

  Widget _sentCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
            color: AppColors.white10,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.white20),
          ),
          child: Column(
            children: [
              Icon(
                Icons.mark_email_read_outlined,
                color: AppColors.neonGreen,
                size: 34.sp,
              ),
              SizedBox(height: 1.5.h),
              Text(
                "If an account exists for\n${emailC.text.trim()},\nyou'll receive a password reset link shortly.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 15.sp),
              ),
              SizedBox(height: 1.5.h),
              Text(
                "Don't see it? Check your Spam or Junk folder.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: AppColors.white70,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),
        _button("Back to Login", () => Navigator.of(context).maybePop()),
        SizedBox(height: 1.5.h),
        TextButton(
          onPressed: () => setState(() => sent = false),
          child: Text(
            "Use a different email",
            style: GoogleFonts.inter(color: AppColors.white70, fontSize: 15.sp),
          ),
        ),
      ],
    );
  }

  Widget _button(String text, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 1.8.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: AppColors.signupButtonGradient,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// lib/screens/auth/login_signup_screen.dart

import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../config/colors.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/gradient_scaffold.dart';
import 'forgot_password_screen.dart';
import '../../services/haptics.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool isLogin = true;

  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();

  File? selectedImage;

  String? nameErr;
  String? emailErr;
  String? passErr;
  bool loading = false;

  bool get safeMounted => mounted;

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------
  // PICK IMAGE
  // ----------------------------------------------------------
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null && safeMounted) {
      setState(() => selectedImage = File(picked.path));
    }
  }

  // ----------------------------------------------------------
  // VALIDATION
  // ----------------------------------------------------------
  /// Checks the form and shows any problem right under the field.
  /// Returns true when everything looks good.
  bool validate() {
    final name = nameC.text.trim();
    final email = emailC.text.trim();
    final pass = passC.text.trim();
    final emailRegex = RegExp(r"^[\w\.\+-]+@[\w\.-]+\.\w+$");

    setState(() {
      nameErr = (!isLogin && name.isEmpty)
          ? "Please enter your full name"
          : null;

      if (email.isEmpty) {
        emailErr = "Please enter your email address";
      } else if (!emailRegex.hasMatch(email)) {
        emailErr =
            "This doesn't look like a valid email (e.g. name@example.com)";
      } else {
        emailErr = null;
      }

      if (pass.isEmpty) {
        passErr = "Please enter your password";
      } else if (!isLogin && pass.length < 6) {
        passErr = "Your password needs at least 6 characters";
      } else {
        passErr = null;
      }
    });

    return nameErr == null && emailErr == null && passErr == null;
  }

  void _switchMode(bool toLogin) {
    FocusScope.of(context).unfocus();
    setState(() {
      isLogin = toLogin;
      nameErr = emailErr = passErr = null;
    });
  }

  // ----------------------------------------------------------
  // SNACKBAR
  // ----------------------------------------------------------
  void showSnack(
    String title,
    String msg, {
    bool err = true,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    if (!safeMounted) return;

    Get.closeAllSnackbars();
    Get.snackbar(
      "",
      "",
      titleText: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 15.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      messageText: Text(
        msg,
        style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.white),
      ),
      mainButton: actionLabel == null
          ? null
          : TextButton(
              onPressed: () {
                Get.closeCurrentSnackbar();
                onAction?.call();
              },
              child: Text(
                actionLabel,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                ),
              ),
            ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: err
          ? const Color(0xFFD94A5C).withValues(alpha: 0.95)
          : const Color(0xFF22A45D).withValues(alpha: 0.95),
      borderRadius: 16,
      margin: const EdgeInsets.all(16),
      duration: Duration(seconds: err ? 5 : 2),
    );
  }

  // ----------------------------------------------------------
  // UI
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      extendBodyBehindAppBar: false,
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
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
            child: Column(
              children: [
                SizedBox(height: 3.h),

                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 12.h,
                    width: 12.h,
                  ),
                ).animate().fadeIn(duration: 800.ms).scale(),

                SizedBox(height: 3.h),

                Text(
                  "Sign in to start your puzzle journey",
                  style: GoogleFonts.inter(
                    color: AppColors.white70,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                SizedBox(height: 4.h),
                _glassCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // GLASS CARD
  // ----------------------------------------------------------
  Widget _glassCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: AppColors.white10,
            border: Border.all(color: AppColors.white20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _toggle(),
              SizedBox(height: 3.h),

              if (!isLogin) _signupPhoto(),

              AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isLogin) ...[
                      _label("Full Name"),
                      AppTextField(
                        key: const ValueKey("name"),
                        errorText: nameErr,
                        onChanged: (_) {
                          if (nameErr != null) setState(() => nameErr = null);
                        },
                        controller: nameC,
                        hint: "John Doe",
                        icon: Icons.person,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.name],
                      ),
                      SizedBox(height: 2.h),
                    ],
                    _label("Email"),
                    AppTextField(
                      key: const ValueKey("email"),
                      errorText: emailErr,
                      onChanged: (_) {
                        if (emailErr != null) setState(() => emailErr = null);
                      },
                      controller: emailC,
                      hint: "your@email.com",
                      icon: Icons.mail,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                    ),
                    SizedBox(height: 2.h),
                    _label("Password"),
                    AppTextField(
                      key: const ValueKey("password"),
                      errorText: passErr,
                      onChanged: (_) {
                        if (passErr != null) setState(() => passErr = null);
                      },
                      controller: passC,
                      hint: "••••••••",
                      icon: Icons.lock,
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      autofillHints: [
                        isLogin
                            ? AutofillHints.password
                            : AutofillHints.newPassword,
                      ],
                      onSubmitted: (_) => _submit(),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 1.h),

              if (isLogin)
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Get.to(
                      () => ForgotPasswordScreen(
                        initialEmail: emailC.text.trim(),
                      ),
                    ),
                    child: Text(
                      "Forgot Password?",
                      style: GoogleFonts.inter(
                        color: AppColors.white70,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                ),

              SizedBox(height: 2.h),

              _actionButton(),

              // SizedBox(height: 3.h),
              // _divider(),
              // SizedBox(height: 3.h),
              // _guestButton()
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // TOGGLE LOGIN/SIGNUP
  // ----------------------------------------------------------
  Widget _toggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          Expanded(child: _toggleBtn("Login", true)),
          Expanded(child: _toggleBtn("Sign Up", false)),
        ],
      ),
    );
  }

  Widget _toggleBtn(String text, bool loginMode) {
    final active = loginMode == isLogin;

    return GestureDetector(
      onTap: () {
        if (!safeMounted) return;
        Haptics.select();
        _switchMode(loginMode);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.2.h),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.inter(
              color: active ? Colors.black : Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // SIGNUP PHOTO
  // ----------------------------------------------------------
  Widget _signupPhoto() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: pickImage,
            child: Container(
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white12,
                border: Border.all(color: Colors.white24),
              ),
              clipBehavior: Clip.hardEdge,
              child: selectedImage == null
                  ? Icon(Icons.camera_alt, color: Colors.white70, size: 22.sp)
                  : Image.file(selectedImage!, fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: .6.h),
          Text(
            "(Optional)",
            style: GoogleFonts.inter(color: AppColors.white70, fontSize: 15.sp),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // INPUT FIELD
  // ----------------------------------------------------------
  Widget _label(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (loading) return;

    if (!validate()) {
      Haptics.error();
      return;
    }

    if (!safeMounted) return;
    setState(() => loading = true);

    String? error;

    if (isLogin) {
      error = await AuthService.to.login(emailC.text.trim(), passC.text.trim());
    } else {
      error = await AuthService.to.signup(
        nameC.text.trim(),
        emailC.text.trim(),
        passC.text.trim(),
        selectedImage,
      );
    }

    if (!safeMounted) return;

    setState(() => loading = false);

    if (error != null) {
      Haptics.error();
      final code = AuthService.to.lastErrorCode;
      final info = AuthService.describe(code);

      if (code == 'email-already-in-use') {
        setState(() => emailErr = "This email is already registered");
        showSnack(
          info.title,
          info.message,
          actionLabel: "Log in",
          onAction: () => _switchMode(true),
        );
      } else if (isLogin &&
          const [
            'user-not-found',
            'wrong-password',
            'invalid-credential',
            'INVALID_LOGIN_CREDENTIALS',
          ].contains(code)) {
        showSnack(
          info.title,
          info.message,
          actionLabel: "Reset",
          onAction: () => Get.to(
            () => ForgotPasswordScreen(initialEmail: emailC.text.trim()),
          ),
        );
      } else {
        showSnack(info.title, info.message);
      }
      return;
    }

    Haptics.success();
    TextInput.finishAutofillContext();
    showSnack(
      isLogin ? "Welcome back!" : "Account created",
      isLogin
          ? "Good to see you again. Let's solve some puzzles!"
          : "Welcome to Puzzle Pics! Your account is ready.",
      err: false,
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!safeMounted) return;
      Get.offAll(() => BottomNavScreen(selected: 0));
    });
  }

  // ----------------------------------------------------------
  // LOGIN / SIGNUP BUTTON
  // ----------------------------------------------------------
  Widget _actionButton() {
    return GestureDetector(
      onTap: _submit,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.8.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isLogin
                ? AppColors.loginButtonGradient
                : AppColors.signupButtonGradient,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            loading
                ? "Please wait..."
                : isLogin
                ? "Login"
                : "Create Account",
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

  // ----------------------------------------------------------
  // DIVIDER
  // ----------------------------------------------------------
  Widget _divider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: AppColors.white20)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Text(
            "or",
            style: GoogleFonts.inter(color: AppColors.white70, fontSize: 15.sp),
          ),
        ),
        Expanded(child: Container(height: 1, color: AppColors.white20)),
      ],
    );
  }

  // ----------------------------------------------------------
  // GUEST BUTTON
  // ----------------------------------------------------------
  Widget _guestButton() {
    return GestureDetector(
      onTap: () => Get.offAll(() => BottomNavScreen(selected: 0)),
      child: Container(
        height: 5.4.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.white20),
          color: Colors.white12,
        ),
        child: Center(
          child: Text(
            "Continue as Guest",
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

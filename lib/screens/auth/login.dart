// lib/screens/auth/login_signup_screen.dart

import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../config/colors.dart';
import '../../services/auth_service.dart';
import '../../widgets/bottom_nav.dart';
import 'forgot_password_screen.dart';

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
  String? validate() {
    final name = nameC.text.trim();
    final email = emailC.text.trim();
    final pass = passC.text.trim();

    if (!isLogin && name.isEmpty) return "Full name required";
    // if (!isLogin && selectedImage == null) return "Select profile photo";

    if (email.isEmpty) return "Email required";

    final regex = RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$");
    if (!regex.hasMatch(email)) return "Invalid email";

    if (pass.isEmpty) return "Password required";
    if (pass.length < 6) return "Password must be 6+ chars";

    return null;
  }

  // ----------------------------------------------------------
  // SNACKBAR
  // ----------------------------------------------------------
  void showSnack(String title, String msg, {bool err = true}) {
    if (!safeMounted) return;

    Get.snackbar(
      "",
      "",
      titleText: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 17.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      messageText: Text(
        msg,
        style: GoogleFonts.inter(fontSize: 15.sp, color: Colors.white),
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: (err ? Colors.red : Colors.green).withOpacity(0.75),
      borderRadius: 16,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  // ----------------------------------------------------------
  // UI
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

              if (!isLogin) _label("Full Name"),
              if (!isLogin) _input(Icons.person, "John Doe", controller: nameC),

              SizedBox(height: 1.5.h),

              _label("Email"),
              _input(Icons.mail, "your@email.com", controller: emailC),

              SizedBox(height: 1.5.h),

              _label("Password"),
              _input(Icons.lock, "••••••••", controller: passC, isPass: true),

              SizedBox(height: 1.h),

              if (isLogin)
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Get.to(() => const ForgotPasswordScreen()),
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
        setState(() => isLogin = loginMode);
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

  Widget _input(
    IconData icon,
    String hint, {
    bool isPass = false,
    TextEditingController? controller,
  }) {
    return Container(
      height: 5.4.h,
      margin: EdgeInsets.only(bottom: 1.2.h),
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppColors.white10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white20),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.white50, size: 17.sp),
          SizedBox(width: 3.w),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPass,
              style: GoogleFonts.inter(color: Colors.white),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.inter(color: AppColors.white40),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // LOGIN / SIGNUP BUTTON
  // ----------------------------------------------------------
  Widget _actionButton() {
    return GestureDetector(
      onTap: () async {
        if (loading) return;

        final validationMsg = validate();
        if (validationMsg != null) {
          showSnack("Validation Error", validationMsg);
          return;
        }

        if (!safeMounted) return;
        setState(() => loading = true);

        String? error;

        if (isLogin) {
          error = await AuthService.to.login(
            emailC.text.trim(),
            passC.text.trim(),
          );
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
          showSnack("Authentication Failed", error);
          return;
        }

        showSnack(
          isLogin ? "Login Successful" : "Account Created",
          "Welcome to PuzzlePic!",
          err: false,
        );

        Future.delayed(const Duration(milliseconds: 300), () {
          if (!safeMounted) return;
          Get.offAll(() => BottomNavScreen(selected: 0));
        });
      },
      child: Container(
        height: 5.4.h,
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

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../config/colors.dart';
import '../../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailC = TextEditingController();
  bool loading = false;

  bool get safeMounted => mounted;

  @override
  void dispose() {
    emailC.dispose();
    super.dispose();
  }

  // -------------------------------
  // VALIDATION
  // -------------------------------
  String? validateEmail() {
    final email = emailC.text.trim();
    if (email.isEmpty) return "Email is required";

    final regex = RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$");
    if (!regex.hasMatch(email)) return "Invalid email";

    return null;
  }

  // -------------------------------
  // SNACKBAR
  // -------------------------------
  void showSnack(String title, String msg, {bool err = true}) {
    if (!safeMounted) return;

    Get.snackbar(
      "",
      "",
      titleText: Text(
        title,
        style: GoogleFonts.inter(
            color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w700),
      ),
      messageText: Text(
        msg,
        style: GoogleFonts.inter(color: Colors.white, fontSize: 15.sp),
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: (err ? Colors.red : Colors.green).withOpacity(0.75),
      borderRadius: 16,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  // -------------------------------
  // SEND RESET EMAIL
  // -------------------------------
  Future<void> sendEmail() async {
    final valid = validateEmail();
    if (valid != null) {
      showSnack("Validation Error", valid);
      return;
    }

    if (!safeMounted) return;
    setState(() => loading = true);

    final err = await AuthService.to.resetPassword(emailC.text.trim());

    if (!safeMounted) return;
    setState(() => loading = false);

    if (err != null) {
      showSnack("Failed", err);
      return;
    }

    showSnack(
      "Success",
      "Password reset link sent to your email.",
      err: false,
    );

    Future.delayed(const Duration(milliseconds: 400), () {
      if (!safeMounted) return;
      Get.back();
    });
  }

  // -------------------------------
  // UI
  // -------------------------------
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),

                // Back Button
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(Icons.arrow_back_ios,
                      color: Colors.white, size: 20.sp),
                ),

                SizedBox(height: 4.h),

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
                  "Enter your email and we will send you a reset link.",
                  style: GoogleFonts.inter(
                    color: AppColors.white70,
                    fontSize: 16.sp,
                  ),
                ),

                SizedBox(height: 4.h),

                _label("Email"),
                _input(Icons.mail, "your@email.com",
                    controller: emailC, isPass: false),

                SizedBox(height: 4.h),

                _actionButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------
  // LABEL
  // -------------------------------
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

  // -------------------------------
  // INPUT FIELD (Glass Theme)
  // -------------------------------
  Widget _input(IconData icon, String hint,
      {bool isPass = false, required TextEditingController controller}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          height: 5.4.h,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: AppColors.white10,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.white20),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.white50, size: 18.sp),
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
        ),
      ),
    );
  }

  // -------------------------------
  // ACTION BUTTON (Neon Gradient)
  // -------------------------------
  Widget _actionButton() {
    return GestureDetector(
      onTap: loading ? null : sendEmail,
      child: Container(
        height: 5.4.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.signupButtonGradient,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            loading ? "Sending..." : "Send Reset Link",
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

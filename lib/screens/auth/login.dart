import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puzzle_app/widgets/bottom_nav.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../config/colors.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveSizer(
        builder: (_, __, ___) {
          return Container(
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
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                  child: Column(
                    children: [
                      SizedBox(height: 3.h),

                      // LOGO
                      Container(
                        height: 13.h,
                        width: 13.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22.sp),
                          gradient: const LinearGradient(
                            colors: AppColors.logoGradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(
                          Icons.extension,
                          size: 7.h,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 2.5.h),

                      // TITLE
                      Text(
                        "PuzzlePic",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      SizedBox(height: 1.h),

                      Text(
                        "Sign in to start your puzzle journey",
                        style: GoogleFonts.inter(
                          color: AppColors.white70,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // CARD WITH BLUR
                      ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              color: AppColors.white10,
                              border: Border.all(
                                color: AppColors.white20,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildToggle(),

                                SizedBox(height: 3.h),

                                if (!isLogin) _label("Full Name"),
                                if (!isLogin) SizedBox(height: 1.h),
                                if (!isLogin)
                                  _input(Icons.person_outline, "John Doe"),

                                if (!isLogin) SizedBox(height: 1.5.h),

                                _label("Email"),
                                SizedBox(height: 1.h),
                                _input(Icons.mail_outline, "your@email.com"),

                                SizedBox(height: 1.5.h),

                                _label("Password"),
                                SizedBox(height: 1.h),
                                _input(
                                  Icons.lock_outline,
                                  "••••••••",
                                  isPass: true,
                                ),

                                SizedBox(height: 3.5.h),

                                _button(
                                  isLogin ? "Login" : "Create Account",
                                  isLogin
                                      ? AppColors.loginButtonGradient
                                      : AppColors.signupButtonGradient,
                                ),

                                SizedBox(height: 3.h),

                                _divider(),

                                SizedBox(height: 3.h),

                                // Guest Login Button
                                GestureDetector(
                                  onTap: () {
                                    // TODO: Navigate as guest
                                  },
                                  child: Container(
                                    height: 5.4.h, // matches new smaller height
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.white20,
                                        width: 1,
                                      ),
                                      color: Colors.white.withOpacity(0.07),
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 3.5.h),

                      Text(
                        "By continuing, you agree to our Terms of\nService and Privacy Policy",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: AppColors.white50,
                          fontSize: 15.sp,
                        ),
                      ),

                      SizedBox(height: 3.h),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------- UI COMPONENTS -------------------

  Widget _buildToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          Expanded(child: _toggleButton("Login", true)),
          Expanded(child: _toggleButton("Sign Up", false)),
        ],
      ),
    );
  }

  Widget _toggleButton(String text, bool loginTab) {
    final isActive = loginTab == isLogin;

    return GestureDetector(
      onTap: () => setState(() => isLogin = loginTab),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.2.h), // smaller
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.inter(
              color: isActive ? Colors.black : Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _input(IconData icon, String hint, {bool isPass = false}) {
    return Container(
      height: 5.4.h, // smaller height
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppColors.white10,
        borderRadius: BorderRadius.circular(12), // slightly smaller radius
        border: Border.all(color: AppColors.white20, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.white50, size: 17.sp),
          SizedBox(width: 3.w),
          Expanded(
            child: TextField(
              obscureText: isPass,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 15.sp),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.inter(
                  color: AppColors.white40,
                  fontSize: 15.sp,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _button(String text, List<Color> colors) {
  return GestureDetector(
  onTap: () {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) =>  BottomNavScreen(selected: 0),
    ),
  );
},



    child: Container(
      height: 5.4.h, // smaller height
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
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
}

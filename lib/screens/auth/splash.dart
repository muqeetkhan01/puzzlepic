import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puzzle_app/screens/auth/login.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../config/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginSignupScreen()),
      );
    });
  }

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LOGO
                ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 20.h,
                        width: 20.h,
                        // color: Colors.white,
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 800.ms)
                    .scale(begin: const Offset(0.7, 0.7), duration: 800.ms),

                SizedBox(height: 3.h),

                // Text(
                //   "PuzzlePic",
                //   style: GoogleFonts.inter(
                //     color: Colors.white,
                //     fontWeight: FontWeight.w600,
                //     fontSize: 22.sp,
                //   ),
                // ).animate().fadeIn(duration: 600.ms),
                SizedBox(height: 1.5.h),
                Text(
                  "Sharpen your mind. One puzzle at a time.",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.85),
                    fontWeight: FontWeight.w300,
                    fontSize: 15.sp,
                  ),
                ).animate().fadeIn(duration: 800.ms),
              ],
            ),
          );
        },
      ),
    );
  }
}

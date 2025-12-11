import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puzzle_app/screens/auth/login.dart';
import 'package:puzzle_app/widgets/bottom_nav.dart';

import '../../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // 🔥 AUTH STATE LISTENER — handles login/logout automatically
    ever(AuthService.to.firebaseUser, (user) async {
      if (user == null) {
        Get.offAll(() => const LoginSignupScreen());
      } else {
        Get.offAll(() => BottomNavScreen(selected: 0));
      }
    });

    // Force trigger once at app start
    final u = AuthService.to.currentUser;
    Future.delayed(Duration.zero, () {
      if (u == null) {
        Get.offAll(() => const LoginSignupScreen());
      } else {
        Get.offAll(() => BottomNavScreen(selected: 0));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.png", height: 140),
            const SizedBox(height: 20),
            Text(
              "PuzzlePic",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Loading...",
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:puzzle_app/screens/auth/splash.dart';

void main() {
  runApp(
    ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return const PuzzleApp();
      },
    ),
  );
}

class PuzzleApp extends StatelessWidget {
  const PuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: "PuzzlePic",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: false,
            scaffoldBackgroundColor: const Color(0xFFF9F9F9),
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),

          /// 👉 CHANGE THIS to SplashScreen or Login
          home: const SplashScreen(),
        );
      },
    );
  }
}

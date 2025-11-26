import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puzzle_app/config/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:puzzle_app/screens/puzzle.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // HEADER
              Container(
                width: 100.w,
                padding: EdgeInsets.only(
                  top: 5.h,
                  left: 6.w,
                  right: 6.w,
                  bottom: 4.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Align(
                    //   alignment: Alignment.center,
                    //   child: Icon(
                    //     Icons.extension,
                    //     size: 7.h,
                    //     color: AppColors.white,
                    //   ),
                    // ),
                    SizedBox(height: 2.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 10.h,
                        width: 10.h,
                      ),
                    ),
                    // Text(
                    //   "Puzzle Pic",
                    //   textAlign: TextAlign.center,
                    //   style: GoogleFonts.poppins(
                    //     fontSize: 28.sp,
                    //     fontWeight: FontWeight.w600,
                    //     color: AppColors.white,
                    //     height: 1.1,
                    //   ),
                    // ),
                    SizedBox(height: 2.h),

                    Text(
                      "Transform your photos into\nchallenging puzzles",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 17.sp,
                        height: 1.35,
                        color: AppColors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              // SizedBox(height: 2.h),
              _soloCard(context),
              SizedBox(height: 4.h),

              _multiplayerCard(),
              SizedBox(height: 4.h),

              _howToPlayCard(),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }

  // ⭐ SOLO CARD
  Widget _soloCard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
            decoration: BoxDecoration(
              color: AppColors.white10,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: AppColors.white20, width: 1.3),
            ),
            child: Column(
              children: [
                SizedBox(height: 1.h),
                Icon(Icons.emoji_events, size: 9.h, color: Colors.yellowAccent),
                SizedBox(height: 2.h),

                Text(
                  "Solo Challenge",
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),

                SizedBox(height: 1.h),

                Text(
                  "Race against time and beat your\nhigh scores",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    color: AppColors.white70,
                    height: 1.3,
                  ),
                ),

                SizedBox(height: 3.h),

                // BLUE BUTTON (25)
                _gradientButton(
                  "5 Pieces",
                  AppColors.loginButtonGradient,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PuzzleScreen(pieceCount: 5),
                      ),
                    );
                  },
                ),

                SizedBox(height: 2.h),
                _gradientButton(
                  "10 Pieces",
                  AppColors.signupButtonGradient,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PuzzleScreen(pieceCount: 10),
                      ),
                    );
                  },
                ),

                SizedBox(height: 2.h),
                _gradientButton(
                  "25 Pieces",
                  AppColors.loginButtonGradient,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PuzzleScreen(pieceCount: 25),
                      ),
                    );
                  },
                ),

                SizedBox(height: 2.h),

                // PURPLE BUTTON (50)
                _gradientButton(
                  "50 Pieces",
                  AppColors.signupButtonGradient,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PuzzleScreen(pieceCount: 50),
                      ),
                    );
                  },
                ),

                SizedBox(height: 1.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ⭐ MULTIPLAYER
  Widget _multiplayerCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
            decoration: BoxDecoration(
              color: AppColors.white10,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: AppColors.white20, width: 1.3),
            ),
            child: Column(
              children: [
                Icon(Icons.group, size: 9.h, color: Colors.greenAccent),
                SizedBox(height: 2.h),

                Text(
                  "Multiplayer",
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 1.h),

                Text(
                  "Compete with friends in real-time",
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    color: AppColors.white70,
                  ),
                ),
                SizedBox(height: 3.h),

                _gradientButton("25 Pieces - Easy", [
                  Color(0xFF22C55E),
                  Color(0xFF16A34A),
                ]),
                SizedBox(height: 2.h),

                _gradientButton("50 Pieces - Hard", [
                  Color(0xFFFF8C00),
                  Color(0xFFE65100),
                ]),
                SizedBox(height: 1.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ⭐ HOW TO PLAY
  Widget _howToPlayCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
            decoration: BoxDecoration(
              color: AppColors.white10,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: AppColors.white20, width: 1.3),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "How to Play",
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),

                SizedBox(height: 2.h),
                _bullet("Upload your favorite photo"),
                SizedBox(height: 1.5.h),
                _bullet("Drag and drop puzzle pieces to swap their positions"),
                SizedBox(height: 1.5.h),
                _bullet("Complete the puzzle as fast as possible"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bullet(String text) {
    return Text(
      "•  $text",
      style: GoogleFonts.poppins(fontSize: 16.sp, color: AppColors.white70),
    );
  }

  Widget _gradientButton(
    String label,
    List<Color> colors, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 6.2.h,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

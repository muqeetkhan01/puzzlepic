import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              SizedBox(height: 20.h),
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
                  "9 Pieces",
                  [Color(0xFF22C55E), Color(0xFF16A34A)],
                  onTap: () {
                    Get.to(PuzzleScreen(pieceCount: 9));
                  },
                ),

                SizedBox(height: 2.h),
                _gradientButton(
                  "12 Pieces",
                  AppColors.signupButtonGradient,
                  onTap: () {
                    Get.to(PuzzleScreen(pieceCount: 12));
                  },
                ),

                SizedBox(height: 2.h),
                _gradientButton(
                  "25 Pieces",
                  AppColors.loginButtonGradient,
                  onTap: () {
                    Get.to(PuzzleScreen(pieceCount: 25));
                  },
                ),

                SizedBox(height: 2.h),

                // PURPLE BUTTON (50)
                _gradientButton(
                  "50 Pieces",
                  [Color(0xFFFF8C00), Color(0xFFE65100)],
                  onTap: () {
                    Get.to(PuzzleScreen(pieceCount: 50));
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

                _gradientButton(
                  "25 Pieces - Easy",
                  [Color(0xFF22C55E), Color(0xFF16A34A)],
                  onTap: () {
                    Get.to(PuzzleScreen(pieceCount: 25, isMultiplayer: true));

                    // Get.to(MultiplayerMenuScreen());
                  },
                ),
                SizedBox(height: 2.h),

                _gradientButton(
                  "50 Pieces - Hard",
                  [Color(0xFFFF8C00), Color(0xFFE65100)],
                  onTap: () {
                    Get.to(PuzzleScreen(pieceCount: 50, isMultiplayer: true));
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
                /// TITLE
                Text(
                  "How to Play",
                  style: GoogleFonts.poppins(
                    fontSize: 21.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),

                SizedBox(height: 2.2.h),

                /// SOLO MODE
                Text(
                  "🎯 Solo Mode",
                  style: GoogleFonts.poppins(
                    fontSize: 16.5.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 0.8.h),
                _bullet("Upload any photo from your gallery"),
                _bullet("Puzzle pieces will shuffle automatically"),
                _bullet("Drag & swap pieces to rebuild the image"),
                _bullet("Beat your best time and climb the leaderboard"),

                SizedBox(height: 2.2.h),

                /// MULTIPLAYER MODE
                Text(
                  "⚔️ Battle Mode",
                  style: GoogleFonts.poppins(
                    fontSize: 16.5.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 0.8.h),
                _bullet("Play live against friends in real-time", true),

                SizedBox(height: 1.8.h),

                /// HOST
                Text(
                  "👑 Host a Game",
                  style: GoogleFonts.poppins(
                    fontSize: 15.5.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 0.6.h),
                _bullet("Choose and upload the puzzle image"),
                _bullet("Generate a unique room code"),
                _bullet("Invite friends and start the match"),
                _bullet("Fastest player to solve wins"),
                SizedBox(height: 1.6.h),

                /// PARTICIPANT
                Text(
                  "🎮 Join a Game",
                  style: GoogleFonts.poppins(
                    fontSize: 15.5.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 0.6.h),
                _bullet("Enter the room code shared by the host"),
                _bullet("Solve the same puzzle as other players"),
                _bullet("Race in real-time to finish first"),
                _bullet("Winner earns bragging rights 🏆"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bullet(String text, [bool isSub = false]) {
    return Text(
      isSub ? text : "•  $text",
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

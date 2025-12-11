import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puzzle_app/config/colors.dart';
import 'package:puzzle_app/screens/home/edit_profile_screen.dart';

import 'package:puzzle_app/screens/auth/login.dart';
import 'package:puzzle_app/screens/home/multi_leaderboard.dart';
import 'package:puzzle_app/services/auth_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.to.firebaseUser.value;

    final displayName = user?.displayName ?? "Guest";
    final email = user?.email ?? "guest@puzzlepic.app";

    final avatarLetter = displayName.isNotEmpty
        ? displayName[0].toUpperCase()
        : "U";

    String memberSince = "N/A";
    if (user?.metadata.creationTime != null) {
      final date = user!.metadata.creationTime!;
      memberSince = "${date.month}/${date.day}/${date.year}";
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: 100.w,
        height: 100.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.backgroundGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 HEADER
                Text(
                  "Profile",
                  style: GoogleFonts.poppins(
                    fontSize: 26.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 2.h),

                // 🔹 USER CARD
                _glassContainer(
                  padding: EdgeInsets.all(4.w),
                  child: Row(
                    children: [
                      // 🔹 Avatar with Edit
                      GestureDetector(
                        onTap: () => Get.to(() => const EditProfileScreen()),
                        child: Container(
                          width: 16.w,
                          height: 16.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white12,
                          ),
                          clipBehavior: Clip.hardEdge,
                          child:
                              user != null &&
                                  user.photoURL != null &&
                                  user.photoURL!.isNotEmpty
                              ? Image.network(user.photoURL!, fit: BoxFit.cover)
                              : Center(
                                  child: Text(
                                    avatarLetter,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                        ),
                      ),

                      SizedBox(width: 4.w),

                      // 🔹 User info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              maxLines: 1,
                              style: GoogleFonts.poppins(
                                fontSize: 18.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 0.7.h),

                            Row(
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  size: 16.sp,
                                  color: Colors.white70,
                                ),
                                SizedBox(width: 1.w),
                                Expanded(
                                  child: Text(
                                    email,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 0.7.h),

                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16.sp,
                                  color: Colors.white70,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  "Member since $memberSince",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 2.5.h),

                // 🔹 Stats Row 1
                Row(
                  children: [
                    Expanded(
                      child: _statsCard(
                        icon: Icons.extension,
                        iconColor: Colors.blueAccent,
                        value: "0",
                        label: "Games Played",
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: _statsCard(
                        icon: Icons.access_time_filled_rounded,
                        iconColor: Colors.greenAccent,
                        value: "0:00",
                        label: "Total Time",
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // 🔹 Stats Row 2
                Row(
                  children: [
                    Expanded(
                      child: _statsCard(
                        icon: Icons.emoji_events,
                        iconColor: Colors.yellowAccent,
                        value: "--",
                        label: "Best (25pc)",
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: _statsCard(
                        icon: Icons.military_tech_outlined,
                        iconColor: Colors.purpleAccent,
                        value: "0/4",
                        label: "Achievements",
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 3.h),

                // 🔹 Achievements
                _glassContainer(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 2.5.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Achievements",
                        style: GoogleFonts.poppins(
                          fontSize: 20.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      SizedBox(
                        width: 90.w,
                        height: 60.h,
                        child: MyMultiplayerGamesScreen(),
                      ),
                      // achievementTile(
                      //   "🎯",
                      //   "First Steps",
                      //   "Complete your first puzzle",
                      // ),
                      // achievementTile(
                      //   "⚡",
                      //   "Speed Demon",
                      //   "Complete 25-piece puzzle under 2 minutes",
                      // ),
                      // achievementTile(
                      //   "🏆",
                      //   "Master Solver",
                      //   "Complete 50-piece puzzle",
                      // ),
                      // achievementTile("💪", "Dedicated", "Play 10 games"),
                    ],
                  ),
                ),

                SizedBox(height: 3.h),

                // 🔥 LOGOUT BUTTON
                GestureDetector(
                  onTap: () async {
                    await AuthService.to.logout();
                    Get.offAll(() => const LoginSignupScreen());
                  },
                  child: Container(
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.90),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.logout,
                            color: Colors.red.shade400,
                            size: 18.sp,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            "Logout",
                            style: GoogleFonts.poppins(
                              color: Colors.red.shade400,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // 🔹 Glass Container
  // ----------------------------------------------------------
  Widget _glassContainer({required Widget child, EdgeInsets? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: padding ?? EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withOpacity(0.20),
              width: 1.2,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // 🔹 Stats Card
  // ----------------------------------------------------------
  Widget _statsCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return _glassContainer(
      padding: EdgeInsets.symmetric(vertical: 3.5.h),
      child: Column(
        children: [
          Icon(icon, size: 6.h, color: iconColor),
          SizedBox(height: 1.h),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 0.7.h),
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // 🔹 Achievement Tile
  // ----------------------------------------------------------
  Widget achievementTile(String emoji, String title, String subtitle) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.5.h),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.6.h),
      decoration: BoxDecoration(
        color: AppColors.white10,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.white20, width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: GoogleFonts.poppins(fontSize: 20.sp)),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

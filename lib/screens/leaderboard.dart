import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:puzzle_app/config/colors.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int modeIndex = 2; // 0 = Daily, 1 = Weekly, 2 = All Time
  int pieceIndex = 0; // 0 = 25 pieces, 1 = 50 pieces

  // Dummy leaderboard data
  final List<Map<String, dynamic>> data = [
    {"name": "Alex Chen", "time": "1:35", "date": "2024-01-15"},
    {"name": "Sarah Miller", "time": "1:48", "date": "2024-01-14"},
    {"name": "Mike Johnson", "time": "1:52", "date": "2024-01-13"},
    {"name": "Emma Davis", "time": "2:05", "date": "2024-01-12"},
    {"name": "James Wilson", "time": "2:14", "date": "2024-01-11"},
    {"name": "Lisa Brown", "time": "2:22", "date": "2024-01-10"},
    {"name": "Tom Anderson", "time": "2:36", "date": "2024-01-09"},
  ];

  @override
  Widget build(BuildContext context) {
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
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ----------------------------
                // HEADER
                // ----------------------------
                Row(
                  children: [
                    Icon(Icons.emoji_events, size: 24.sp, color: Colors.yellowAccent),
                    SizedBox(width: 2.w),
                    Text(
                      "Leaderboard",
                      style: GoogleFonts.poppins(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 3.h),

                // ----------------------------
                // DAILY / WEEKLY / ALL TIME TOGGLES
                // ----------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _topToggle("Daily", 0),
                    _topToggle("Weekly", 1),
                    _topToggle("All Time", 2),
                  ],
                ),

                SizedBox(height: 2.5.h),

                // ----------------------------
                // 25 / 50 PIECES TOGGLE
                // ----------------------------
                Container(
                  padding: EdgeInsets.all(1.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(26.sp),
                  ),
                  child: Row(
                    children: [
                      _pieceToggle("25 Pieces", 0),
                      _pieceToggle("50 Pieces", 1),
                    ],
                  ),
                ),

                SizedBox(height: 3.h),

                // ----------------------------
                // LEADERBOARD GLASS CARDS
                // ----------------------------
                ListView.builder(
                  itemCount: data.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _leaderboardCard(
                      rank: index + 1,
                      name: data[index]["name"],
                      time: data[index]["time"],
                      date: data[index]["date"],
                    );
                  },
                ),

                SizedBox(height: 6.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ====================================================
  // TOP TOGGLE BUTTON (Daily, Weekly, All Time)
  // ====================================================
  Widget _topToggle(String label, int index) {
    bool active = index == modeIndex;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => modeIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 1.4.h),
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          decoration: BoxDecoration(
            color: active ? Colors.white.withOpacity(0.25) : Colors.white.withOpacity(0.10),
            borderRadius: BorderRadius.circular(18.sp),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(active ? 1 : 0.7),
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                fontSize: 16.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ====================================================
  // PIECE TOGGLE (25 / 50)
  // ====================================================
  Widget _pieceToggle(String label, int index) {
    bool active = index == pieceIndex;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => pieceIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(26.sp),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                color: active ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ====================================================
  // LEADERBOARD CARD
  // ====================================================
  Widget _leaderboardCard({
    required int rank,
    required String name,
    required String time,
    required String date,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.2.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.sp),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.2.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              border: Border.all(color: Colors.white.withOpacity(0.20), width: 1.3),
              borderRadius: BorderRadius.circular(22.sp),
            ),

            child: Row(
              children: [
                // RANK NUMBER (#1, #2, #3...)
                Text(
                  "#$rank",
                  style: GoogleFonts.poppins(
                    fontSize: 17.sp,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(width: 3.w),

                // Avatar
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: AppColors.logoGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      name[0],
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 17.sp),
                    ),
                  ),
                ),

                SizedBox(width: 3.w),

                // NAME + DATE
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 0.3.h),
                      Text(
                        date,
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                // TIME
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      time,
                      style: GoogleFonts.poppins(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Best Time",
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
        ),
      ),
    );
  }
}

// lib/widgets/glass_bottom_nav.dart

import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GlassBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTap;

  const GlassBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: Platform.isAndroid ? true : false,
      child: Padding(
        padding: const EdgeInsets.only(left: 7.0, right: 7),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22.sp),
            topRight: Radius.circular(22.sp),
            bottomLeft: Radius.circular(22.sp),
            bottomRight: Radius.circular(22.sp),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: .8.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.10),
                    Colors.white.withOpacity(0.04),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withOpacity(0.25),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(Icons.home_outlined, "Home", 0),
                  _navItem(Icons.emoji_events_outlined, "Leaderboard", 1),
                  _navItem(Icons.person_outline, "Profile", 2),
                  _navItem(Icons.settings_outlined, "Settings", 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    bool active = index == selectedIndex;

    return GestureDetector(
      onTap: () => onItemTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: active ? Colors.white.withOpacity(0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(16.sp),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: active ? 22.sp : 20.sp, color: Colors.white),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: active ? 14.sp : 13.sp,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../config/colors.dart';   // <-- using your AppColors

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// TITLE
              Row(
                children: [
                  Icon(Icons.settings, color: Colors.white, size: 23.sp),
                  SizedBox(width: 3.w),
                  Text(
                    "Settings",
                    style: GoogleFonts.poppins(
                      fontSize: 22.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 3.h),

              /// PRIVACY & DATA BLOCK
              _sectionCard(
                title: "Privacy & Data",
                icon: Icons.shield_outlined,
                children: [
                  _settingsTile(
                    icon: Icons.info_outline,
                    title: "Privacy Policy",
                    onTap: () {},
                  ),

                  SizedBox(height: 1.5.h),

                  _settingsTile(
                    icon: Icons.shield_outlined,
                    title: "Terms of Service",
                    onTap: () {},
                  ),

                  SizedBox(height: 2.h),

                  _deleteButton(
                    label: "Clear Game Data",
                    onTap: () {},
                  ),
                ],
              ),

              SizedBox(height: 2.5.h),

              /// SUPPORT BLOCK
              _sectionCard(
                title: "Support",
                icon: Icons.help_outline,
                children: [
                  _settingsTile(
                    icon: Icons.help_outline,
                    title: "Help Center",
                    onTap: () {},
                  ),

                  SizedBox(height: 2.h),

                  /// VERSION BOX
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppColors.white10,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "App Version",
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            color: AppColors.white70,
                          ),
                        ),
                        SizedBox(height: 0.7.h),
                        Text(
                          "1.0.0",
                          style: GoogleFonts.poppins(
                            fontSize: 16.5.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }

  // ░░ SECTION CARD ░░
  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: AppColors.white20,
              width: 1,
            ),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.white, size: 19.sp),
                  SizedBox(width: 2.w),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 2.5.h),

              ...children,
            ],
          ),
        ),
      ),
    );
  }

  // ░░ NORMAL SETTING TILE (Smaller like your screenshot) ░░
  Widget _settingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.4.h, horizontal: 3.5.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.11),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.white20),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 17.sp),
            SizedBox(width: 3.w),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ░░ RED CLEAR DATA BUTTON ░░
  Widget _deleteButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.8.h, horizontal: 3.5.w),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.redAccent),
        ),
        child: Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.redAccent, size: 18.sp),
            SizedBox(width: 3.w),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.redAccent,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}

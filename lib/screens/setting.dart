import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controllers/theme_controller.dart';
import '../screens/auth/login.dart';
import '../services/auth_service.dart';
import '../widgets/gradient_scaffold.dart';
import 'home/policy.dart';
import '../services/haptics.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return GradientScaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(context),
            SizedBox(height: 2.6.h),

            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(
                    context,
                    icon: Icons.palette_outlined,
                    title: 'Appearance',
                  ),
                  SizedBox(height: 1.5.h),
                  // Obx(() => _switchTile(
                  //       context,
                  //       icon: Icons.dark_mode_outlined,
                  //       title: 'Dark Mode',
                  //       value: themeController.isDark.value,
                  //       onChanged: (v) => themeController.setDark(v),
                  //     )),
                  // SizedBox(height: 1.2.h),
                  Obx(
                    () => _themePicker(
                      context,
                      value: themeController.style.value,
                      onChanged: (v) => themeController.setStyle(v),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Obx(
                    () => _switchTile(
                      context,
                      icon: Icons.vibration,
                      title: 'Vibration',
                      value: Haptics.enabled.value,
                      onChanged: (v) => Haptics.setEnabled(v),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.2.h),

            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(
                    context,
                    icon: Icons.shield_outlined,
                    title: 'Privacy & Data',
                  ),
                  SizedBox(height: 1.5.h),
                  _navTile(
                    context,
                    icon: Icons.info_outline,
                    title: 'Privacy Policy',
                    onTap: () => Get.to(PrivacyPolicyScreen()),
                  ),
                  SizedBox(height: 1.2.h),
                  _dangerTile(
                    context,
                    icon: Icons.delete_forever_outlined,
                    title: 'Delete Account',
                    onTap: () => _confirmDelete(context),
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.2.h),

            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(
                    context,
                    icon: Icons.help_outline,
                    title: 'Support',
                  ),
                  SizedBox(height: 1.5.h),
                  _navTile(
                    context,
                    icon: Icons.support_agent_outlined,
                    title: 'Help Center',
                    onTap: () => _showHelp(context),
                  ),
                  SizedBox(height: 1.6.h),
                  _versionBox(context),
                ],
              ),
            ),

            SizedBox(height: 2.2.h),

            GlassCard(
              child: _navTile(
                context,
                icon: Icons.logout,
                title: 'Log out',
                onTap: () async {
                  await AuthService.to.logout();
                  Get.offAll(() => const LoginSignupScreen());
                },
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.settings, color: Colors.white, size: 23.sp),
        SizedBox(width: 3.w),
        Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontSize: 22.sp,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 19.sp),
        SizedBox(width: 2.5.w),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _navTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.6.h),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18.sp),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16.2.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.white.withOpacity(0.85),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _switchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.2.h),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18.sp),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16.2.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Switch.adaptive(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _themePicker(
    BuildContext context, {
    required AppThemeStyle value,
    required ValueChanged<AppThemeStyle> onChanged,
  }) {
    String label(AppThemeStyle s) {
      switch (s) {
        case AppThemeStyle.midnight:
          return 'Midnight';
        case AppThemeStyle.ocean:
          return 'Ocean';
        case AppThemeStyle.sunrise:
          return 'Sunrise';
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.0.h),
      child: Row(
        children: [
          Icon(Icons.color_lens_outlined, color: Colors.white, size: 18.sp),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'Theme',
              style: GoogleFonts.poppins(
                fontSize: 16.2.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          DropdownButton<AppThemeStyle>(
            value: value,
            dropdownColor: Colors.black.withOpacity(0.85),
            iconEnabledColor: Colors.white,
            underline: const SizedBox.shrink(),
            items: AppThemeStyle.values
                .map(
                  (s) => DropdownMenuItem<AppThemeStyle>(
                    value: s,
                    child: Text(
                      label(s),
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ],
      ),
    );
  }

  Widget _dangerTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.6.h),
        child: Row(
          children: [
            Icon(icon, color: Colors.redAccent, size: 18.sp),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16.2.sp,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.redAccent.withOpacity(0.9),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _versionBox(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'App Version',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.75),
            ),
          ),
          SizedBox(height: 0.7.h),
          Text(
            '1.0.0',
            style: GoogleFonts.poppins(
              fontSize: 16.5.sp,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Confirm Account Deletion',
          style: TextStyle(color: Colors.black),
        ),
        content: const Text(
          'Are you sure you want to delete your account?\n\nThis action cannot be undone.',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .delete();
      await AuthService.to.logout();
      Get.offAll(() => const LoginSignupScreen());
    }
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          'Contact Help:',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        content: Text(
          'playpuzzlepics@gmail.com',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 16.sp),
        ),
      ),
    );
  }
}

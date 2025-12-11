import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../config/colors.dart';
import '../../services/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameC = TextEditingController();
  File? newImage;
  bool saving = false;

  bool get safeMounted => mounted;

  @override
  void initState() {
    super.initState();
    final user = AuthService.to.firebaseUser.value;
    nameC.text = user?.displayName ?? "";
  }

  @override
  void dispose() {
    nameC.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      if (!safeMounted) return;
      setState(() => newImage = File(picked.path));
    }
  }

  Future<void> saveProfile() async {
    if (!safeMounted) return;

    setState(() => saving = true);

    final name = nameC.text.trim();

    if (name.isNotEmpty) {
      await AuthService.to.updateName(name);
    }

    if (newImage != null) {
      await AuthService.to.updateProfilePhoto(newImage!);
    }

    if (!safeMounted) return;

    setState(() => saving = false);

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.to.firebaseUser.value;

    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   foregroundColor: Colors.white,
      //   title: const Text("Edit Profile"),
      // ),
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
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Column(
            children: [
              InkWell(
                onTap: () => Get.back(),
                child: Row(
                  children: [
                    InkWell(
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.white,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      "Back",
                      style: GoogleFonts.poppins(
                        fontSize: 17.sp,
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 12.h,
                  width: 12.h,
                  // color: Colors.white,
                ),
              ),
              SizedBox(height: 2.h),
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage: newImage != null
                      ? FileImage(newImage!)
                      : (user?.photoURL != null
                                ? NetworkImage(user!.photoURL!)
                                : null)
                            as ImageProvider?,
                  child: (newImage == null && user?.photoURL == null)
                      ? const Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.white70,
                        )
                      : null,
                ),
              ),

              SizedBox(height: 3.h),

              TextField(
                controller: nameC,
                style: GoogleFonts.inter(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Full Name",
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white38),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),

              SizedBox(height: 4.h),

              GestureDetector(
                onTap: saving ? null : saveProfile,
                child: Container(
                  height: 6.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.signupButtonGradient,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      saving ? "Saving..." : "Save Changes",
                      style: GoogleFonts.inter(
                        fontSize: 17.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

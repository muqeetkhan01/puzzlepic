import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../widgets/app_text_field.dart';
import '../../config/colors.dart';
import '../../services/auth_service.dart';
import '../../widgets/gradient_scaffold.dart';

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

    return GradientScaffold(
      // backgroundColor: Colors.black,
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   foregroundColor: Colors.white,
      //   title: const Text("Edit Profile"),
      // ),
      body: Container(
        width: 100.w,
        height: 100.h,
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   colors: AppColors.backgroundGradient,
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          // ),
        ),
        child: SingleChildScrollView(
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

              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 1.h),
                  child: Text(
                    "Full Name",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              AppTextField(
                controller: nameC,
                hint: "John Doe",
                icon: Icons.person,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.name],
              ),

              SizedBox(height: 4.h),

              GestureDetector(
                onTap: saving ? null : saveProfile,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 1.8.h),
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

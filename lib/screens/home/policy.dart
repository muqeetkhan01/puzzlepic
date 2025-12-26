import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puzzle_app/config/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
        child: SafeArea(
          child: Column(
            children: [
              _topBar("Privacy Policy"),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  child: _glassContainer(
                    child: Text(
                      _privacyText,
                      style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        color: Colors.white70,
                        height: 1.6,
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

  Widget _topBar(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          SizedBox(width: 3.w),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassContainer({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: EdgeInsets.all(5.w),
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
}

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

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
        child: SafeArea(
          child: Column(
            children: [
              _topBar("Terms of Service"),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  child: _glassContainer(
                    child: Text(
                      termsText,
                      style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        color: Colors.white70,
                        height: 1.6,
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

  Widget _topBar(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          SizedBox(width: 3.w),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassContainer({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: EdgeInsets.all(5.w),
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
}

const String termsText = '''
Terms of Service

Effective Date: 28th December 2025

Welcome to PuzzlePic. By accessing or using this application, you agree to be bound by these Terms of Service. If you do not agree with any part of these terms, you must not use the app.

1. Use of the App  
This application is intended for personal, non-commercial use only. You agree to use the app lawfully and in a way that does not harm, disable, or impair the service or other users.

2. User Accounts  
You are responsible for maintaining the confidentiality of your account credentials. Any activity performed using your account is your responsibility.

3. Gameplay & Fair Use  
Game results, scores, and statistics are recorded automatically by the system. Any attempt to cheat, manipulate gameplay data, exploit bugs, or gain unfair advantages may result in suspension or permanent termination of your account.

4. Multiplayer Conduct  
In multiplayer modes, users must behave respectfully. Harassment, abuse, or disruptive behavior toward other players is strictly prohibited.

5. Intellectual Property  
All content, graphics, logos, animations, and software associated with the app are the property of the app owner. You may not copy, modify, distribute, or reverse engineer any part of the application.

6. Data & Statistics  
Gameplay data such as scores, time played, and achievements may be stored to enhance user experience and enable leaderboards and progress tracking.

7. Service Availability  
We reserve the right to modify, suspend, or discontinue any part of the service at any time without prior notice.

8. Disclaimer  
The application is provided "as is" without warranties of any kind, either express or implied. We do not guarantee uninterrupted or error-free operation.

9. Limitation of Liability  
We are not liable for any direct or indirect damages resulting from the use or inability to use the application.

10. Changes to Terms  
These Terms of Service may be updated from time to time. Continued use of the app after changes implies acceptance of the updated terms.

11. Contact  
If you have any questions regarding these Terms of Service, please contact us through the app’s support section.

By using this application, you acknowledge that you have read, understood, and agreed to these Terms of Service.
''';
const String _privacyText = '''
Privacy Policy

Effective Date: December 20, 2025
Last Updated: December 20, 2025

Puzzle Pics of the World, LLC (“Company,” “we,” “our,” or “us”) respects your privacy and is committed to protecting the personal information you share with us. This Privacy Policy explains how we collect, use, store, protect, and disclose information when you use the Puzzle Pics mobile application or related services (collectively, the “App”).

Company Name: Puzzle Pics of the World, LLC
Contact Email: Playpuzzlepics@gmail.com
Website: https://playpuzzlepics.com

By downloading, accessing, or using Puzzle Pics, you agree to the practices described in this Privacy Policy.

1. Information We Collect
We collect personal information you voluntarily provide, including photos and images uploaded from your device, user profile information, and communications with customer support. Uploaded photos may contain personal or sensitive information depending on the content provided by the user.

We may also automatically collect information such as device type, operating system, IP address, unique device identifiers, usage statistics, and crash diagnostics.

2. How We Use Your Information
We use collected information to operate, maintain, and improve Puzzle Pics; process and transform uploaded photos; provide customer support; protect App security; and comply with legal obligations. We do not sell personal information.

3. Photo Retention Policy
Photos uploaded to Puzzle Pics are processed in real time and are not stored on our servers. Once processing is complete, photos are immediately discarded and are not retained by Puzzle Pics of the World, LLC.

4. AI and Image Processing Disclosure
Puzzle Pics uses automated image processing technologies, including artificial intelligence (AI), to analyze and transform user-submitted photos solely to generate puzzle-based outputs and deliver App functionality. Uploaded photos are not used to train artificial intelligence models or for marketing purposes.

5. Sharing of Information
Information may be shared with trusted service providers who assist with hosting, analytics, or app functionality, and with legal authorities when required by law. Personal photos are never shared for advertising or marketing purposes.

6. Data Security
We implement reasonable administrative, technical, and physical safeguards to protect personal information. However, no method of transmission or storage is completely secure.

7. Children’s Privacy
Puzzle Pics is not intended for children under the age of 13 (or under 16 where required by law). We do not knowingly collect personal information from children.

8. App Store Compliance (Apple & Google)
Puzzle Pics complies with Apple App Store and Google Play requirements, including obtaining user permission before accessing photos, limiting data collection to necessary purposes, and honoring user requests for data deletion.

9. Changes to This Privacy Policy
We may update this Privacy Policy from time to time. Continued use of the App constitutes acceptance of the updated policy.



Terms of Service

Effective Date: December 20, 2025

These Terms of Service (“Terms”) govern your access to and use of Puzzle Pics. By accessing or using the App, you agree to be bound by these Terms.

1. Eligibility and Use
You must be at least 13 years old to use Puzzle Pics. You agree to use the App only for lawful purposes.

2. User Content
You retain ownership of photos and content you upload. By uploading content, you grant Puzzle Pics of the World, LLC a limited, non-exclusive license to process the content solely to operate and provide the App’s services.

3. Prohibited Content
You may not upload content that is unlawful, infringing, abusive, explicit, or violates the rights of others.

4. Intellectual Property
All App features, branding, and functionality (excluding user content) are the property of Puzzle Pics of the World, LLC and are protected by applicable laws.

5. Termination
We may suspend or terminate access to Puzzle Pics at our discretion for violations of these Terms.

6. Disclaimer of Warranties
Puzzle Pics is provided “as is” without warranties of any kind.

7. Limitation of Liability
To the fullest extent permitted by law, Puzzle Pics of the World, LLC shall not be liable for indirect, incidental, or consequential damages.

8. Governing Law
These Terms are governed by the laws of the State of Louisiana.



GDPR & CCPA Addendum

GDPR (European Economic Area Users)
If you are located in the European Economic Area, you have the right to access, correct, delete, restrict, or object to the processing of your personal data, as well as the right to data portability. Processing is based on user consent and legitimate business interests.

CCPA (California Users)
California residents have the right to request disclosure of personal information collected, request deletion of personal data, and receive equal service regardless of exercising privacy rights. Puzzle Pics of the World, LLC does not sell personal information.

Privacy requests may be submitted by emailing Playpuzzlepics@gmail.com.''';

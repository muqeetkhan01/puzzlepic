import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puzzle_app/firebase_options.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:firebase_core/firebase_core.dart';
import 'services/auth_service.dart';
import 'screens/auth/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put(AuthService()); // MUST be before runApp()

  runApp(const PuzzleApp());
}

class PuzzleApp extends StatelessWidget {
  const PuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          title: "PuzzlePic",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: false,
            scaffoldBackgroundColor: const Color(0xFFF9F9F9),
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}

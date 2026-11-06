import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:puzzle_app/firebase_options.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:firebase_core/firebase_core.dart';
import 'services/auth_service.dart';
import 'config/app_theme.dart';
import 'controllers/theme_controller.dart';
import 'screens/auth/splash.dart';
import 'services/haptics.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put(AuthService()); // MUST be before runApp()

  await Haptics.load();

  final themeController = Get.put(ThemeController());
  await themeController.load();

  runApp(const PuzzleApp());
}

class PuzzleApp extends StatelessWidget {
  const PuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return Obx(() {
          return GetMaterialApp(
            title: "PuzzlePic",
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(themeController.style.value),
            darkTheme: AppTheme.dark(themeController.style.value),
            themeMode: themeController.themeMode,
            home: const SplashScreen(),
          );
        });
      },
    );
  }
}

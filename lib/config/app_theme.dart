import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/theme_controller.dart';
import 'colors.dart';
import 'theme_gradients.dart';

class AppTheme {
  static ThemeData light(AppThemeStyle style) => _build(style: style, dark: false);
  static ThemeData dark(AppThemeStyle style) => _build(style: style, dark: true);

  static ThemeData _build({required AppThemeStyle style, required bool dark}) {
    final base = (dark ? ThemeData.dark(useMaterial3: false) : ThemeData.light(useMaterial3: false));

    final palette = _palette(style, dark: dark);

    return base.copyWith(
      scaffoldBackgroundColor: palette.scaffold,
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
        bodyColor: palette.onScaffold,
        displayColor: palette.onScaffold,
      ),
      colorScheme: base.colorScheme.copyWith(
        primary: palette.primary,
        secondary: palette.secondary,
        surface: palette.surface,
        onSurface: palette.onSurface,
      ),
      extensions: <ThemeExtension<dynamic>>[
        ThemeGradients(background: palette.backgroundGradient, accent: palette.accentGradient),
      ],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: palette.onScaffold,
        titleTextStyle: GoogleFonts.poppins(
          color: palette.onScaffold,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.fieldFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: palette.fieldBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: palette.fieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: palette.fieldBorderFocused, width: 1.2),
        ),
        hintStyle: TextStyle(color: palette.hint),
        labelStyle: TextStyle(color: palette.label),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          foregroundColor: palette.buttonText,
          backgroundColor: palette.buttonBg,
        ),
      ),
      dividerTheme: DividerThemeData(color: palette.divider),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: palette.snackBg,
        contentTextStyle: GoogleFonts.poppins(color: palette.snackText),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static _ThemePalette _palette(AppThemeStyle style, {required bool dark}) {
    switch (style) {
      case AppThemeStyle.midnight:
        return _ThemePalette(
          scaffold: dark ? const Color(0xFF0D1A3A) : const Color(0xFFF6F7FB),
          onScaffold: dark ? Colors.white : const Color(0xFF0B1020),
          primary: dark ? AppColors.neonBlue : AppColors.puzzleBlue,
          secondary: AppColors.neonPink,
          surface: dark ? AppColors.white10 : Colors.white,
          onSurface: dark ? Colors.white : const Color(0xFF0B1020),
          backgroundGradient: dark
              ? const [Color(0xFF0D1A3A), Color(0xFF2A1660), Color(0xFF5A2EFF)]
              : const [Color(0xFFF6F7FB), Color(0xFFEFF2FF), Color(0xFFEDE7FF)],
          accentGradient: const [AppColors.neonBlue, AppColors.neonPink],
        );

      case AppThemeStyle.ocean:
        return _ThemePalette(
          scaffold: dark ? const Color(0xFF061A22) : const Color(0xFFF4FBFF),
          onScaffold: dark ? Colors.white : const Color(0xFF04202A),
          primary: dark ? const Color(0xFF2EE7FF) : const Color(0xFF0A84FF),
          secondary: const Color(0xFF00E5A8),
          surface: dark ? Colors.white10 : Colors.white,
          onSurface: dark ? Colors.white : const Color(0xFF04202A),
          backgroundGradient: dark
              ? const [Color(0xFF061A22), Color(0xFF0A3A4A), Color(0xFF0B6B8F)]
              : const [Color(0xFFF4FBFF), Color(0xFFE9FAFF), Color(0xFFDFF5FF)],
          accentGradient: const [Color(0xFF2EE7FF), Color(0xFF00E5A8)],
        );

      case AppThemeStyle.sunrise:
        return _ThemePalette(
          scaffold: dark ? const Color(0xFF1E0B12) : const Color(0xFFFFF7F2),
          onScaffold: dark ? Colors.white : const Color(0xFF2A0E0E),
          primary: dark ? const Color(0xFFFFB000) : const Color(0xFFFF7A00),
          secondary: dark ? const Color(0xFFFF3CF0) : const Color(0xFFFF4B4B),
          surface: dark ? Colors.white10 : Colors.white,
          onSurface: dark ? Colors.white : const Color(0xFF2A0E0E),
          backgroundGradient: dark
              ? const [Color(0xFF1E0B12), Color(0xFF3A0F1C), Color(0xFF6B1B1B)]
              : const [Color(0xFFFFF7F2), Color(0xFFFFF0E6), Color(0xFFFFE6DA)],
          accentGradient: const [Color(0xFFFFB000), Color(0xFFFF3CF0)],
        );
    }
  }
}

class _ThemePalette {
  final Color scaffold;
  final Color onScaffold;
  final Color primary;
  final Color secondary;
  final Color surface;
  final Color onSurface;
  final List<Color> backgroundGradient;
  final List<Color> accentGradient;

  _ThemePalette({
    required this.scaffold,
    required this.onScaffold,
    required this.primary,
    required this.secondary,
    required this.surface,
    required this.onSurface,
    required this.backgroundGradient,
    required this.accentGradient,
  });

  Color get fieldFill => Colors.white.withOpacity(0.10);
  Color get fieldBorder => Colors.white.withOpacity(0.18);
  Color get fieldBorderFocused => Colors.white.withOpacity(0.35);
  Color get hint => Colors.white.withOpacity(0.70);
  Color get label => Colors.white.withOpacity(0.85);

  Color get buttonBg => primary;
  Color get buttonText => Colors.white;

  Color get divider => Colors.white.withOpacity(0.12);

  Color get snackBg => (scaffold.computeLuminance() < 0.5)
      ? Colors.black.withOpacity(0.80)
      : const Color(0xFF0B1020).withOpacity(0.92);

  Color get snackText => Colors.white;
}

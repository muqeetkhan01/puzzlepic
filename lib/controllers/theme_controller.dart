import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeStyle { midnight, ocean, sunrise }

class ThemeController extends GetxController {
  static const _kStyleKey = 'theme_style';
  static const _kDarkKey = 'theme_dark';

  final Rx<AppThemeStyle> style = AppThemeStyle.midnight.obs;
  final RxBool isDark = true.obs;

  ThemeMode get themeMode => isDark.value ? ThemeMode.dark : ThemeMode.light;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final styleIndex = prefs.getInt(_kStyleKey);
    final dark = prefs.getBool(_kDarkKey);

    if (styleIndex != null && styleIndex >= 0 && styleIndex < AppThemeStyle.values.length) {
      style.value = AppThemeStyle.values[styleIndex];
    }
    if (dark != null) {
      isDark.value = dark;
    }
  }

  Future<void> setDark(bool value) async {
    isDark.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kDarkKey, value);
  }

  Future<void> setStyle(AppThemeStyle value) async {
    style.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kStyleKey, value.index);
  }
}

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Small, consistent vibration effects for the whole app.
///
/// Uses Flutter's built-in HapticFeedback, so no extra package or Android
/// permission is needed. Users can turn it off in Settings.
class Haptics {
  Haptics._();

  static const _kKey = 'haptics_enabled';
  static final RxBool enabled = true.obs;

  static Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      enabled.value = prefs.getBool(_kKey) ?? true;
    } catch (_) {
      enabled.value = true;
    }
  }

  static Future<void> setEnabled(bool value) async {
    enabled.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kKey, value);
    if (value) tap();
  }

  /// Buttons and taps.
  static void tap() {
    if (enabled.value) HapticFeedback.lightImpact();
  }

  /// Picking up / moving a puzzle piece, switching tabs.
  static void select() {
    if (enabled.value) HapticFeedback.selectionClick();
  }

  /// A piece landed in its correct spot.
  static void piecePlaced() {
    if (enabled.value) HapticFeedback.mediumImpact();
  }

  /// Login / sign-up success.
  static void success() {
    if (enabled.value) HapticFeedback.lightImpact();
  }

  /// Something went wrong (wrong password, invalid code, lost a match).
  static Future<void> error() async {
    if (!enabled.value) return;
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 120));
    await HapticFeedback.mediumImpact();
  }

  /// Puzzle solved / multiplayer win.
  static Future<void> celebrate() async {
    if (!enabled.value) return;
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 180));
    await HapticFeedback.heavyImpact();
  }
}

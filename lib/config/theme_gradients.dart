import 'package:flutter/material.dart';

/// UI-only theme extension to supply background/accent gradients per theme.
@immutable
class ThemeGradients extends ThemeExtension<ThemeGradients> {
  final List<Color> background;
  final List<Color> accent;

  const ThemeGradients({
    required this.background,
    required this.accent,
  });

  @override
  ThemeGradients copyWith({
    List<Color>? background,
    List<Color>? accent,
  }) {
    return ThemeGradients(
      background: background ?? this.background,
      accent: accent ?? this.accent,
    );
  }

  @override
  ThemeGradients lerp(ThemeExtension<ThemeGradients>? other, double t) {
    if (other is! ThemeGradients) return this;
    return ThemeGradients(
      background: _lerpColors(background, other.background, t),
      accent: _lerpColors(accent, other.accent, t),
    );
  }

  static List<Color> _lerpColors(List<Color> a, List<Color> b, double t) {
    final maxLen = a.length > b.length ? a.length : b.length;
    return List<Color>.generate(maxLen, (i) {
      final ca = a[i % a.length];
      final cb = b[i % b.length];
      return Color.lerp(ca, cb, t) ?? ca;
    });
  }
}

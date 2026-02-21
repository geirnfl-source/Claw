import 'package:flutter/material.dart';

class AppTheme {
  static const Color bgDark = Color(0xFF050505);
  static const Color bgMaroon = Color(0xFF2d080d);
  static const Color indigo = Color(0xFF6366f1);
  static const Color fuchsia = Color(0xFFd946ef);
  static const Color green = Color(0xFF10b981);
  static const Color red = Color(0xFFef4444);
  static const Color cyan = Color(0xFF22d3ee);
  static const Color amber = Color(0xFFf59e0b);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [indigo, fuchsia],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [bgDark, bgMaroon, bgDark],
    stops: [0.0, 0.5, 1.0],
  );

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.transparent,
    fontFamily: 'SF Pro Display',
    colorScheme: const ColorScheme.dark(
      primary: indigo,
      secondary: fuchsia,
      surface: Color(0xFF0f0f19),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
      labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
    ),
  );

  static String formatISK(int amount) {
    final abs = amount.abs();
    final formatted = abs.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
    return '${amount < 0 ? "-" : ""}$formatted ISK';
  }
}
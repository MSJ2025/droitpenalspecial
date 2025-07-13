import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF001F4D)),
    brightness: Brightness.light,
    fontFamily: 'Roboto',
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: Color(0xFFFAF9F6),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF122046),
      foregroundColor: Color(0xFFFAF9F6),
      elevation: 2,
    ),
    cardTheme: CardThemeData(
      color: Color(0xFFFAF9F6),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xFF001F4D),
      brightness: Brightness.dark,
    ),
    fontFamily: 'Roboto',
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: const Color(0xFF181B23),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF122046),
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF222944),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}

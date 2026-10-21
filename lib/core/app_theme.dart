import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryGreen = Color.fromRGBO(30, 123, 58, 1);
  static const Color backgroundLight = Color(0xFFF8F9F8);
  static const Color cardBorder = Color(0xFFE0E0E0);
  static const Color warningRed = Color(0xFFD32F2F);
  static const Color warningOrange = Color(0xFFF57C00);

  static ThemeData get theme {
    return ThemeData(
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: backgroundLight,

      appBarTheme: const AppBarTheme(
        backgroundColor: primaryGreen,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: cardBorder, width: 1),
        ),
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      ),
    );
  }
}

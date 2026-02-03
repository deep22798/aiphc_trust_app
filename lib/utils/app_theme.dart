// import 'package:flutter/material.dart';
//
// class AppTheme {
//   static ThemeData light = ThemeData(
//     brightness: Brightness.light,
//     primarySwatch: Colors.green,
//     scaffoldBackgroundColor: Colors.white,
//     cardColor: Colors.white.withOpacity(0.85),
//   );
//
//   static ThemeData dark = ThemeData(
//     brightness: Brightness.dark,
//     primarySwatch: Colors.green,
//     scaffoldBackgroundColor: Colors.black,
//     cardColor: Colors.black.withOpacity(0.6),
//   );
// }

import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white.withOpacity(0.95),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,

      labelStyle: const TextStyle(fontSize: 14),
      floatingLabelStyle: const TextStyle(color: Colors.green),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.grey.shade400,
          width: 1.2,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.green,
          width: 2,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.4,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),

      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    ),

  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: Colors.black,
    cardColor: Colors.grey.shade900,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade900,

      labelStyle: const TextStyle(fontSize: 14),
      floatingLabelStyle: const TextStyle(color: Colors.green),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.grey.shade700,
          width: 1.2,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.green,
          width: 2,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.4,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),

      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    ),

  );
}

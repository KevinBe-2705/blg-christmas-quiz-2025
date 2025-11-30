// lib/christmas_quiz_app.dart
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'start_screen.dart';

class ChristmasQuizApp extends StatelessWidget {
  const ChristmasQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseScheme = ColorScheme.fromSeed(seedColor: companyBlue);
    final colorScheme = baseScheme.copyWith(
      primary: companyBlue,
      secondary: companyGold,
      tertiary: xmasRed,
      surface: appBackground,
    );

    return MaterialApp(
      title: 'Weihnachtsquiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: appBackground,

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: companyBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: xmasRed),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: companyBlue.withValues(alpha: 0.08),
          selectedColor: companyGold.withValues(alpha: 0.8),
          labelStyle: const TextStyle(color: Colors.black),
        ),
      ),
      home: const StartScreen(),
    );
  }
}

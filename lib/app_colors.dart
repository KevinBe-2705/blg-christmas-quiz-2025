// lib/app_colors.dart
import 'package:flutter/material.dart';

/// Company-Farben
const companyGold = Color.fromARGB(255, 254, 207, 8); // #FECF08
const companyBlue = Color.fromARGB(255, 14, 110, 255); // #0E6EFF;

/// Weihnachtsfarben
const xmasRed = Color(0xFFD32F2F);
const xmasGreen = Color(0xFF2E7D32);

/// Helle, leicht warme Hintergrundfarbe
// const appBackground = Color(0xFFFDF7F2);
final appBackground = companyBlue.withValues(alpha: 0.05);

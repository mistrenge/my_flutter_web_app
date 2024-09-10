import 'package:flutter/material.dart';

// Definiere globale Farben
const Color primaryColor = Color(0xFFAA134A);
const Color secondaryColor = Colors.white;
const Color cardBackgroundColor = Colors.white;
const Color thirdColor = Color(0xFF517486);
const Color fourthColor = Color.fromARGB(255, 36, 95, 115);
const Color filterColor = primaryColor; // Filterfarbe auf primary setzen

// Definiere globale Textstile
TextStyle headerTextStyle = const TextStyle(
  color: secondaryColor,
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

TextStyle subHeaderTextStyle = const TextStyle(
  color: secondaryColor,
  fontSize: 16,
);

TextStyle bodyTextStyle = const TextStyle(
  color: Colors.black,
  fontSize: 14,
);

TextStyle buttonTextStyle = const TextStyle(
  color: primaryColor,
  fontSize: 14,
  fontWeight: FontWeight.bold,
);

// Definiere globale Button-Stile
ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: primaryColor,
  backgroundColor: secondaryColor,
  textStyle: buttonTextStyle,
);

ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: thirdColor,
  backgroundColor: secondaryColor,
  textStyle: buttonTextStyle,
  side: const BorderSide(color: thirdColor),
);

// Definiere das globale Theme
ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    primary: primaryColor,
    onPrimary: secondaryColor,
    secondary: secondaryColor,
    onSecondary: primaryColor, // Für Marker und Cluster
    surface: cardBackgroundColor,
    background: secondaryColor,
    onBackground: Colors.black,
    error: Colors.red,
    onError: secondaryColor,
  ),
  
  appBarTheme: AppBarTheme(
    backgroundColor: secondaryColor,
    titleTextStyle: headerTextStyle.copyWith(color: fourthColor),
    iconTheme: const IconThemeData(color: fourthColor),
    elevation: 4.0, // Ensure default shadow does not appear
    shadowColor: Colors.black.withOpacity(0.8), // Custom shadow color for the bottom
    surfaceTintColor: Colors.transparent, // No tint overlay
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero, // Rounded corners at the bottom
    ),
  ),

  
  textTheme: TextTheme(
    displayLarge: headerTextStyle.copyWith(fontSize: 34),
    displayMedium: headerTextStyle.copyWith(fontSize: 28),
    displaySmall: headerTextStyle.copyWith(fontSize: 22),
    headlineLarge: headerTextStyle.copyWith(fontSize: 20),
    headlineMedium: subHeaderTextStyle,
    headlineSmall: bodyTextStyle.copyWith(fontSize: 18),
    titleLarge: bodyTextStyle,
    titleMedium: bodyTextStyle.copyWith(fontSize: 16),
    titleSmall: bodyTextStyle.copyWith(fontSize: 14),
    bodyLarge: bodyTextStyle,
    bodyMedium: bodyTextStyle.copyWith(fontSize: 12),
    bodySmall: bodyTextStyle.copyWith(fontSize: 10),
    labelLarge: buttonTextStyle,
    labelMedium: buttonTextStyle.copyWith(fontSize: 14),
    labelSmall: buttonTextStyle.copyWith(fontSize: 12),
  ),
  
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: primaryButtonStyle,
  ),
  textButtonTheme: TextButtonThemeData(
    style: secondaryButtonStyle,
  ),
  
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(color: Colors.black),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(color: Colors.black),
    ),
    labelStyle: bodyTextStyle,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
    foregroundColor: secondaryColor,
  ),
);

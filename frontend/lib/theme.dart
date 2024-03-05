// Dans app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color.fromRGBO(26, 7, 79, 1),
          secondary: Color.fromRGBO(149, 203, 72, 1),
          surface: Color.fromARGB(255, 255, 255, 255),
          surfaceVariant: Color.fromRGBO(149, 203, 72, 0.19),
          onSurface: Colors.black87,
          onSecondary: Colors.black87,
          onPrimary: Colors.white,
          background: Color.fromARGB(255, 236, 236, 236),
        ),
        // Définissez d'autres propriétés de thème ici
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color.fromRGBO(26, 7, 79, 1),
            fontFamily: 'Poppins',
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ));
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: Colors.black, // Couleur secondaire pour le thème sombre
      fontFamily: 'Poppins',
      colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary:
              Colors.yellow), // Police de caractères pour le thème sombre
      // Définissez d'autres propriétés de thème sombre ici
    );
  }
}

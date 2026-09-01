import 'package:flutter/material.dart';

/// Theme configuration for Syntrophe Bible Study App
/// Implements light and dark modes with specified color tokens
class AppTheme {
  AppTheme._();

  // Light Mode Colors
  static const Color lightBackground = Color(0xFFF8F6F3);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightPrimary = Color(0xFFB85C38);
  static const Color lightSecondary = Color(0xFF2A9D8F);
  static const Color lightTextPrimary = Color(0xFF1D1D1D);
  static const Color lightTextSecondary = Color(0xFF6B6B6B);
  static const Color lightDivider = Color(0xFFE5E5E5);
  static const Color lightError = Color(0xFFD62828);
  static const Color lightSuccess = Color(0xFF2A9D8F);

  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF0F0F1A);
  static const Color darkSurface = Color(0xFF1A1A2E);
  static const Color darkPrimary = Color(0xFFE07A5F);
  static const Color darkSecondary = Color(0xFF48CAE4);
  static const Color darkTextPrimary = Color(0xFFF0F0F0);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkDivider = Color(0x14FFFFFF); // rgba(255,255,255,0.08)
  static const Color darkError = Color(0xFFFF6B6B);
  static const Color darkSuccess = Color(0xFF4ADE80);

  // Common Colors
  static const Color transparent = Colors.transparent;
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // Highlight Colors
  static const Map<String, Color> highlightColorsLight = {
    'yellow': Color(0xFFFFEB3B),
    'green': Color(0xFFA5D6A7),
    'blue': Color(0xFF90CAF9),
    'purple': Color(0xFFCE93D8),
    'red': Color(0xFFEF9A9A),
    'orange': Color(0xFFFFCC80),
  };

  static const Map<String, Color> highlightColorsDark = {
    'yellow': Color(0xFFFDD835),
    'green': Color(0xFF66BB6A),
    'blue': Color(0xFF42A5F5),
    'purple': Color(0xFFAB47BC),
    'red': Color(0xFFEF5350),
    'orange': Color(0xFFFFA726),
  };

  /// Light Theme Configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      primaryColor: lightPrimary,
      colorScheme: const ColorScheme.light(
        background: lightBackground,
        surface: lightSurface,
        primary: lightPrimary,
        secondary: lightSecondary,
        error: lightError,
        onBackground: lightTextPrimary,
        onSurface: lightTextPrimary,
        onPrimary: white,
        onSecondary: white,
        onError: white,
      ),
      dividerColor: lightDivider,
      textTheme: _buildTextTheme(lightTextPrimary, lightTextSecondary),
      appBarTheme: AppBarTheme(
        backgroundColor: lightSurface,
        foregroundColor: lightTextPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        color: lightSurface,
        elevation: 2,
        shadowColor: black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: lightSurface,
        modalBackgroundColor: lightSurface,
        elevation: 8,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: lightSurface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: TextStyle(
          color: lightTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: TextStyle(
          color: lightTextSecondary,
          fontSize: 16,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: lightPrimary,
        foregroundColor: white,
        elevation: 4,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightError),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return lightPrimary;
          }
          return lightTextSecondary;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return lightPrimary;
          }
          return transparent;
        }),
      ),
    );
  }

  /// Dark Theme Configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      primaryColor: darkPrimary,
      colorScheme: const ColorScheme.dark(
        background: darkBackground,
        surface: darkSurface,
        primary: darkPrimary,
        secondary: darkSecondary,
        error: darkError,
        onBackground: darkTextPrimary,
        onSurface: darkTextPrimary,
        onPrimary: black,
        onSecondary: black,
        onError: black,
      ),
      dividerColor: darkDivider,
      textTheme: _buildTextTheme(darkTextPrimary, darkTextSecondary),
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: darkTextPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        color: darkSurface,
        elevation: 2,
        shadowColor: black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: darkSurface,
        modalBackgroundColor: darkSurface,
        elevation: 8,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: darkSurface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: TextStyle(
          color: darkTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: TextStyle(
          color: darkTextSecondary,
          fontSize: 16,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: darkPrimary,
        foregroundColor: black,
        elevation: 4,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkError),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return darkPrimary;
          }
          return darkTextSecondary;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return darkPrimary;
          }
          return transparent;
        }),
      ),
    );
  }

  static TextTheme _buildTextTheme(Color primaryColor, Color secondaryColor) {
    return TextTheme(
      displayLarge: TextStyle(
        color: primaryColor,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
      displayMedium: TextStyle(
        color: primaryColor,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
      displaySmall: TextStyle(
        color: primaryColor,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      headlineLarge: TextStyle(
        color: primaryColor,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      headlineMedium: TextStyle(
        color: primaryColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      headlineSmall: TextStyle(
        color: primaryColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      titleLarge: TextStyle(
        color: primaryColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      titleMedium: TextStyle(
        color: primaryColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      titleSmall: TextStyle(
        color: primaryColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      bodyLarge: TextStyle(
        color: primaryColor,
        fontSize: 16,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        color: primaryColor,
        fontSize: 14,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        color: secondaryColor,
        fontSize: 12,
        height: 1.4,
      ),
      labelLarge: TextStyle(
        color: primaryColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      labelMedium: TextStyle(
        color: primaryColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      labelSmall: TextStyle(
        color: secondaryColor,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
    );
  }

  /// Scripture text style with serif font
  static TextStyle scriptureTextStyle({
    double fontSize = 18,
    bool isDarkMode = false,
  }) {
    return TextStyle(
      fontFamily: 'CrimsonText',
      fontSize: fontSize,
      color: isDarkMode ? darkTextPrimary : lightTextPrimary,
      height: 1.6,
      fontWeight: FontWeight.normal,
    );
  }

  /// UI text style with sans-serif font
  static TextStyle uiTextStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    bool isDarkMode = false,
  }) {
    return TextStyle(
      fontFamily: 'Inter',
      fontSize: fontSize,
      color: isDarkMode ? darkTextPrimary : lightTextPrimary,
      height: 1.4,
      fontWeight: fontWeight,
    );
  }
}

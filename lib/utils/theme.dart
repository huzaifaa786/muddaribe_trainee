import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class CustomTheme {
  // Define a variable to toggle between light and dark modes
  static bool isDarkMode = false;

  // Function to toggle between light and dark modes
  static void toggleThemeMode() {
    isDarkMode = !isDarkMode;
  }

  // Get the current theme based on the selected mode
  static ThemeData get currentTheme => isDarkMode ? darkTheme : lightTheme;

  // light theme
  static final lightTheme = ThemeData(
    primaryColor: lightThemeColor,
    brightness: Brightness.light,
    scaffoldBackgroundColor: white,
    useMaterial3: true,
    fontFamily: 'Montserrat',
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: borderTop,
    ),
    switchTheme: SwitchThemeData(
      thumbColor:
          MaterialStateProperty.resolveWith<Color>((states) => lightThemeColor),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: white,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: black,
        fontSize: 23, //20
      ),
      iconTheme: IconThemeData(color: lightThemeColor),
      elevation: 0,
      actionsIconTheme: IconThemeData(color: lightThemeColor),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: white,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
  );

  // dark theme
  static final darkTheme = ThemeData(
    primaryColor: darkThemeColor,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: black,
    useMaterial3: true,
    fontFamily: 'Montserrat',
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: borderTop,
    ),
    switchTheme: SwitchThemeData(
      trackColor:
          MaterialStateProperty.resolveWith<Color>((states) => darkThemeColor),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: black,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: white,
        fontSize: 23, //20
      ),
      iconTheme: IconThemeData(color: darkThemeColor),
      elevation: 0,
      actionsIconTheme: IconThemeData(color: darkThemeColor),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: black,
        statusBarIconBrightness: Brightness.light,
      ),
    ),
  );

    static Color lightThemeColor = Colors.black,
      white = Colors.white,
      black = Colors.black,
      darkThemeColor = Colors.blue;
}

  // colors



import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paclub/frontend/constants/constants.dart';

class MyThemes {
  static final lightTheme = ThemeData(
    primaryColor: primaryColor,
    primaryColorLight: primaryLightColor,
    accentColor: accentColor,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: accentColor,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: accentColor),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(primary: accentColor),
    dividerColor: Colors.black,
  );

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColor: primaryColor,
    primaryColorLight: primaryLightColor,
    accentColor: accentColor,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: accentColor,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: accentColor),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    colorScheme: ColorScheme.light(primary: accentColor),
    dividerColor: Colors.white,
    primaryColorDark: primaryDarkColor,
  );
}

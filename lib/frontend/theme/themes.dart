import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paclub/frontend/constants/constants.dart';

final TextStyle darkThemTextStyle = TextStyle(
  color: Colors.grey[200],
);
final TextStyle lightThemTextStyle = TextStyle(
  color: Colors.grey[900],
);

class MyThemes {
  static final lightTheme = ThemeData(
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      unselectedItemColor: Colors.grey[800],
      backgroundColor: Colors.white,
    ),
    primaryColor: primaryColor,
    accentColor: accentColor,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: accentColor,
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      headline1: lightThemTextStyle,
      headline2: lightThemTextStyle,
      headline3: lightThemTextStyle,
      headline4: lightThemTextStyle,
      headline5: lightThemTextStyle,
      headline6: lightThemTextStyle,
      subtitle1: lightThemTextStyle,
      subtitle2: lightThemTextStyle,
      bodyText1: lightThemTextStyle,
      bodyText2: lightThemTextStyle,
      caption: lightThemTextStyle,
    ),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: accentColor),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: accentColor,
    ),
    dividerColor: Colors.black,
  );

  static final darkTheme = ThemeData(
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      unselectedItemColor: Colors.grey[400],
      backgroundColor: Colors.black,
    ),
    scaffoldBackgroundColor: Colors.grey.shade900,
    accentColor: accentColor,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey.shade900,
      foregroundColor: accentColor,
    ),

    // textTheme: GoogleFonts.poppinsTextTheme(),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: accentColor),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    colorScheme: ColorScheme.dark(
      primary: accentColor,
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      headline1: darkThemTextStyle,
      headline2: darkThemTextStyle,
      headline3: darkThemTextStyle,
      headline4: darkThemTextStyle,
      headline5: darkThemTextStyle,
      headline6: darkThemTextStyle,
      subtitle1: darkThemTextStyle,
      subtitle2: darkThemTextStyle,
      bodyText1: darkThemTextStyle,
      bodyText2: darkThemTextStyle,
      caption: darkThemTextStyle,
    ),
    dividerColor: Colors.white,
    primaryColorDark: primaryDarkColor,
  );
}

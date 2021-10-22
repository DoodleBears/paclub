import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paclub/frontend/constants/constants.dart';
import 'package:paclub/frontend/widgets/tabs/rounded_tab_indicator.dart';

final TextStyle darkThemTextStyle = TextStyle(
  color: Colors.grey[200],
);
final TextStyle lightThemTextStyle = TextStyle(
  color: Colors.grey[900],
);

class MyThemes {
  static final lightTheme = ThemeData(
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.blue,
      selectionHandleColor: Colors.blue,
      selectionColor: Colors.blue.withAlpha(128),
    ),
    tabBarTheme: TabBarTheme(
      indicator: RoundedUnderlineTabIndicator(
        width: 40.0,
        borderSide: BorderSide(
          width: 2.5,
          color: accentLightColor,
        ),
        insets: EdgeInsets.only(bottom: 6.0),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      unselectedItemColor: Colors.grey[800],
      enableFeedback: false,
      backgroundColor: Colors.white,
    ),
    primaryColor: primaryColor,
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
      secondary: accentColor,
      secondaryVariant: accentColor,
      primaryVariant: accentColor,
      primary: accentColor,
    ),
    dividerColor: Colors.black,
  );

  static final darkTheme = ThemeData(
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.blue,
      selectionHandleColor: Colors.blue,
      selectionColor: Colors.blue.withAlpha(128),
    ),

    tabBarTheme: TabBarTheme(
      indicator: RoundedUnderlineTabIndicator(
        width: 40.0,
        borderSide: BorderSide(
          width: 2.5,
          color: accentColor,
        ),
        insets: EdgeInsets.only(bottom: 6.0),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      unselectedItemColor: Colors.grey[400],
      enableFeedback: false,
      backgroundColor: Colors.grey[850],
    ),
    scaffoldBackgroundColor: Colors.grey.shade900,
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
      secondary: accentColor,
      secondaryVariant: accentColor,
      primaryVariant: accentColor,
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paclub/frontend/constants/constants.dart';

ThemeData get appThemeData => ThemeData(
      primaryColor: primaryColor,
      primaryColorLight: primaryLightColor,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: appBarTheme,
      textTheme: GoogleFonts.poppinsTextTheme(),
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );

AppBarTheme get appBarTheme => AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: accentColor,
    );

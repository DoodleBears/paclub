import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// App主题，包含: 颜色，字体大小等
const accentColor = Color(0xFF96C336);
const accentLightColor = Color(0xFFB3D270);
const accentDarkColor = Color(0xFF75A118);
const primaryColor = Color(0xFFF0BF84);
const primaryLightColor = Color(0xFFFCF4E9);
const primaryDarkColor = Color(0xFF9F7C53);
// const primaryTextColor = Color(0xFFF1E6FF);
// const secondaryTextColor = Color(0xFFF1E6FF);

ThemeData get appThemeData => ThemeData(
    primaryColor: primaryColor,
    primaryColorLight: primaryLightColor,
    scaffoldBackgroundColor: Colors.white,
    accentColor: accentColor,
    appBarTheme: appBarTheme,
    textTheme: GoogleFonts.poppinsTextTheme());

AppBarTheme get appBarTheme => AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: accentColor,
    );

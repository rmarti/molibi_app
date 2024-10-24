import 'package:flutter/material.dart';


class MolibiThemeData {
   
  static const molibiGreen1 =  Color(0xFF006769 );
  static const molibiGreen2 =  Color(0xFF40A578);  
  static const molibiGreen3 =  Color(0xFF9DDE8B);
  static const molibiGreen4 =  Color(0xFFE6FF94);
  static const molibiGrey1 =  Color(0xFF1A1A1A);
  static const molibiGrey2 =  Color(0xFF646769);
  static const molibiGrey3 =  Color(0xFFABB3B6);
  static const molibiGrey4 =  Color(0xFFE8F1F5);

  static const molibilight = Colors.white;
  static const molibidark =  Colors.black;

  static const molibierror =  Colors.redAccent;
  static const molibisuccess =  molibiGreen2;
  static const molibiinfo =  Color.fromRGBO(255, 179, 0, 1);



  static const ColorScheme lightColorScheme = ColorScheme(
    primary: molibiGreen1,
    onPrimary: molibilight,
    secondary: molibiGreen2,
    onSecondary: molibilight,
    error: Colors.redAccent,
    onError: molibilight,
    surface: molibilight,
    onSurface: molibiGrey2,
    brightness: Brightness.light,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    primary: molibiGreen1,
    onPrimary: molibilight,
    secondary: molibiGreen2,
    onSecondary: molibilight,
    error: Colors.redAccent,
    onError: molibilight,
    surface: molibiGrey1,
    onSurface: molibiGrey4,
    brightness: Brightness.light,
  );



  static final ThemeData lightTheme = ThemeData(
    colorScheme: lightColorScheme,
    primaryColor: lightColorScheme.primary,
    canvasColor: lightColorScheme.surface,
    brightness: lightColorScheme.brightness,
    scaffoldBackgroundColor: molibilight
  );


  static final ThemeData darkTheme = ThemeData(
    colorScheme: darkColorScheme,
    primaryColor: lightColorScheme.primary,
    canvasColor: lightColorScheme.surface,
    brightness: lightColorScheme.brightness,
  );

  
}
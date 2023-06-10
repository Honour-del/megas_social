import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/size_config.dart';
// import 'package:megas/src/services/shared_prefernces.dart';



  class Themes{
    static final lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      focusColor: primary_color, // appbar icons
      primaryColorDark: Colors.black, // for normal icon color
      primaryColor: Colors.white,
      textTheme: TextTheme(
        titleLarge: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w500
        ),
        labelMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: Colors.white70,
        ),
        labelSmall: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 14,),
        labelLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Colors.black,
        ),
        displaySmall: TextStyle( // for feed captions
          fontSize: getFontSize(14),
          fontWeight: FontWeight.normal,
          color: Colors.grey[800],
        ),
        bodyMedium: TextStyle( /// used inside drawer
            color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700
        ),
        bodySmall: TextStyle( /// used inside drawer
            color: Colors.black, fontSize: 13, fontWeight: FontWeight.w100
        ),
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: primary_color,
      ),
      iconTheme: IconThemeData(
        color: primary_color,
      ),
      cardColor: primary_color,
      cardTheme: CardTheme(
        color: Colors.black,
        shadowColor: Colors.white,
      ),
      dividerColor: Colors.grey,
    );

    static final darkTheme = ThemeData(
      scaffoldBackgroundColor: Colors.black,
      primaryColorDark: Colors.white,
      primaryColor: Colors.blueGrey,
      focusColor: Colors.white, // appbar icons
      cardColor: Colors.grey,
      textTheme: TextTheme(
        titleLarge: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500
        ),
        displaySmall: TextStyle( // for feed captions
          fontSize: getFontSize(14),
          fontWeight: FontWeight.normal,
          color: Colors.white70,
        ),
        labelMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: Colors.grey[900],
        ),
        labelLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
        labelSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14,
          overflow: TextOverflow.ellipsis,
        ),
        bodyMedium: TextStyle( /// used inside drawer
            color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700
        ),
        bodySmall: TextStyle( /// used inside drawer
            color: Colors.white, fontSize: 13, fontWeight: FontWeight.w100
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: Colors.black,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      cardTheme: CardTheme(
        color: Colors.black,
      ),
      dividerColor: Colors.grey,
    );
  }

final themeNotifierProvider = StateNotifierProvider<ThemeProvider, ThemeMode?>((ref) {
  return ThemeProvider();
});

  class ThemeProvider extends StateNotifier<ThemeMode?>{
    ThemeProvider() : super(ThemeMode.system);
    void changeTheme(bool isON){
      state = isON ? ThemeMode.dark : ThemeMode.light;
    }
  }

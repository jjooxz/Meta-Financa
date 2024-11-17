import 'package:flutter/material.dart';

const kPrimaryColor = Color.fromARGB(255, 104, 0, 0);

const kCategoryListColorLight = Color.fromARGB(255, 109, 109, 109);
const kCategoryListColorDark = Color.fromARGB(255, 163, 163, 163);

const kBackgroundColorLight = Color(0xFFFEFEFE);
const kBackgroundColorDark = Color.fromARGB(255, 34, 34, 34);

const kTextColorLight = Color(0xFF000000);
const kTextColorDark = Color(0xFFFEFEFE);

const kNavBarColorLight = Color.fromARGB(255, 80, 80, 80);
const kNavBarColorDark = Color.fromARGB(255, 116, 115, 115);

final ThemeData lightTheme = ThemeData(
  primaryColor: kBackgroundColorLight,
  textTheme: const TextTheme(
    headlineSmall: TextStyle(fontSize: 24, color: kTextColorLight, fontWeight: FontWeight.bold),
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    brightness: Brightness.light,
    surface: kBackgroundColorLight,
    onSurface: kTextColorLight,
    primary: kNavBarColorLight,
    secondary: kTextColorDark
  ),
);

final ThemeData darkTheme = ThemeData(
  primaryColor: kBackgroundColorDark,
  textTheme: const TextTheme(
    headlineSmall: TextStyle(fontSize: 24, color: kTextColorDark, fontWeight: FontWeight.bold),
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    brightness: Brightness.dark,
    surface: kBackgroundColorDark,
    secondary: kTextColorLight,
    onSurface: kTextColorDark,
    primary: kNavBarColorDark,
  ),
);
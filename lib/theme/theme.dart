import 'package:flutter/material.dart';
import 'package:tbr_test_task/utils/constants.dart';

final ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: background,
  fontFamily: "Inter",
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    backgroundColor: background,
    titleTextStyle: TextStyle(
      color: title,
      fontFamily: "Inter",
      fontSize: 24,
      fontWeight: FontWeight.w500,
    ),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: title,
      fontFamily: "Inter",
      fontSize: 24,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: TextStyle(
      color: title,
      fontFamily: "Inter",
      fontSize: 20,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
    ),
    bodyMedium: TextStyle(
      color: accentColor,
      fontFamily: "Inter",
      fontSize: 16,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      color: font,
      fontFamily: "Inter",
      fontSize: 16,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
    ),
  ),
);

import 'package:flutter/material.dart';

import 'colors.dart';

final theme = ThemeData(
  appBarTheme: AppBarTheme(
    titleTextStyle: const TextStyle(
      color: black,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
    centerTitle: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      disabledBackgroundColor: gray,
      disabledForegroundColor: light,
      padding: const EdgeInsets.all(10),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
);

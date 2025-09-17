import 'package:flutter/material.dart';

import 'colors.dart';

const fontFamily = 'HelveticaNeue';

final theme = ThemeData(
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    scrolledUnderElevation: 0.0,
    titleTextStyle: const TextStyle(
      color: black,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: primary,
    selectedLabelStyle: const TextStyle(
      color: primary,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
    unselectedLabelStyle: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: primary,
    primary: primary,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: light,
    constraints: BoxConstraints(
      maxHeight: 550,
      minHeight: 400,
    ),
    dragHandleColor: Color(0xFFE0E0E0),
    dragHandleSize: Size(48, 5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    showDragHandle: true,
  ),
  checkboxTheme: CheckboxThemeData(
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
    side: const BorderSide(color: gray),
    visualDensity: const VisualDensity(
      horizontal: VisualDensity.minimumDensity,
      vertical: VisualDensity.minimumDensity,
    ),
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
  fontFamily: fontFamily,
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 10,
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: graySecondary,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: graySecondary,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: danger,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: primary,
        width: 2,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: danger,
        width: 2,
      ),
    ),
    filled: true,
    fillColor: light,
    hintStyle: const TextStyle(
      color: gray,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    prefixIconColor: gray,
  ),
  tabBarTheme: const TabBarThemeData(
    dividerColor: Colors.transparent,
    indicatorColor: primary,
    indicatorSize: TabBarIndicatorSize.tab,
    labelStyle: const TextStyle(
      color: primary,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    unselectedLabelStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
  ),
  useMaterial3: true,
);

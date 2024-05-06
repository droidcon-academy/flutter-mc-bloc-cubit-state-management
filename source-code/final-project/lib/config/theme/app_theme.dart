import 'package:flutter/material.dart';
import '../../utils/constants.dart';

ThemeData appTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    background: backgroundColor,
    primary: primaryDark,
    secondary: secondaryDark,
  ),
  useMaterial3: true,
);

import 'package:dipetakan/util/theme/custom_themes/appbar_theme.dart';
import 'package:dipetakan/util/theme/custom_themes/buttom_sheet_theme.dart';
import 'package:dipetakan/util/theme/custom_themes/checkbox_theme.dart';
import 'package:dipetakan/util/theme/custom_themes/chip_theme.dart';
import 'package:dipetakan/util/theme/custom_themes/elevated_button_theme.dart';
import 'package:dipetakan/util/theme/custom_themes/outlined_button_theme.dart';
import 'package:dipetakan/util/theme/custom_themes/text_field_theme.dart';
import 'package:dipetakan/util/theme/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';

class DAppTheme {
  DAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    brightness: Brightness.light,
    primaryColor: Colors.green,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: DAppBarTheme.lightAppBarTheme,
    bottomSheetTheme: DBottomSheetTheme.lightBottomSheetTheme,
    checkboxTheme: DCheckboxTheme.lightCheckboxTheme,
    chipTheme: DChipTheme.lightChipTheme,
    elevatedButtonTheme: DElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: DOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: DTextFormFieldTheme.lightInputDecorationTheme,
    textTheme: DTextTheme.lightTextTheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    brightness: Brightness.dark,
    primaryColor: Colors.green,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: DAppBarTheme.darkAppBarTheme,
    bottomSheetTheme: DBottomSheetTheme.darkBottomSheetTheme,
    checkboxTheme: DCheckboxTheme.darkCheckboxTheme,
    chipTheme: DChipTheme.darkChipTheme,
    elevatedButtonTheme: DElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: DOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: DTextFormFieldTheme.darkInputDecorationTheme,
    textTheme: DTextTheme.darkTextTheme,
  );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// This extension enables us to simplify access and label our theme components
/// since BuildContext instance is passed to every single Widget , we can set
/// and access specific theme by name , which are all public member.
///
/// These public members can be accessed as:
/// - context.appBackground
/// - context.appTitle
/// - context.widgetBackground
/// - and so on

extension AppThemeContext on BuildContext {
  /// Color theme for app components
  Color get appBackground => Theme.of(this).colorScheme.surface;
  Color get widgetBackground => const Color(0xFFC5E4F3); // Updated to #c5e4f3
  Color get genderIconColor => const Color(0xFF4F4F4F); // Dark grey color
  Color get themeSettingsIconColor => Colors.white;

  Color get switchActiveTrackColor => Colors.white;
  Color get switchInactiveTrackColor => Colors.grey;
  Color get switchActiveThumbColor => Theme.of(this).colorScheme.primary;
  Color get switchInactiveThumbColor => Colors.black87;

  Color get sliderActiveColor => Colors.black87;
  Color get sliderInactiveColor => Colors.grey;

  /// Text theme for app components
  TextStyle get appTitle => Theme.of(this).textTheme.headlineLarge!;
  TextStyle get widgetTitle => Theme.of(this).textTheme.titleLarge!;
  TextStyle get widgetInfo => Theme.of(this).textTheme.bodyLarge!;
  TextStyle get resultName => Theme.of(this).textTheme.titleLarge!;

  /// Variation of existing theme
  TextStyle get resultNumbers => Theme.of(this).textTheme.titleLarge!.copyWith(
    color: const Color(0xFF4F4F4F), // Dark grey for BMI result numbers
    fontWeight: FontWeight.bold,
  );

  TextStyle get selectedWheelText =>
      Theme.of(this).textTheme.headlineLarge!.copyWith(
        fontFamily: GoogleFonts.roboto.toString(),
        fontWeight: FontWeight.w700,
        color: const Color(0xFF4F4F4F), // Dark grey for age/height/weight
      );

  TextStyle get unSelectedWheelText =>
      Theme.of(this).textTheme.bodyMedium!.copyWith(
        fontFamily: GoogleFonts.roboto.toString(),
        color: const Color(0xFF4F4F4F), // Dark grey for unselected text
      );

  /// Theme settings title and labels
  TextStyle get themeWidgetTitle => Theme.of(this)
      .textTheme
      .titleLarge!
      .copyWith(fontSize: 15, color: const Color(0xFF4F4F4F)); // Dark grey
}

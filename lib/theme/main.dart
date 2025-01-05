import 'package:SihatSelaluApp/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// class AppTheme
/// this is a Singleton class , ensuring we get exact same theme across the app
///  this is where we define out custom theme colors and fonts. however ,
///  color palate is defined in colors.dart
///
/// properties:
/// title: one of theme title(key) listed in colorPalate dictionary , defaults
/// to the last key in colorPalate dictionary
/// brightness: brightness setting for theme to choose from, i.e. dark or light
/// defaults to dark
/// contrast: contrast to be used for the theme defaults to 0.0
///
/// private members:
/// - _colors: returns colors set for the chosen theme
///
/// pubic members:
/// title: get current theme title/name
/// brightness: get current brightness
/// contrast: get current contrast level
///
/// themeData: returns customised instance of ThemData
///
/// following set of members trigger rebuild of theme
/// setTitle: update/change current theme name (and effectively colors and fonts)
/// setBrightness: update/change current theme brightness
/// setContrast: update/change current theme contrast
///
/// dependencies:
/// - google fonts: this should be replaced with font from assets in prod instead
/// of depending upon the google font package which in turn depends upon the
/// availability of the internet
///
class AppTheme {
  late String _title;
  late Brightness _brightness;
  late double _contrast;

  static final _appTheme = AppTheme._internal();

  AppTheme._internal();

  factory AppTheme({
    String? title,
    Brightness? brightness,
    double? contrast,
  }) {
    _appTheme._title = title ?? colorPalate.keys.last.toString();
    _appTheme._brightness = brightness ?? Brightness.dark;
    _appTheme._contrast = contrast ?? 0.0;
    return _appTheme;
  }

  get _colors => colorPalate[title];

  get title => _appTheme._title;
  get brightness => _appTheme._brightness;
  get contrast => _appTheme._contrast;

  set setTitle(String title) => _appTheme._title = title;
  set setBrightness(Brightness brightness) =>
      _appTheme._brightness = brightness;
  set setContrast(double contrast) => _appTheme._contrast = contrast;

  get themeData => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: brightness,
          contrastLevel: contrast,
          seedColor: _colors["primary"],
          surface: _colors["surface"], // widget title , widget Info
          // onSurface: _colors["onSurface"], // app title , unselected Wheel text
          primary: _colors["primary"], // Primary color app background
          // onPrimary: _colors["onPrimary"], // scroll wheel selected item color
          // primaryContainer: _colors["primaryContainer"],
          // onPrimaryContainer: _colors["onPrimaryContainer"],
          secondary: _colors["secondary"], // widget background
          // onSecondary: _colors["onSecondary"],
          error: _colors["error"],
          onError: _colors["onError"],
        ),
        fontFamily: GoogleFonts.roboto().toString(),

        /// TextTheme mapping to app
        /// headlineLarge => OnSurface => appTitle
        /// titleLarge => onPrimary => WidgetTitle
        /// bodyLarge => onSurface => WidgetInfo

        textTheme: GoogleFonts.texturinaTextTheme().copyWith(
            headlineLarge: GoogleFonts.handlee(
              fontWeight: FontWeight.bold,
              color: _colors["onSurface"],
              letterSpacing: 1.2,
            ),
            titleLarge: GoogleFonts.texturina(
              color: _colors["surface"],
              fontWeight: FontWeight.bold,
            ),
            bodyLarge: GoogleFonts.robotoCondensed(
                color: _colors["surface"], fontWeight: FontWeight.w600)),
      );
}

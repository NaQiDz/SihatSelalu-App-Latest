import 'package:flutter/material.dart';

/// this is rather map of constant string and map,
/// - first key is theme title
/// - second is map of String and, Color
///   - second map strings map one-to-one with colorScheme properties
///
/// I have used, Material Color Map https://www.materialpalette.com/blue/light-blue for theme blue and, every other theme
///
/// following is what worked best for colorScheme.fromSeed for me, mapping color labels
/// from https://www.materialpalette.com/ to , colorScheme properties
///
/// note: I'm not expert at picking color , this is something that looked just
/// enough right to me and, sure can be improved lot by someone with better eye
/// for the UX/UI
///
/// Dark Primary Color -> surface
/// Text/Icons -> onSurface
/// Primary Color -> Primary
/// Primary Text -> onPrimary
/// Accent Color ->  Primary Container
/// secondary text -> onPrimary Container
/// light primary -> Secondary Container
/// secondary text -> onSecondary container
/// RedColor => Error
/// whiteColor => onError

Map<String, Map<String, Color>> colorPalate = const {
  "teal": {
    "surface": Color(0xFF00796b), // widget title , widget Info
    "onSurface": Color(0xFFFFFFFF), // app title , unselected Wheel text
    "primary": Color(0xFF009688), // Primary color app background
    "onPrimary": Color(0xFF212121), // scroll wheel selected item color
    "primaryContainer": Color(0xFF00bcd4),
    "onPrimaryContainer": Color(0xFF757575),
    "secondary": Color(0xFFffccbc), // widget background
    "onSecondary": Color(0xFF757575),
    "error": Color(0xFFd32f2f),
    "onError": Color(0XFFFFFFFF),
  },
  "orange": {
    "surface": Color(0xFFe64a19), // widget title , widget Info
    "onSurface": Color(0xFFFFFFFF), // app title , unselected Wheel text
    "primary": Color(0xFFff5722), // Primary color app background
    "onPrimary": Color(0xFF212121), // scroll wheel selected item color
    "primaryContainer": Color(0xFFff9800),
    "onPrimaryContainer": Color(0xFF757575),
    "secondary": Color(0xFFffccbc), // widget background
    "onSecondary": Color(0xFF757575),
    "error": Color(0xFFd32f2f),
    "onError": Color(0XFFFFFFFF),
  },
  "blue": {
    "surface": Color(0xFF1976d2), // widget title , widget Info
    "onSurface": Color(0xFFFFFFFF), // app title , unselected Wheel text
    "primary": Color(0xFF2196f3), // Primary color app background
    "onPrimary": Color(0xFF212121), // scroll wheel selected item color
    "primaryContainer": Color(0xFF03a9f4),
    "onPrimaryContainer": Color(0xFF212121),
    "secondary": Color(0xFFbbdefb), // widget background
    "onSecondary": Color(0xFF757575),
    "error": Color(0xFFd32f2f),
    "onError": Color(0XFFFFFFFF),
  }
};

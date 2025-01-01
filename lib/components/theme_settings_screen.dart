import 'package:SihatSelaluApp/components/bmi_display.dart';
import 'package:SihatSelaluApp/theme/colors.dart';
import 'package:SihatSelaluApp/theme/context.dart';
import 'package:SihatSelaluApp/valueSelection/values.dart';
import 'package:flutter/material.dart';

/// class ThemeSettingScreen
/// this class, provides the screen for modal to change following theme settings
/// - brightness
/// - color
/// - contrast levels
///
/// properties:
/// - themeUpdater: function to update theme settings and, it is originally
/// defined in MyApp. which eventually triggers rebuild whole app to apply new
/// theme
///
/// note: this kinda of function passing can be avoided by using some sort of
/// state manager such as provider or simple ValueNotify listener
///
///
/// private members:
/// - _brightnessSelector: provides Widget to select between dark/light levels
/// of brightness
///
/// - _themeSelector: lists available theme as circular rings of theme primary
/// color and, current selected theme is filled with same primary color
///
/// - _contrastSelector: slider to set theme contrast values between range of
/// -1.0 to 1.0
///
/// dependencies:
/// - BMIDisplay
class ThemeSettingsScreen extends StatelessWidget {
  final Function(
      {required String name,
      required Brightness brightness,
      required double contrast}) themeUpdater;

  const ThemeSettingsScreen(
      {required this.themeUpdater, themeColors, super.key});

  @override
  Widget build(BuildContext context) {
    Text brightnessText = Text("Brightness", style: context.themeWidgetTitle);
    Text themeText = Text("Color", style: context.themeWidgetTitle);
    Text contrastText = Text("Contrast", style: context.themeWidgetTitle);

    return BMIDisplay(
        title: "Theme Settings",
        isResult: true,
        widget: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: brightnessText),
                const SizedBox(width: 20),
                Flexible(child: _brightnessSelector(context)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: themeText),
                const SizedBox(width: 10),
                Flexible(
                    flex: 2,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: _themeSelector(
                            context))), // For multiple theme options
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: contrastText),
                const SizedBox(width: 10),
                Expanded(flex: 4, child: _contrastSelector(context)),
              ],
            ),
          ],
        ));
  }

  Widget _brightnessSelector(BuildContext context) {
    return Switch(
      activeTrackColor: context.switchActiveTrackColor,
      inactiveTrackColor: context.switchInactiveTrackColor,
      activeColor: context.switchActiveThumbColor,
      inactiveThumbColor: context.switchInactiveThumbColor,
      value: appTheme.brightness == Brightness.light,
      onChanged: (value) => {
        themeUpdater(
            name: appTheme.title,
            brightness: value ? Brightness.light : Brightness.dark,
            contrast: appTheme.contrast)
      },
    );
  }

  List<Widget> _themeSelector(BuildContext context) {
    final List<String> themeColors =
        colorPalate.keys.toList().reversed.toList(growable: false);

    final String currentTheme = appTheme.title;
    return List<Widget>.generate(themeColors.reversed.length, (index) {
      String thisTheme = themeColors[index];
      bool isSelected = (currentTheme == thisTheme);
      Color themeColor = colorPalate[thisTheme]!["primary"]!;

      Icon notSelectedThemeIcon = Icon(
        Icons.circle_outlined,
        size: 30,
        color: themeColor,
      );

      Icon selectedThemeIcon = Icon(
        Icons.circle,
        size: 30,
        color: themeColor,
      );

      return IconButton(
        icon: isSelected ? selectedThemeIcon : notSelectedThemeIcon,
        onPressed: () {
          themeUpdater(
              name: thisTheme,
              brightness: appTheme.brightness,
              contrast: appTheme.contrast);
        },
      );
    });
  }

  Widget _contrastSelector(BuildContext context) {
    return Slider(
        min: -1.0,
        max: 1.0,
        activeColor: context.sliderActiveColor,
        inactiveColor: context.sliderInactiveColor,
        value: appTheme.contrast,
        onChanged: (value) {
          themeUpdater(
              name: appTheme.title,
              brightness: appTheme.brightness,
              contrast: value);
        });
  }
}

import 'package:SihatSelaluApp/components/bmi_display.dart';
import 'package:SihatSelaluApp/components/bmi_input.dart';
import 'package:SihatSelaluApp/components/bmi_output.dart';
import 'package:flutter/material.dart';

/// class BMILayout:
///  at the moment, it simply lays out the widgets in portrait mode for iphone15
///  however, this is the class where we can start using LayoutBuilder for more
///  flexible approach based on
///  - orientation
///  - screen size
///  - device type etc
///
/// properties: none
///
/// dependencies:
/// - BMIDisplay() - generic container to show all widgets for app
/// - GenderInputWidget()
/// - AgeInputWidget()
/// - WeightInputWidget()
/// - HeightInputWidget()
/// - OutputWidget() - shows BMI result
class BMIAppLayout extends StatelessWidget {
  const BMIAppLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: const Column(
        children: [
          Row(
            children: [
              Expanded(
                  child:
                      BMIDisplay(title: "Gender", widget: GenderInputWidget())),
              Expanded(
                  child: BMIDisplay(title: "Age", widget: AgeInputWidget())),
            ],
          ),
          Expanded(
              child: BMIDisplay(
                  title: "BMI Result", widget: OutputWidget(), isResult: true)),
          Row(
            children: [
              Expanded(
                  child:
                      BMIDisplay(title: "Weight", widget: WeightInputWidget())),
              Expanded(
                  child:
                      BMIDisplay(title: "Height", widget: HeightInputWidget())),
            ],
          ),
        ],
      ),
    );
  }
}

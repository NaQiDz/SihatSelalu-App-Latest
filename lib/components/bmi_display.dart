import 'package:SihatSelaluApp/theme/context.dart';
import 'package:flutter/material.dart';

/// class BMIDisplay
///  generic container class to display
///  - Widget Title
///  - Input/OutPut Widget ( rather rub widget)
///  - it has two type of display configuration
///    - Input Widgets , with everything in Center
///    - Result Widget, with Title on the top Left Corner
///
/// properties:
/// - title: title of the Widget
/// - widget: takes Widget as param for either accepting Input or display Output
/// - isResult: boolean to choose appropriate layout out with-in Widget
///
/// dependencies:
///  -
class BMIDisplay extends StatelessWidget {
  final String title;
  final Widget widget;
  final bool isResult;
  const BMIDisplay(
      {required this.title,
      required this.widget,
      this.isResult = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: context.widgetBackground,
        borderRadius: BorderRadius.circular(30),
      ),
      child: isResult
          ? _displayResultWidget(context)
          : _displayInputWidget(context),
    );
  }

  Widget _displayInputWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: context.widgetTitle,
              ),
            ),
            widget
          ],
        ),
      ],
    );
  }

  Widget _displayResultWidget(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title, style: context.widgetTitle),
            ),
          ],
        ),
        widget,
      ],
    );
  }
}

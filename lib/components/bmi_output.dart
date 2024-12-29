import 'package:SihatSelaluApp/theme/context.dart';
import 'package:SihatSelaluApp/valueSelection/enums.dart';
import 'package:SihatSelaluApp/valueSelection/values.dart';
import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

/// class OutputWidget
/// this class displays BMI result , using ValueListenBuilder and rebuilds
/// each time bmi value is updated
///
/// properties: none
///
/// private members: none
///
/// public members: none
///
/// initState: init state is used for adding listener
///
/// dependencies:
///  - GaugeIndicator:to display the gauge based on bmi value in range from
///  0.0 to 40.0
///  - instance of BMICalculator

class OutputWidget extends StatefulWidget {
  const OutputWidget({super.key});

  @override
  State<OutputWidget> createState() => _OutputWidgetState();
}

class _OutputWidgetState extends State<OutputWidget> {
  @override
  void initState() {
    super.initState();
    bmiCalculator.bmi.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    BMIStatus bmiStatus = bmiCalculator.currentBMIStatus;

    return ValueListenableBuilder(
        valueListenable: bmiCalculator.bmi,
        builder: (context, value, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(bmiStatus.name.toUpperCase(),
                  style: context.resultName.copyWith(color: bmiStatus.color)),
              SizedBox(
                height: 100,
                child: AnimatedRadialGauge(
                  radius: 80,
                  duration: const Duration(seconds: 1),
                  axis: const GaugeAxis(
                      min: 0,
                      max: 40,
                      degrees: 180,
                      progressBar: GaugeProgressBar.rounded(
                        gradient: GaugeAxisGradient(
                          colors: [Colors.green, Colors.yellow, Colors.red],
                          colorStops: [0.45, 0.6, 1.0],
                        ),
                      ),
                      pointer: GaugePointer.needle(
                        width: 10,
                        height: 60,
                        color: Colors.black,
                      )),
                  value: bmiCalculator.bmi.value,
                ),
              ),
              Text(bmiCalculator.bmi.value.toStringAsFixed(2),
                  style: context.resultNumbers)
            ],
          );
        });
  }
}

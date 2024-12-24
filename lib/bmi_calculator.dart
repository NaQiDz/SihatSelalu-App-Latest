import 'dart:math';

import 'package:SihatSelaluApp/valueSelection/enums.dart';
import 'package:flutter/material.dart';

/// class BMICalculator
/// this is a singleton class, since we would need one single instance to ensure
///  all properties are being updated and, calculations done are in same instance
///  for expected behavior
///
/// properties:
/// - height: height of the person , this has impact on BMI Calculation
/// - weight: weight of the person, this has impact on BMI Calculation
/// - gender: gender of the person, this does not account for BMI calculation
/// - age: age of the person, this does not account for BMI calculation
/// - bmi: calculated BMI using formula weight(kg)/[height(meter) * height(meter)]
/// - currentBMIStatus: status enum used to display informative text related to
///   BMI result
///
/// Note:
/// all properties are derived from ValueNotifier , which provides much cleaner
/// state management and, as you can see in the __internal() , we have added
/// listener to height and , weight , which triggers BMI calculation.
///
/// cascading effect of this can be noticed in OutputWidget class, which makes
/// use of the ValueListenableBuilder and, triggers widget rebuilt each time
/// bmiValue gets updated
///
///
/// private members:
///  _internal(): to add listener to weight and, height which triggers it to
///  re-calculate BMI
///  _calculateBMI(): function to calculate BMI which updates bmi.value and,
///  triggers rebuild of OutputWidget
class BMICalculator {
  /// static instance of the class to be returned by constructor
  static final BMICalculator _bmiCalculator = BMICalculator._internal();

  BMIStatus currentBMIStatus = BMIStatus.normal;
  ValueNotifier<int> height = ValueNotifier<int>(164);
  ValueNotifier<double> weight = ValueNotifier<double>(60.0);
  ValueNotifier<Gender> gender = ValueNotifier<Gender>(Gender.female);
  ValueNotifier<int> age = ValueNotifier<int>(23);
  ValueNotifier<double> bmi = ValueNotifier<double>(0.0);

  /// factory constructor to return static instance of the class
  factory BMICalculator() {
    return _bmiCalculator;
  }

  /// singleton implementation of normal initstate() override
  /// we have added listener to weight and height here to recalculate BMI if
  /// either of value changes
  BMICalculator._internal() {
    weight.addListener(() => _calculateBMI());
    height.addListener(() => _calculateBMI());
  }

  void _calculateBMI() {
    /// calculate BMI only if both height and weight are greater than zero,
    /// else bmi is left to it's default value 0.0
    /// bmi value is accessed by OutputWidget to show results
    if (height.value > 0 && weight.value > 0.0) {
      num heightSquareMeter = pow(height.value.toDouble() / 100, 2);
      bmi.value = weight.value / heightSquareMeter;
    }

    /// set appropriate bmi status which is used by OutputWidget to show
    /// appropriate informative text related to BMI result
    switch (bmi.value) {
      case (< 18):
        currentBMIStatus = BMIStatus.underWeight;
      case (>= 18 && <= 25):
        currentBMIStatus = BMIStatus.normal;
      case (> 25 && < 35):
        currentBMIStatus = BMIStatus.watchIt;
        break;
      case (> 35):
        currentBMIStatus = BMIStatus.overWeight;
        break;
    }
  }
}

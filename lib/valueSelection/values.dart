import 'package:SihatSelaluApp/bmi_calculator.dart';
import 'package:SihatSelaluApp/theme/main.dart';

/// these are all one time values, which are used for setting range in the
/// input widgets
///
/// ageRange: varies from 0 to 100 Years
/// weightRange: varies from 0 to 300 kg
/// heightRange: varies from 0 to 300 cm
///
List<int> ageRange = List.generate(100, (index) => index, growable: false);

List<int> weightRange = List.generate(600, (index) => index);

List<int> heightRange = List.generate(300, (index) => index);

/// global instance of appTheme , which is singleton class
AppTheme appTheme = AppTheme();
BMICalculator bmiCalculator = BMICalculator();

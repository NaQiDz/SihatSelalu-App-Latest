import 'package:flutter/material.dart';

// -------------------- Gender start----------------------------------
///Enum for gender aka Type which lists constants of type Gender
enum Gender { male, female }

/// extension on our Gender enum , so we can call
/// - selectedGender.icon : which returns appropriate icon to represent selected
/// gender
/// - selectedGender.label: which returns appropriate label to represent selected
/// gender
extension GenderIcon on Gender {
  IconData get icon {
    switch (this) {
      case Gender.male:
        return Icons.male;
      case Gender.female:
        return Icons.female;
    }
  }

  String get label {
    switch (this) {
      case Gender.male:
        return "Male";
      case Gender.female:
        return "Female";
    }
  }
}
// -------------------- Gender end ----------------------------------

// -------------------- BMIStatus start -----------------------------
///Enum for BMIStatus aka Type which lists constants of type BMIStatus
enum BMIStatus { underWeight, normal, watchIt, overWeight }

///Extension on BMIStatus wo we can access
/// - resultBMI.name: providing informative text for the BMI result
/// - resultBMI.color: providing color for the informative text to make it
/// stand out from rest of the text
extension BMIStatusExtension on BMIStatus {
  String get name {
    switch (this) {
      case BMIStatus.underWeight:
        return "Under Weight";
      case BMIStatus.normal:
        return "normal";
      case BMIStatus.watchIt:
        return "watch it";
      case BMIStatus.overWeight:
        return "Over Weight";
    }
  }

  Color get color {
    Color darkRed = const Color(0xFFd32f2f);
    switch (this) {
      case BMIStatus.underWeight:
        return darkRed;
      case BMIStatus.normal:
        return Colors.green;
      case BMIStatus.watchIt:
        return Colors.yellow;
      case BMIStatus.overWeight:
        return darkRed;
    }
  }
}

// -------------------- BMIStatus end ------------------------------

// -------------------- InputType start ----------------------------
/// enum to list all possible input types for the app
enum InputType { gender, age, weight, height }
// -------------------- InputType end ------------------------------

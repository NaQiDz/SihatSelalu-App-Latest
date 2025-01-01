import 'package:SihatSelaluApp/theme/context.dart';
import 'package:SihatSelaluApp/valueSelection/enums.dart';
import 'package:SihatSelaluApp/valueSelection/values.dart';
import 'package:flutter/material.dart';
import 'package:wheel_slider/wheel_slider.dart';

/// class InputWidget
/// this class is key to inputs that we have. all Input are composed of an
/// instance of InputWidget.
///
/// this class displays appropriate WheelSlider based on inputType and,
/// informative text under the WheelSlider
///
/// properties:
///   required:
/// - valuesList: used by the WheelSlider to crate appropriate scroll wheel list
/// - initValue: the initial value to be set for wheel slider
/// - inputType: type of input one from the list of enums.dart
///   optional:
///   - isCustom: option to check, if we are using custom Wheel_slider or a numbers
///   wheel slider for given input widget
///   - isHorizontal: orientation of the wheel_slider,by default this is set to false
///   meaning, default slider is vertical
///   - unit: measuring unit associated with input, by default it is none/empty string
///   - interval: interval between each numbers aka, progression of number by
///   default it 1, i.e numbers are increased by 1 by default as in 0,1,2 etc
///
///
/// public members:
/// - updateSelection: this function updates current value using setState for
/// an instance of Widget and, updates the bmi input values used by bmiCalculator
/// depending upon supplied inputType
///
/// private members:
/// - _buildCustom: gives an instance of custom WheelSlider
/// - _buildNumber: gives and instance of number WheelSlider
///
/// dependencies:
/// - WheelSlider package
class InputWidget extends StatefulWidget {
  final dynamic valuesList;
  final int initValue;
  final InputType inputType;
  final bool isCustom;
  final bool isHorizontal;
  final String unit;

  final num interval;

  const InputWidget(
      {required this.valuesList,
      required this.initValue,
      required this.inputType,
      this.isCustom = false,
      this.isHorizontal = false,
      this.interval = 1,
      this.unit = '',
      super.key});

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  num _currentSelection = 0;

  @override
  void initState() {
    super.initState();
    _currentSelection = widget.initValue;
  }

  void updateSelection({required value}) {
    setState(() {
      _currentSelection = value;
    });
    switch (widget.inputType) {
      case InputType.gender:
        bmiCalculator.gender.value = Gender.values[_currentSelection.toInt()];
      case InputType.age:
        bmiCalculator.age.value = _currentSelection.toInt();
      case InputType.height:
        bmiCalculator.height.value = _currentSelection.toInt();
      case InputType.weight:
        bmiCalculator.weight.value = _currentSelection.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.isCustom ? _buildCustom() : _buildNumbers(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.isCustom
                ? Gender.values[_currentSelection.toInt()].label
                : '$_currentSelection ${widget.unit}',
            style: context.widgetInfo,
          ),
        )
      ],
    );
  }

  /// customWidget builder is used for displaying genders , the values passed to
  /// this widget are list of enum values namely [ Gender.male,Gender.female]
  /// currentSelection only has access to integer position i.e. 0 or 1 in this case
  /// so to access actual value we must access valueList and use index of currentSelection
  Widget _buildCustom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.arrow_left,
          size: 38,
        ),
        WheelSlider.customWidget(
          totalCount: widget.valuesList.length,
          initValue: widget.initValue,
          onValueChanged: (value) => {updateSelection(value: value)},
          itemSize: 80,
          horizontalListWidth: 80,
          horizontalListHeight: 100,
          verticalListHeight: 100,
          verticalListWidth: 100,
          horizontal: widget.isHorizontal,
          showPointer: false,
          listHeight: 80,
          listWidth: 80,
          scrollPhysics: const BouncingScrollPhysics(),
          children: List.generate(
            widget.valuesList.length,
            (index) => Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Gender.values[_currentSelection.toInt()].icon,
                  size: 80,
                  color: context.genderIconColor,
                ),
              ],
            ),
          ),
        ),
        const Icon(
          Icons.arrow_right,
          size: 38,
        )
      ],
    );
  }

  Widget _buildNumbers() {
    return WheelSlider.number(
        totalCount: widget.valuesList.length,
        initValue: widget.initValue,
        interval: widget.interval,
        horizontalListWidth: 100,
        horizontalListHeight: 100,
        verticalListHeight: 100,
        verticalListWidth: 100,
        horizontal: widget.isHorizontal,
        itemSize: 40,
        listHeight: 100,
        listWidth: 100,
        selectedNumberStyle: context.selectedWheelText,
        unSelectedNumberStyle: context.unSelectedWheelText,
        onValueChanged: (value) => {updateSelection(value: value)},
        currentIndex: _currentSelection);
  }
}

/// stateless widget to display selectable list of genders
/// it uses customWidget of WheelSlider to display slide-able list of Gender
/// and informative text at the bottom
///
/// dependencies:
/// - InputWidget
class GenderInputWidget extends StatelessWidget {
  const GenderInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const InputWidget(
      inputType: InputType.gender,
      valuesList: Gender.values,
      initValue: 1,
      isCustom: true,
      isHorizontal: true,
    );
  }
}

/// stateless widget to display selectable range of age
/// dependencies:
/// - InputWidget
class AgeInputWidget extends StatelessWidget {
  const AgeInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InputWidget(
      inputType: InputType.age,
      valuesList: ageRange,
      initValue: 23,
      isCustom: false,
      isHorizontal: false,
      unit: 'years',
    );
  }
}

/// stateless widget to display selectable range of Weight in Kg
/// dependencies:
/// - InputWidget
class WeightInputWidget extends StatelessWidget {
  const WeightInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InputWidget(
      inputType: InputType.weight,
      valuesList: weightRange,
      initValue: 60,
      isCustom: false,
      isHorizontal: false,
      interval: 0.5,
      unit: 'Kg',
    );
  }
}

/// stateless widget to display selectable range of height in cm
/// dependencies:
/// - InputWidget
class HeightInputWidget extends StatelessWidget {
  const HeightInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InputWidget(
      inputType: InputType.height,
      valuesList: heightRange,
      initValue: 164,
      isCustom: false,
      isHorizontal: false,
      unit: 'cm',
    );
  }
}

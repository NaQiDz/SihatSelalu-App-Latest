import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:SihatSelaluApp/choosechild.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:SihatSelaluApp/bottombar.dart';
import 'package:SihatSelaluApp/header.dart';
import 'package:SihatSelaluApp/sidebar.dart';

class IOTPage extends StatefulWidget {
  final int childId;
  const IOTPage({super.key, required this.childId});
  @override
  _IOTPageToUse createState() => _IOTPageToUse();
}

class _IOTPageToUse extends State<IOTPage> {
  String _weight = "Loading...";
  String _height = "Loading...";
  double weightAsDouble = 0.00;
  double heightInMeters = 0.00;
  Timer? _timer;
  bool _startBmiCountdown = false;
  bool isLoading = false;
  String? errorMessage;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch data automatically on app start
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      fetchWeight();
      fetchHeight();
    });
  }

  Future<void> fetchWeight() async {
    final url = Uri.parse('http://172.20.10.4/weight');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        double weight = double.tryParse(data['weight'].toString()) ?? 0.0;
        setState(() {
          _weight = "${(weight * 2).toStringAsFixed(3)} ${data['unit']}";
          weightAsDouble = weight;
        });

        if (weight > 10 && !_startBmiCountdown) {
          _startBmiCountdown = true;
          _startCountdownToBmiDialog();
        }
      }
    } catch (e) {
      setState(() {
        _weight = "Loading...";
      });
    }
  }

  Future<void> fetchHeight() async {
    final url = Uri.parse('http://172.20.10.2/height'); // Replace with your ESP8266 IP
    try {
      final response = await http.get(url); // Send GET request using http package
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _height = "${data['height']} cm";
          double heightInCm = double.tryParse(data['height'].toString()) ?? 0.0;
          heightInMeters = heightInCm / 100.0;
        });
      } else {
        setState(() {
          _height = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _height = "Loading...";
      });
    }
  }



  Future<void> fetchUserData() async {
    final String serverIp = dotenv.env['ENVIRONMENT'] == 'dev'
        ? dotenv.env['DB_HOST_EMU']!
        : dotenv.env['DB_HOST_IP']!;
    setState(() {
      isLoading = true;
      errorMessage = null;
      userData = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://$serverIp/SihatSelaluAppDatabase/managechild.php'), // Replace with your URL
        body: {'childid': widget.childId.toString()}, // Send the childId

      );
      print('child id : ${widget.childId}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic> && data['error'] == null) {
          setState(() {
            userData = data; // Assuming your data structure contains a 'data' key
            isLoading = false;
            print('Child info: $userData');
          });
        } else {
          setState(() {
            errorMessage = data['error'] ?? data['message'] ?? 'An error occurred';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Request failed with status: ${response.statusCode}.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  void _startCountdownToBmiDialog() {
    Future.delayed(Duration(seconds: 5), () {
       double bmi = weightAsDouble / (heightInMeters * heightInMeters);
      _showBmiDialog(context, bmi);
      insertBmi(heightInMeters, weightAsDouble,  bmi);
      _timer?.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> insertBmi(double height, double weight, double bmi) async {
    final String serverIp = dotenv.env['ENVIRONMENT'] == 'dev'
        ? dotenv.env['DB_HOST_EMU']!
        : dotenv.env['DB_HOST_IP']!;

    setState(() {
      isLoading = true;
      errorMessage = null;
      userData = null;
    });

    try {
          String uri = "http://$serverIp/SihatSelaluAppDatabase/updatebmi.php";
          var res = await http.post(
          Uri.parse(uri),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
          'childid': widget.childId.toString(),
          'child_height': height.toString(),
          'child_weight': weight.toString(),
          'child_bmi': bmi.toString(),
          'recordDate': DateTime.now().toString(), // Set current time
        }),
      );
      int id = widget.childId;
      String date = DateTime.now().toIso8601String();
      print('ChildId: $id, Height: $height, Weight: $weight, BMI: $bmi, Date: $date');
          if (res.statusCode == 200) { // Correct variable used here
            print('BMI record inserted successfully!');
          } else {
            print('BMI fail to record!');
          }
    } catch (e) {
        errorMessage = 'Error: $e';
    }
  }

  int calculateAge(String birthDateString) {
    // Ensure the birthDateString is not null or empty before proceeding
    if (birthDateString.isEmpty) return 0; // Handle the case when the birth date is not available.

    // Parse the input string into a DateTime object
    DateTime birthDate = DateTime.parse(birthDateString);
    DateTime today = DateTime.now();

    // Calculate the difference in years
    int age = today.year - birthDate.year;

    // Check if the birthday has not occurred yet this year
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Ensure userData is not null before calculating age
    int age = userData != null ? calculateAge(userData!['child_dateofbirth']) : 0; // Default to 0 if userData is null

    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      drawer: const SideBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.blue.shade900],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Header(),
                SizedBox(height: screenHeight * 0.01),
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      "Check Your\nWeight and Height",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Center(
                  child: Container(
                    height: screenHeight * 0.2,
                    width: screenWidth * 0.9,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.transparent,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(screenWidth * 0.00),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: screenHeight * 0.05,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: userData?['child_fullname'] ?? 'Unknown Name',
                                    labelStyle: TextStyle(color: Colors.black),
                                    filled: false,
                                    enabled: false,
                                    fillColor: Colors.black,
                                    prefixIcon: Icon(Icons.person),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.005),
                              SizedBox(
                                height: screenHeight * 0.05,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: userData?['child_gender'] ?? 'Unknown Name',
                                    labelStyle: TextStyle(color: Colors.black),
                                    filled: false,
                                    enabled: false,
                                    fillColor: Colors.transparent,
                                    prefixIcon: Icon(Icons.wc),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.005),
                              SizedBox(
                                height: screenHeight * 0.05,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: '$age Years',
                                    labelStyle: TextStyle(color: Colors.black),
                                    filled: false,
                                    enabled: false,
                                    fillColor: Colors.transparent,
                                    prefixIcon: Icon(Icons.calendar_today),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: screenHeight * 0.26,
                      width: screenWidth * 0.45,
                      child: _buildRadialGaugeWeight(),
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.26,
                            width: screenWidth * 0.45,
                            child: _buildRadialGaugeHeight(),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: screenHeight * 0.10,
                      width: screenWidth * 0.45,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.weight,
                            color: Colors.red,
                            size: screenWidth * 0.08,
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: screenWidth * 0.04),
                              Text(
                                _weight,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Container(
                            height: screenHeight * 0.10,
                            width: screenWidth * 0.45,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.ruler,
                                  color: Colors.blue,
                                  size: screenWidth * 0.08,
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: screenWidth * 0.04),
                                    Text(
                                      _height,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.05,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }

  Widget _buildRadialGaugeWeight() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(15),
      ),
      child: SfRadialGauge(
        title: GaugeTitle(
          text: 'Weight',
          textStyle: TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold),
        ),
        enableLoadingAnimation: true,
        animationDuration: 4500,
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 75,
            pointers: <GaugePointer>[
              NeedlePointer(value: (weightAsDouble * 2), enableAnimation: true),
            ],
            ranges: <GaugeRange>[
              GaugeRange(startValue: 0, endValue: 25, color: Colors.green),
              GaugeRange(startValue: 25, endValue: 50, color: Colors.orange),
              GaugeRange(startValue: 50, endValue: 75, color: Colors.red),
            ],
            annotations: <GaugeAnnotation>[],
          ),
        ],
      ),
    );
  }

  Widget _buildRadialGaugeHeight() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(15),
      ),
      child: SfRadialGauge(
        title: GaugeTitle(
          text: 'Height',
          textStyle: TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold),
        ),
        enableLoadingAnimation: true,
        animationDuration: 4500,
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 200,
            pointers: <GaugePointer>[
              NeedlePointer(value: heightInMeters * 100, enableAnimation: true),
            ],
            ranges: <GaugeRange>[
              GaugeRange(startValue: 0, endValue: 50, color: Colors.yellow),
              GaugeRange(startValue: 50, endValue: 100, color: Colors.orange),
              GaugeRange(startValue: 100, endValue: 200, color: Colors.red),
            ],
            annotations: <GaugeAnnotation>[],
          ),
        ],
      ),
    );
  }

  void _showBmiDialog(BuildContext context, double bmiValue) {
    String weightStatus;

    if (bmiValue < 18.5) {
      weightStatus = 'Underweight';
    } else if (bmiValue >= 18.5 && bmiValue < 24.9) {
      weightStatus = 'Normal weight';
    } else if (bmiValue >= 25 && bmiValue < 29.9) {
      weightStatus = 'Overweight';
    } else {
      weightStatus = 'Obese';
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: EdgeInsets.all(25),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          backgroundColor: Colors.black.withOpacity(0.6),
          title: Center(
            child: Text(
              'BMI Result',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your BMI is:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                bmiValue.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Weight Status:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                weightStatus,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChildrenChoosePage()),
                );
              },
              child: Text(
                'Go to Child Page',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],

        );
      },
    );
  }
}


import 'package:SihatSelaluApp/bottombar.dart';
import 'package:SihatSelaluApp/header.dart';
import 'package:SihatSelaluApp/home.dart';
import 'package:SihatSelaluApp/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class CalorieChildPage extends StatelessWidget {
  const CalorieChildPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChildrenCaloriePage(),
    );
  }
}

class ChildrenCaloriePage extends StatefulWidget {
  const ChildrenCaloriePage({super.key});

  @override
  _ChildrenCaloriePageState createState() => _ChildrenCaloriePageState();
}

class BarData {
  final String month;
  final double calorie; // Changed to double

  BarData(this.month, this.calorie);
}

class _ChildrenCaloriePageState extends State<ChildrenCaloriePage> {
  String? username;
  String? id;
  String? email;
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? errorMessage;
  List<dynamic>? childData;
  List<String> recorderDates = [];
  int daysPassed = 0;
  List<BarData> chartData = [];

  @override
  void initState() {
    super.initState();
    _loadSessionData();
    fetchUser();
    fetchChild();
    fetchRecorderDate();
  }

  void _loadSessionData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      final String? Email = prefs.getString('Email');
      final String? ID = prefs.getString('ID');
      final String? Username = prefs.getString('Username');

      username = Username ?? "Guest";
      email = Email ?? "example@mail.com";
      id = ID;
    });
  }

  Future<void> fetchUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await dotenv.load(fileName:'.env');
    String? serverIp;
    serverIp = dotenv.env['ENVIRONMENT']! == 'dev' ? dotenv.env['DB_HOST_EMU']! : dotenv.env['DB_HOST_IP'];

    setState(() {
      isLoading = true;
      errorMessage = null;
      userData = null;
    });
    final String? Username = prefs.getString('Username');
    username = Username ?? "Guest";

    try {
      final response = await http.post(
        Uri.parse('http://$serverIp/SihatSelaluAppDatabase/manageuser.php'), // Replace with your URL
        body: {'username': username}, // Send the hardcoded username
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic> && data['error'] == null) {
          setState(() {
            userData = data;
            isLoading = false;
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

  Future<void> fetchChild() async {
    String userid;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? ID = prefs.getString('ID');
    userid = ID.toString();
    await dotenv.load(fileName: '.env');
    String? serverIp;
    serverIp = dotenv.env['ENVIRONMENT']! == 'dev' ? dotenv.env['DB_HOST_EMU']! : dotenv.env['DB_HOST_IP'];

    if (userid == null) {
      setState(() {
        errorMessage = 'User ID is not available.';
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null; // Clear previous error
      childData = null; // Clear previous users data
    });

    try {
      final response = await http.post(
        Uri.parse('http://$serverIp/SihatSelaluAppDatabase/tryCalorie.php'), // Replace with your URL
        body: {'userid': userid},
      );

      print('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            childData = data['datachild'];
            isLoading = false;
          });
          print('Child Data : $childData');
        } else {
          setState(() {
            errorMessage = data['message'] ?? 'An error occurred';
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

  Future<void> fetchRecorderDate() async {
    String userid;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? ID = prefs.getString('ID');
    userid = ID.toString();
    await dotenv.load(fileName: '.env');
    String? serverIp;
    serverIp = dotenv.env['ENVIRONMENT']! == 'dev' ? dotenv.env['DB_HOST_EMU']! : dotenv.env['DB_HOST_IP'];
    try {
      final response = await http.post(
        Uri.parse('http://$serverIp/SihatSelaluAppDatabase/recorddate.php'), // Replace with your URL
        body: {'userid': userid},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          setState(() {
            String recorderDateStr = data['recorder_date']; // Get the recorder_date as string
            calculateDaysPassed(recorderDateStr);
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = data['message'];
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load data. Status code: ${response.statusCode}';
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

  void calculateDaysPassed(String recorderDateStr) {
    if (recorderDateStr.isEmpty) {
      setState(() {
        errorMessage = 'Recorder date is empty';
      });
      return;
    }

    try {
      // Parse the recorderDate string into a DateTime object
      DateTime recorderDate = DateFormat('yyyy-MM-dd').parse(recorderDateStr);

      // Get the current date
      DateTime currentDate = DateTime.now();

      // Calculate the difference in days
      setState(() {
        daysPassed = currentDate.difference(recorderDate).inDays;
        print('Day Pass : $daysPassed');
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error parsing date: $e';
      });
    }
  }

  Future<void> fetchChildCalorie() async {
    String userid;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? ID = prefs.getString('ID');
    userid = ID?.toString() ?? '';

    // Log the retrieved User ID
    print('Retrieved User ID: $userid');

    await dotenv.load(fileName: '.env');
    String? serverIp = dotenv.env['ENVIRONMENT'] == 'dev'
        ? dotenv.env['DB_HOST_EMU']
        : dotenv.env['DB_HOST_IP'];

    if (userid.isEmpty) {
      setState(() {
        errorMessage = 'User ID is not available or empty.';
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null; // Clear previous error
      childData = null; // Clear previous user data
    });

    try {
      final response = await http.post(
        Uri.parse('http://$serverIp/SihatSelaluAppDatabase/ai_power/get_calories.php'),
        body: {'userid': userid},
      );

      // Log the status code for debugging
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            childData = data['datachild'];
            isLoading = false;
          });
          print('Child Data: $childData');

        } else {
          // Handle the specific error message from the response
          setState(() {
            errorMessage = data['message'] ?? 'An error occurred on the server.';
            isLoading = false;
          });
          print('Error Message from Server: ${data['message']}');
        }
      } else {
        // Handle HTTP errors
        setState(() {
          errorMessage = 'Request failed with status: ${response.statusCode}.';
          isLoading = false;
        });
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      // Log any exceptions
      print('Exception caught: $e');
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> fetchCalorieData(String childId) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      chartData = []; // Clear previous chart data
    });

    await dotenv.load(fileName: '.env');
    String? serverIp = dotenv.env['ENVIRONMENT'] == 'dev'
        ? dotenv.env['DB_HOST_EMU']
        : dotenv.env['DB_HOST_IP'];

    try {
      final response = await http.post(
        Uri.parse('http://$serverIp/SihatSelaluAppDatabase/ai_power/get_child_calories.php'),
        body: {'child_id': childId},
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Try to decode the response body
        Map<String, dynamic> data;
        try {
          data = jsonDecode(response.body);
        } catch (e) {
          setState(() {
            errorMessage = "Error decoding response: $e";
            isLoading = false;
          });
          print('Error decoding JSON: $e');
          return;
        }

        if (data['status'] == 'success') {
          List<dynamic> calorieRecords = data['data'];
          List<BarData> tempChartData = [];

          for (var record in calorieRecords) {
            // Check if the date format is correct before parsing
            try {
              String formattedDate = DateFormat('MMM')
                  .format(DateTime.parse(record['recorder_calorie_at']));
              tempChartData.add(BarData(
                formattedDate,
                double.parse(record['suggestion_calorie'].toString()),
              ));
            } catch (e) {
              print('Error parsing date or calorie value: $e');
              // Handle the error, e.g., skip this record or show an error message
            }
          }

          setState(() {
            chartData = tempChartData;
            isLoading = false;
          });

          print('Chart Data: $chartData');
        } else {
          setState(() {
            errorMessage = data['message'] ?? 'An error occurred on the server.';
            isLoading = false;
          });
          print('Error Message from Server: ${data['message']}');
        }
      } else {
        setState(() {
          errorMessage = 'Request failed with status: ${response.statusCode}.';
          isLoading = false;
        });
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception caught: $e');
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: const SideBar(),
      body: Stack(
        children: [
          Container(
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
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Header(),
                    SizedBox(height: screenHeight * 0.02),
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Builder(
                        builder: (context) => IconButton(
                          icon: Icon(
                            FontAwesomeIcons.arrowLeft,
                            color: Colors.white,
                            size: 14,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HomePage()),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.00),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Tracking Calorie',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenHeight * 0.03,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Recently Refresh : $daysPassed Days Later',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenHeight * 0.015,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.00),
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Builder(
                              builder: (context) => IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.refresh,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () async {
                                  BuildContext? dialogContext;
                                  bool isDialogOpen = false;

                                  try {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        dialogContext = context;
                                        isDialogOpen = true;
                                        return Stack(
                                          children: [
                                            Opacity(
                                              opacity: 0.3,
                                              child: ModalBarrier(dismissible: false, color: Colors.black),
                                            ),
                                            Center(
                                              child: CircularProgressIndicator(
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    await Future.delayed(Duration(seconds: 3));

                                    if (isDialogOpen && dialogContext != null) {
                                      Navigator.of(dialogContext!).pop();
                                      isDialogOpen = false;
                                    }

                                    await fetchChildCalorie();
                                    await fetchChild();

                                  } catch (e) {
                                    print("Error occurred: $e");

                                    if (isDialogOpen && dialogContext != null) {
                                      Navigator.of(dialogContext!).pop();
                                      isDialogOpen = false;
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.00),
                    Divider(color: Colors.grey),
                    SizedBox(height: screenHeight * 0.01),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        height: 200,
                        child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          primaryYAxis: NumericAxis(
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          series: <CartesianSeries>[
                            ColumnSeries<BarData, String>(
                              dataSource: chartData,
                              xValueMapper: (BarData barData, _) => barData.month,
                              yValueMapper: (BarData barData, _) => barData.calorie,
                              color: Colors.blue,
                              dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                                textStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Divider(color: Colors.grey),
                    SizedBox(height: screenHeight * 0.01),
                    Center(
                      child: Text(
                        'Please click at child',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: screenHeight * 0.015,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        isLoading
                            ? const CircularProgressIndicator()
                            : errorMessage != null
                            ? Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        )
                            : childData != null
                            ? SizedBox(
                          height: 300,
                          child: ListView.builder(
                            itemCount: childData!.length,
                            itemBuilder: (context, index) {
                              var child = childData![index];
                              int age = calculateAge(child['child_dateofbirth']);

                              return GestureDetector(
                                onTap: () {
                                  fetchCalorieData(child['child_id'].toString());
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 4),
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(width: 5),
                                          Text(
                                            child['child_fullname'] ?? 'No Name',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Age:',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Gender:',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                            : const SizedBox(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: const BottomBar(),
          ),
        ],
      ),
    );
  }
}

int calculateAge(String birthDateString) {
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
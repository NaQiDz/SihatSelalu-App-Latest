import 'package:SihatSelaluApp/bottombar.dart';
import 'package:SihatSelaluApp/header.dart';
import 'package:SihatSelaluApp/iotsection.dart';
import 'package:SihatSelaluApp/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:SihatSelaluApp/session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';



class childchoosePage extends StatelessWidget {
  const childchoosePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChildrenChoosePage(),
    );
  }
}

class ChildrenChoosePage extends StatefulWidget {
  const ChildrenChoosePage({super.key});

  @override
  _ChooseChildrenPageState createState() => _ChooseChildrenPageState();
}

class _ChooseChildrenPageState extends State<ChildrenChoosePage> {
  _ChooseChildrenPageState();
  bool isLoading = true;
  String? errorMessage;
  List<dynamic>? childData;
  List<dynamic>? bmidata;

  @override
  void initState() {
    super.initState();
    fetchChild();// Fetch data automatically on app start
    fetchBmiusage();
  }

  Future<void> fetchChild() async {
    String userid;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? ID = prefs.getString('ID');
    userid = ID.toString();
    await dotenv.load(fileName:'.env');
    String? serverIp;
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
      serverIp = dotenv.env['ENVIRONMENT']! == 'dev' ? dotenv.env['DB_HOST_EMU']! : dotenv.env['DB_HOST_IP'];
      final response = await http.post(
        Uri.parse('http://$serverIp/SihatSelaluAppDatabase/try.php'), // Replace with your URL
        body: {'userid': userid},
      );

      if (response.statusCode == 200) {
        final dataChild = jsonDecode(response.body);
        if (dataChild['status'] == 'success') {
          setState(() {
            childData = dataChild['datachild'];
            isLoading = false;
          });
          print('Child Data : $childData');
        }
        else {
          setState(() {
            errorMessage = dataChild['message'] ?? 'An error occurred';
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

  Future<void> fetchBmiusage() async {
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
      errorMessage = null;
      bmidata = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://$serverIp/SihatSelaluAppDatabase/checkbmisusage.php'),
        body: {'userid': userid},
      );
      print('Response: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            bmidata = data['BmiData'];
            isLoading = false;
          });
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


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const SideBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.lightBlue.shade900],
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      const Header(),
                      const SizedBox(height: 20),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Choose Your Child',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.grey.shade300,
                              child: Icon(
                                Icons.scale,
                                size: 50,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 0),
                      _buildChildList(), // Extracted list logic
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildRecentlyUsedSection(context),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }

  /// Handles child list rendering
  Widget _buildChildList() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (childData == null) {
      return const SizedBox(); // Empty state
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.345, // Keep box height constant
      child: ListWheelScrollView.useDelegate(
        itemExtent: MediaQuery.of(context).size.height * 0.08, // Item height consistent
        diameterRatio: 1.6, // Slightly higher curvature for smoother transition
        useMagnifier: true, // Magnification effect when focused
        magnification: 1.0, // Zoom effect when item is focused
        physics: const FixedExtentScrollPhysics(), // Ensures smooth transition with one item focus
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            var child = childData![index];
            int age = calculateAge(child['child_dateofbirth']); // Calculate age

            return GestureDetector(
              onTap: () async{
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IOTPage(
                      childId: child['child_id'],
                    ),
                  ),
                );
                final urlw = Uri.parse('http://172.20.10.4/reset'); // Replace with your ESP8266's IP
                try {
                  final response = await http.get(urlw);
                  if (response.statusCode == 200) {
                    print("Reset command sent successfully.");
                  } else {
                    print("Failed to send reset command.");
                  }
                } catch (e) {
                  print("Error sending reset command: $e");
                }
                final urlh = Uri.parse('http://172.20.10.2/reset'); // Replace with your ESP8266's IP
                try {
                  final response = await http.get(urlh);
                  if (response.statusCode == 200) {
                    print("Reset command sent successfully.");
                  } else {
                    print("Failed to send reset command.");
                  }
                } catch (e) {
                  print("Error sending reset command: $e");
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.003,
                  horizontal: MediaQuery.of(context).size.width * 0.03,
                ).copyWith(bottom: MediaQuery.of(context).size.height * 0.001), // Bottom margin
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.00001,
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                  border: Border.all(
                    color: Colors.transparent, // Transparent border to follow radius
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Shadow effect for smoothness
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 2), // Subtle shadow
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Text(
                    '${index + 1}.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                    ),
                  ),
                  title: Text(
                    child['child_fullname'] ?? 'No Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                    ),
                  ),
                  trailing: Text(
                    'Age: $age',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                    ),
                  ),
                ),
              ),
            );
          },
          childCount: childData!.length,
        ),
      ),
    );
  }

  Widget _buildRecentlyUsedSection(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipPath(
        clipper: ProsteBezierCurve(
          position: ClipPosition.top,
          list: [
            BezierCurveSection(
              start: const Offset(0, 72),
              top: const Offset(90, 20),
              end: const Offset(0, 70),
            ),
          ],
        ),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 45, bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E2E7D),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Text(
                  'Recently used',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.22, // Constrain height
                child: ListView.builder(
                  itemCount: bmidata?.length ?? 0,
                  itemBuilder: (context, index) {
                    var bmi = bmidata![index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            bmi['child_username']?.toString() ?? 'No Name',
                            style: const TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          Text(
                            ((bmi['child_height']*100) != null ? (bmi['child_height']*100).toString() : 'N/A') + ' cm',
                            style: const TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          Text(
                            (bmi['child_weight'] != null
                                ? double.parse(bmi['child_weight'].toString()).toStringAsFixed(2)
                                : 'N/A') + ' kg',
                            style: const TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ],
                      ),
                    );

                  },
                ),
              )

            ],
          ),
        ),
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


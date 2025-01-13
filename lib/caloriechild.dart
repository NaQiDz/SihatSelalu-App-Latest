import 'package:SihatSelaluApp/bottombar.dart';
import 'package:SihatSelaluApp/editchild.dart';
import 'package:SihatSelaluApp/header.dart';
import 'package:SihatSelaluApp/infochild.dart';
import 'package:SihatSelaluApp/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'accountpage.dart';
import 'dart:convert';
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
  _ChildrenCaloriePageState createState() =>_ChildrenCaloriePageState();
}

class _ChildrenCaloriePageState extends State<ChildrenCaloriePage> {
  String? username;
  String? id;
  String? email;
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? errorMessage;
  List<dynamic>? childData;

  @override
  void initState() {
    super.initState();
    _loadSessionData();
    fetchUser();
    fetchChild();// Fetch data automatically on app start
  }

  void _loadSessionData() async{
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
    await dotenv.load(fileName:'.env');
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
        Uri.parse('http://$serverIp/SihatSelaluAppDatabase/ai_power/get_calories.php'), // Replace with your URL
        body: {'userid': userid},
      );

      print('Error: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            childData = data['datachild'];
            isLoading = false;
          });
          print('Child Data : $childData');
        }
        else {
          setState(() {
            errorMessage = data['message'] ?? 'An error occurred';
            isLoading = false;
          });
        }
      } else {
        print('Error: ${response.statusCode}');
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

    final String serverIp = dotenv.env['ENVIRONMENT'] == 'dev'
        ? dotenv.env['DB_HOST_EMU']!
        : dotenv.env['DB_HOST_IP']!;

    return Scaffold(
      drawer: const SideBar(),
      body: Stack(
        children: [
          // Main content wrapped in SingleChildScrollView
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
                              MaterialPageRoute(builder: (context) => AccountPage()),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.00),
                    Center(
                      child: Text(
                        'Tracking Calorie',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),
                    Divider(color: Colors.grey),
                    SizedBox(height: screenHeight * 0.05),
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        // Check loading state or errors
                        isLoading
                            ? const CircularProgressIndicator()
                            : errorMessage != null
                            ? Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        )
                            : childData != null
                            ? SizedBox(
                          height: 500, // Fixed height or dynamic height
                            child:ListView.builder(
                              itemCount: childData!.length,
                              itemBuilder: (context, index) {
                                var child = childData![index];
                                int age = calculateAge(child['child_dateofbirth']);

                                return GestureDetector(
                                  onTap: () {
                                    // Navigate to InfoChild page when tapped
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => InfoChildPage(
                                          childId: child['child_id'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 4), // Adjust vertical margin
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Adjust padding
                                    height: 65.0, // Set fixed height or adjust dynamically
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
                                              'Age: $age',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Calorie:',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )

                        )
                            : const SizedBox(), // Empty when no user data or error
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Positioned BottomBar outside the Scaffold
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: const BottomBar(), // BottomBar positioned at the bottom
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


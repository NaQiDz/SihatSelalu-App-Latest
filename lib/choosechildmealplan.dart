import 'dart:convert';
import 'package:SihatSelaluApp/childmealplan.dart';
import 'package:SihatSelaluApp/home.dart';
import 'package:SihatSelaluApp/bottombar.dart';
import 'package:SihatSelaluApp/header.dart';
import 'package:SihatSelaluApp/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ChooseMealPage extends StatelessWidget {
  const ChooseMealPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChooseMealPageToUse(),
    );
  }
}

class ChooseMealPageToUse extends StatefulWidget {
  const ChooseMealPageToUse({super.key});

  @override
  _ChooseMealPageToUse createState() => _ChooseMealPageToUse();
}

class _ChooseMealPageToUse extends State<ChooseMealPageToUse> {
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
    fetchUser();
    fetchChild();
  }

  Future<void> fetchUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await dotenv.load(fileName: '.env');
    String? serverIp;
    serverIp = dotenv.env['ENVIRONMENT']! == 'dev'
        ? dotenv.env['DB_HOST_EMU']!
        : dotenv.env['DB_HOST_IP'];

    setState(() {
      isLoading = true;
      errorMessage = null;
      userData = null;
    });
    final String? Username = prefs.getString('Username');
    username = Username ?? "Guest";

    try {
      final response = await http.post(
        Uri.parse('http://$serverIp/SihatSelaluAppDatabase/manageuser.php'),
        body: {'username': username},
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
            errorMessage =
                data['error'] ?? data['message'] ?? 'An error occurred';
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
    serverIp = dotenv.env['ENVIRONMENT']! == 'dev'
        ? dotenv.env['DB_HOST_EMU']!
        : dotenv.env['DB_HOST_IP'];

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
      childData = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://$serverIp/SihatSelaluAppDatabase/tryCalorie.php'),
        body: {'userid': userid},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            childData = data['datachild'].map((child) => {
              ...child,
              'child_age': child['child_age'].toString(),
            }).toList();
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

  int calculateAge(String? birthDate) {
    if (birthDate != null && birthDate.isNotEmpty) {
      try {
        DateTime parsedDate = DateTime.parse(birthDate);
        DateTime today = DateTime.now();
        int age = today.year - parsedDate.year;
        if (today.month < parsedDate.month ||
            (today.month == parsedDate.month && today.day < parsedDate.day)) {
          age--;
        }
        return age;
      } catch (e) {
        print("Error parsing date: $e");
        return 0;
      }
    }
    return 0;
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
                colors: [Colors.white, Colors.lightBlue.shade900],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(screenWidth * 0.04),
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
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.00),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Choose Your Child\n     To Plan Meal',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(height: 20),
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage('sources/logo2.png'),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Divider(color: Colors.grey),
                          SizedBox(height: screenHeight * 0.01),
                          Center(
                            child: Text(
                              'Please click at a child',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: screenHeight * 0.015,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Column(
                            children: [
                              const SizedBox(height: 8),
                              // Check loading state or errors
                              isLoading
                                  ? const CircularProgressIndicator()
                                  : errorMessage != null
                                  ? Text(
                                errorMessage!,
                                style:
                                const TextStyle(color: Colors.red),
                              )
                                  : childData != null
                                  ? SizedBox(
                                height:
                                300, // Fixed height or dynamic height
                                child: ListView.builder(
                                  itemCount: childData!.length,
                                  itemBuilder:
                                      (context, index) {
                                    var child = childData![index];
                                    int age = calculateAge(
                                        child['child_dateofbirth']);
                                    return GestureDetector(
                                      onTap: () {
                                        // Navigate to InfoChild page when tapped
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MealPlan(
                                              childId: child['child_id'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 3),
                                        height: 60.0,
                                        padding:
                                        EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 1),
                                        decoration: BoxDecoration(
                                          color: Colors.grey
                                              .withOpacity(0.2),
                                          borderRadius:
                                          BorderRadius.circular(
                                              24),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.white.withOpacity(0.2),
                                              child: Text(
                                                (index+1).toString(), // Convert index to a string
                                                style: TextStyle(
                                                  color: Colors.black, // Set the text color
                                                  fontSize: 14.0, // Set the text size
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(width: 5),
                                                Text(
                                                  child['child_fullname'] ??
                                                      'No Name',
                                                  style: TextStyle(
                                                      color: Colors
                                                          .white),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize:
                                              MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Age: $age',
                                                  style: TextStyle(
                                                      color: Colors
                                                          .white),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                                  : const SizedBox(), // Empty when no user data or error
                              SizedBox(
                                  height:
                                  80), // Add this SizedBox for spacing at the bottom
                            ],
                          ),
                        ],
                      ),
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
            child: const BottomBar(),
          ),
        ],
      ),
    );
  }
}
import 'package:SihatSelaluApp/bottombar.dart';
import 'package:SihatSelaluApp/childpage.dart';
import 'package:SihatSelaluApp/header.dart';
import 'package:SihatSelaluApp/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InfoChildPage extends StatefulWidget {
  final int childId; // Accept childId as a parameter

  const InfoChildPage({super.key, required this.childId});

  @override
  _InfoChildPageState createState() => _InfoChildPageState();
}

class _InfoChildPageState extends State<InfoChildPage> {
  bool isLoading = false;
  String? errorMessage;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch data automatically on app start
  }

  Future<void> fetchUserData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      userData = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://172.20.10.3/SihatSelaluAppDatabase/managechild.php'), // Replace with your URL
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    int age = userData?['child_dateofbirth'] != null
        ? calculateAge(userData!['child_dateofbirth'])
        : 0; // Default age is 0 if date of birth is null or missing


    return Scaffold(
      backgroundColor: Colors.blue.shade900, // Make Scaffold background transparent
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
                          MaterialPageRoute(builder: (context) => ChildPage()),
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
                        'Your Child',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        indent: screenWidth * 0.25,
                        endIndent: screenWidth * 0.25,
                        thickness: 1,
                      ),
                      if (isLoading)
                        CircularProgressIndicator()
                      else if (errorMessage != null)
                        Text(
                          errorMessage!,
                          style: TextStyle(color: Colors.red),
                        )
                      else if (userData != null)
                          Column(
                            children: [
                              Text(
                                userData?['child_fullname'] ?? 'Unknown Name',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenHeight * 0.025,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.05),
                              Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Current Info',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    _buildTextField('Age: $age Years'),
                                    _buildTextField('Gender: ${userData?['child_gender'] ?? 'Unknown'}'),
                                    _buildTextField('Birthday Date: ${userData?['child_dateofbirth'] ?? 'Unknown'}'),
                                    _buildTextField('Width: ${userData?['child_current_weight'] ?? 'Unknown'}'),
                                    _buildTextField('Height: ${userData?['child_current_height'] ?? 'Unknown'}'),
                                  ],
                                ),
                              ),
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
      bottomNavigationBar: const BottomBar(),
    );
  }

  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 15.0),
      child: TextField(
        enabled: false, // Makes the TextField non-editable
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
          filled: false,
          fillColor: Colors.black.withOpacity(0.2),
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

int calculateAge(String? birthDateString) {
  if (birthDateString == null || birthDateString.isEmpty) {
    return 0; // Return 0 or any default value for invalid input
  }

  try {
    DateTime birthDate = DateTime.parse(birthDateString);
    DateTime today = DateTime.now();

    int age = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  } catch (e) {
    // Handle invalid date format
    return 0;
  }
}


import 'package:SihatSelaluApp/about_system.dart';
import 'package:SihatSelaluApp/bottombar.dart';
import 'package:SihatSelaluApp/caloriechild.dart';
import 'package:SihatSelaluApp/child_history.dart';
import 'package:SihatSelaluApp/childpage.dart';
import 'package:SihatSelaluApp/choosechildrecord.dart';
import 'package:SihatSelaluApp/header.dart';
import 'package:SihatSelaluApp/home.dart';
import 'package:SihatSelaluApp/parent_history.dart';
import 'package:SihatSelaluApp/profilepage.dart';
import 'package:SihatSelaluApp/session_manager.dart';
import 'package:SihatSelaluApp/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Accountpage extends StatelessWidget {
  const Accountpage({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AccountPage(),
    );
  }
}

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String? username;
  String? id;
  String? email;
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState(){
    super.initState();
    _loadSessionData();
    fetchUser(); // Fetch data automatically on app start
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
    await dotenv.load(fileName:'.env');
    String? serverIp;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? Email = prefs.getString('Email');
    final String? ID = prefs.getString('ID');
    final String? Username = prefs.getString('Username');

    username = Username ?? "Guest";
    email = Email ?? "example@mail.com";
    id = ID;
    setState(() {
      isLoading = true;
      errorMessage = null;
      userData = null;
    });
    try {
      serverIp = dotenv.env['ENVIRONMENT']! == 'dev' ? dotenv.env['DB_HOST_EMU']! : dotenv.env['DB_HOST_IP'];
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
                colors: [Colors.white, Colors.lightBlue.shade900],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(screenWidth * 0.06),
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
                            color: Colors.black,
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
                        children: [
                          Text(
                            'Account',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenHeight * 0.03,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          if (userData?['Icon'] == null || userData?['Icon'] == 'null') // Check for both null and the string 'null'
                            CircleAvatar(
                              radius: screenHeight * 0.04,
                              backgroundImage: NetworkImage(
                                'http://$serverIp/SihatSelaluAppDatabase/images/defaultprofile.png',
                              ),
                            ),
                          if (userData?['Icon'] != null && userData?['Icon'] != 'null') // Check for both null and the string 'null'
                            CircleAvatar(
                              radius: screenHeight * 0.04,
                              backgroundImage: NetworkImage(
                                'http://$serverIp/SihatSelaluAppDatabase/${userData?['Icon'] ?? ''}', // Use ?? '' to handle null
                              ),
                            ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            (username?.toUpperCase() ?? 'Unknown User'),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          _buildAccount(context),
                          _buildAccountChild(context),
                          _buildRecord(context),
                          _buildHistory(context),
                          _buildAbout(context),
                          SizedBox(height: screenHeight * 0.1), // Add margin space at the bottom
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
            child: const BottomBar(), // BottomBar positioned at the bottom
          ),
        ],
      ),
    );
  }



  Widget _buildAccount(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to ProfilePage when the entire box is tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()), // Replace with your actual ProfilePage
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(FontAwesomeIcons.userCircle, color: Colors.black),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your Account', style: TextStyle(color: Colors.black)),
                    Text(email!, style: TextStyle(color: Colors.black, fontSize: 12)),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildAccountChild(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to ProfilePage when the entire box is tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChildPage()), // Replace with your actual ProfilePage
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(FontAwesomeIcons.child, color: Colors.black),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your Child', style: TextStyle(color: Colors.black)),
                    Text('Information about your children', style: TextStyle(color: Colors.black, fontSize: 12)),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecord(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to ProfilePage when the entire box is tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChooseRecordPage()), // Replace with your actual ProfilePage
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(FontAwesomeIcons.heartbeat, color: Colors.black),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Record Health', style: TextStyle(color: Colors.black)),
                    Text('Record of your children', style: TextStyle(color: Colors.black, fontSize: 12)),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistory(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to ProfilePage when the entire box is tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChildrenCaloriePage()), // Replace with your actual ProfilePage
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(FontAwesomeIcons.history, color: Colors.black),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('History Usage', style: TextStyle(color: Colors.black)),
                    Text('Your child history of weight and height', style: TextStyle(color: Colors.black, fontSize: 12)),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAbout(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to ProfilePage when the entire box is tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutUs()), // Replace with your actual ProfilePage
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(FontAwesomeIcons.infoCircle, color: Colors.black),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('About System', style: TextStyle(color: Colors.black)),
                    Text('All about our system and team members', style: TextStyle(color: Colors.black, fontSize: 12)),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
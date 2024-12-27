import 'package:SihatSelaluApp/bottombar.dart';
import 'package:SihatSelaluApp/childpage.dart';
import 'package:SihatSelaluApp/header.dart';
import 'package:SihatSelaluApp/home.dart';
import 'package:SihatSelaluApp/profilepage.dart';
import 'package:SihatSelaluApp/session_manager.dart';
import 'package:SihatSelaluApp/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  String? username = SessionManager.username;
  String? email = SessionManager.email;
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchUser(); // Fetch data automatically on app start
  }

  Future<void> fetchUser() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      userData = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://172.20.10.3/SihatSelaluAppDatabase/manageuser.php'), // Replace with your URL
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
                          MaterialPageRoute(builder: (context) => HomePage(
                          )),
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
                          color: Colors.white,
                          fontSize: screenHeight * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      if (userData?['Icon'] == null)
                        CircleAvatar(
                          radius: screenHeight * 0.06,
                          backgroundImage: NetworkImage('http://172.20.10.3/SihatSelaluAppDatabase/images/defaultprofile.png'), // Use user image or default
                        ),
                      if (userData?['Icon'] != null)
                        CircleAvatar(
                          radius: screenHeight * 0.06,
                          backgroundImage: NetworkImage('http://172.20.10.3/SihatSelaluAppDatabase/' + userData?['Icon']), // Use user image or default
                        ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        username!.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      _buildAccount(context),
                      _buildAccountChild(context),
                      _buildRecord(context),
                      _buildHistory(context),
                      _buildAbout(context),
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

  Widget _buildAccount(BuildContext context) {
    String? username = SessionManager.username;
    String? email = SessionManager.email;
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
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(FontAwesomeIcons.userCircle, color: Colors.white),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your Account', style: TextStyle(color: Colors.white)),
                    Text(email!, style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.white,
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
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(FontAwesomeIcons.child, color: Colors.white),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your Child', style: TextStyle(color: Colors.white)),
                    Text('Information about your children', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.white,
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
          MaterialPageRoute(builder: (context) => ProfilePage()), // Replace with your actual ProfilePage
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(FontAwesomeIcons.heartbeat, color: Colors.white),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Record Health', style: TextStyle(color: Colors.white)),
                    Text('Record of your children', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.white,
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
          MaterialPageRoute(builder: (context) => ProfilePage()), // Replace with your actual ProfilePage
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(FontAwesomeIcons.history, color: Colors.white),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('History Usage', style: TextStyle(color: Colors.white)),
                    Text('Your child history of weight and height', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.white,
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
          MaterialPageRoute(builder: (context) => ProfilePage()), // Replace with your actual ProfilePage
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(FontAwesomeIcons.infoCircle, color: Colors.white),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('About System', style: TextStyle(color: Colors.white)),
                    Text('All about our system and team members', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
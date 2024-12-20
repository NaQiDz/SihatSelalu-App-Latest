import 'package:SihatSelaluApp/bottombar.dart';
import 'package:SihatSelaluApp/childpage.dart';
import 'package:SihatSelaluApp/header.dart';
import 'package:SihatSelaluApp/home.dart';
import 'package:SihatSelaluApp/profilepage.dart';
import 'package:SihatSelaluApp/sidebar.dart';
import 'package:SihatSelaluApp/started.dart';
import 'package:SihatSelaluApp/about_system.dart'; // Import the About System page
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: accountpage(),
    );
  }
}

class accountpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
                      CircleAvatar(
                        radius: screenHeight * 0.05,
                        backgroundColor: Colors.grey,
                        child: Text('Image', style: TextStyle(color: Colors.black)),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        'YOUR NAME',
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
                      _buildAbout(context), // About System button
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
    return _buildButton(
      context,
      icon: FontAwesomeIcons.user,
      title: 'Account Details',
      subtitle: 'View your account information',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      },
    );
  }

  Widget _buildAccountChild(BuildContext context) {
    return _buildButton(
      context,
      icon: FontAwesomeIcons.child,
      title: 'Child Accounts',
      subtitle: 'Manage child profiles',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChildPage()),
        );
      },
    );
  }

  Widget _buildRecord(BuildContext context) {
    return _buildButton(
      context,
      icon: FontAwesomeIcons.book,
      title: 'Records',
      subtitle: 'View your activity records',
      onTap: () {
        // Navigation logic for Records
      },
    );
  }

  Widget _buildHistory(BuildContext context) {
    return _buildButton(
      context,
      icon: FontAwesomeIcons.history,
      title: 'History',
      subtitle: 'Check your history',
      onTap: () {
        // Navigation logic for History
      },
    );
  }

  Widget _buildAbout(BuildContext context) {
    return _buildButton(
      context,
      icon: FontAwesomeIcons.infoCircle,
      title: 'About System',
      subtitle: 'Learn about our system',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SihatSelaluApp()),
        );
      },
    );
  }

  Widget _buildButton(BuildContext context,
      {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
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
                Icon(icon, color: Colors.white),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: Colors.white)),
                    Text(subtitle, style: TextStyle(color: Colors.white, fontSize: 12)),
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

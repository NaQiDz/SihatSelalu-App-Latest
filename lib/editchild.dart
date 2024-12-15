import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'qrpage.dart';
import 'accountpage.dart';
import 'started.dart';

class EditChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EditChildInformationScreen(),
    );
  }
}

class EditChildInformationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: _buildSidebar(screenHeight),
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
                _buildHeader(context, screenWidth),
                SizedBox(height: screenHeight * 0.06),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Edit Your Child',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight * 0.025,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Information',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight * 0.025,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 1,
                        indent: screenWidth * 0.25,
                        endIndent: screenWidth * 0.25,
                      ),
                      SizedBox(height: 40),
                      _buildTextField('Akmal Hakim', 'Full Name'),
                      SizedBox(height: 16),
                      _buildTextField('22 years old','Age'),
                      SizedBox(height: 16),
                      _buildTextField('Male','Gender'),
                      SizedBox(height: 16),
                      _buildTextField('09 September 2002','Birthday Date'),
                      SizedBox(height: 16),
                      _buildTextField('45 kg','Width'),
                      SizedBox(height: 16),
                      _buildTextField('125 cm','Height'),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          // Handle save action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                            horizontal: screenWidth * 0.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontSize: screenHeight * 0.015,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildHeader(BuildContext context, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Builder(
                builder: (context) => IconButton(
                  icon: Icon(
                    FontAwesomeIcons.bars,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.19),
            Text(
              'SihatSelalu App',
              style: TextStyle(
                color: Colors.blue[900],
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Icon(
          FontAwesomeIcons.bell,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget _buildSidebar(double screenHeight) {
    return Drawer(
      child: Builder(
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(screenHeight * 0.01),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Section
                Container(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.05),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.05),
                      CircleAvatar(
                        radius: screenHeight * 0.04,
                        backgroundImage: AssetImage('sources/user/user1.jpg'), // Replace with your asset path
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'Welcome, Akmal!', // Replace with dynamic data if needed
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight * 0.025,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Akmal@gmail.com!', // Replace with dynamic data if needed
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: screenHeight * 0.018,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.0),
                _buildSidebarItem(
                  icon: FontAwesomeIcons.home,
                  title: 'Home',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildSidebarItem(
                  icon: FontAwesomeIcons.user,
                  title: 'Profile',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AccountPage()
                      ),
                    );
                  },
                ),
                _buildSidebarItem(
                  icon: FontAwesomeIcons.cog,
                  title: 'Settings',
                  onTap: () {
                    // Navigate to Settings
                  },
                ),
                Spacer(), // Pushes the logout button to the bottom
                Divider(color: Colors.white70),
                _buildSidebarItem(
                  icon: FontAwesomeIcons.signOutAlt,
                  title: 'Logout',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StartedPage(
                      )),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      onTap: onTap,
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue.shade900, Colors.black],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context,
            label: 'Calculate BMI',
            icon: FontAwesomeIcons.calculator,
            destination: Qrpage(),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                FontAwesomeIcons.qrcode,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Qrpage()));
              },
            ),
          ),
          _buildNavItem(
            context,
            label: 'Track Calorie',
            icon: FontAwesomeIcons.search,
            destination: Qrpage(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, {required String label, required IconData icon, required Widget destination}) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint) {
    return Container(
      width: 280,
      height: 40,// Adjust width here
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[300], fontSize: 12),
          filled: true,
          fillColor: Colors.grey.withOpacity(0.2),
          hintText: hint, // Add hint here
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 12), // Style the hint text
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(color: Colors.grey[300]),
      ),
    );
  }
}
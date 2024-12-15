import 'package:SihatSelaluApp/homepage.dart';
import 'package:SihatSelaluApp/saje2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profilepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Tracks whether the form fields are editable
  bool isEditable = false;

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
                SizedBox(height: screenHeight * 0.05),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight * 0.025,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: screenHeight * 0.06,
                            backgroundImage: NetworkImage('https://placehold.co/100x100'),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'YOUR NAME',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      _buildForm(context, screenHeight, screenWidth),
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
                color: Colors.white,
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
                Container(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.05),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.05),
                      CircleAvatar(
                        radius: screenHeight * 0.04,
                        backgroundImage: AssetImage('assets/profile.jpg'), // Replace with your asset path
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'John Doe', // Replace with dynamic data if needed
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight * 0.025,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'johndoe@example.com', // Replace with dynamic data if needed
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
                    // Navigate to Profile
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
                    // Handle logout
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

  Widget _buildForm(BuildContext context, double screenHeight, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // Edit button at the top
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isEditable = !isEditable; // Toggle editable state
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.edit,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4),
                    Text(
                      isEditable ? 'Cancel' : 'Edit', // Toggle button text
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Container(
            height: 45, // Adjust height as needed
            child: TextField(
              enabled: isEditable,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: isEditable
                    ? Colors.white.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10), // Adjust padding inside the TextField
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),

          SizedBox(height: 10),
          // Phone Number Field
          Container(
              height: 45,
              child: TextField(
                enabled: isEditable,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: isEditable
                      ? Colors.white.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
          ),
          SizedBox(height: 10),
          // Age Field
          Container(
              height: 45,
              child:TextField(
                enabled: isEditable,
                decoration: InputDecoration(
                  labelText: 'Age',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: isEditable
                      ? Colors.white.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
          ),
          SizedBox(height: 10),
          // Gender Field
          Container(
              height: 45,
              child:TextField(
                enabled: isEditable,
                decoration: InputDecoration(
                  labelText: 'Gender',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: isEditable
                      ? Colors.white.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
          ),
          SizedBox(height: screenHeight * 0.04),
          // Conditionally show the Save button
          if (isEditable)
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
            destination: AccountPage(),
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
                    context, MaterialPageRoute(builder: (context) => Homepage()));
              },
            ),
          ),
          _buildNavItem(
            context,
            label: 'Track Calorie',
            icon: FontAwesomeIcons.search,
            destination: AccountPage(),
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
}


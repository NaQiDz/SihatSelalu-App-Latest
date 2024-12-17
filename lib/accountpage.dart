import 'package:SihatSelaluApp/bottombar.dart';
import 'package:SihatSelaluApp/childpage.dart';
import 'package:SihatSelaluApp/header.dart';
import 'package:SihatSelaluApp/homepage.dart';
import 'package:SihatSelaluApp/profilepage.dart';
import 'package:SihatSelaluApp/sidebar.dart';
import 'package:SihatSelaluApp/started.dart';
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
                          MaterialPageRoute(builder: (context) => Homepage(
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


        /*AccountOption(
          title: 'Your Child',
          icon: FontAwesomeIcons.child,
        ),
        AccountOption(
          title: 'Record Health',
          icon: FontAwesomeIcons.heartbeat,
        ),
        AccountOption(
          title: 'History Usage',
          icon: FontAwesomeIcons.history,
        ),
        AccountOption(
          title: 'About System',
          icon: FontAwesomeIcons.infoCircle,
        ),*/


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
                    Text('email@gmail.com', style: TextStyle(color: Colors.white, fontSize: 12)),
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
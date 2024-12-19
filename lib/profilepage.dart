import 'package:SihatSelaluApp/accountpage.dart';
import 'package:SihatSelaluApp/bottombar.dart';
import 'package:SihatSelaluApp/header.dart';
import 'package:SihatSelaluApp/session_manager.dart';
import 'package:SihatSelaluApp/sidebar.dart';
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
  bool showEditButton = false; // Track if edit text should be shown
  String defaultImageUrl = 'https://placehold.co/100x100'; // Default image URL
  String? userImageUrl; // URL for user's profile image (can be null)

  @override
  Widget build(BuildContext context) {
    String? username = SessionManager.username;
    String? email = SessionManager.email;
    String? age = SessionManager.age;
    String? gender = SessionManager.gender;
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
                          MaterialPageRoute(builder: (context) => AccountPage()),
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
                        'Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight * 0.025,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showEditButton = !showEditButton;
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: screenHeight * 0.06,
                              backgroundImage: NetworkImage(userImageUrl ?? defaultImageUrl), // Use user image or default
                              backgroundColor: showEditButton ? Colors.white.withOpacity(0.5) : Colors.transparent,
                            ),
                            if (showEditButton) // Show the edit text conditionally
                              Container(
                                color: Colors.transparent,
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: Text(
                                  "Edit",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        username!.toUpperCase(),
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
      bottomNavigationBar: const BottomBar(),
    );
  }

  Widget _buildForm(BuildContext context, double screenHeight, double screenWidth) {
    String? email = SessionManager.email;
    String? age = SessionManager.age;
    String? gender = SessionManager.gender;
    String? phone = SessionManager.phone;

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
                    showEditButton = isEditable; // Show edit text when form is editable
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
          SizedBox(
            height: 20,
          ),
          Container(
            height: 45, // Adjust height as needed
            child: TextField(
              enabled: isEditable,
              decoration: InputDecoration(
                labelText: email!,
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: isEditable
                    ? Colors.white.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
                labelText: phone!,
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
            child: TextField(
              enabled: isEditable,
              decoration: InputDecoration(
                labelText: age!,
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
            child: TextField(
              enabled: isEditable,
              decoration: InputDecoration(
                labelText: gender!,
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
}
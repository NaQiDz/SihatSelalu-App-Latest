import 'package:SihatSelaluApp/accountpage.dart';
import 'package:SihatSelaluApp/home.dart';
import 'package:SihatSelaluApp/session_manager.dart';
import 'package:SihatSelaluApp/settings_screen.dart';
import 'package:SihatSelaluApp/started.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  String? username;
  String? id;
  String? email;
  String? icon;
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? errorMessage;


  @override
  void initState() {
    super.initState();
    _loadSessionData();
    fetchUser();
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
    setState(() {
      isLoading = true;
      errorMessage = null;
      userData = null;
    });
    try {
      serverIp = dotenv.env['ENVIRONMENT']! == 'dev' ? dotenv.env['DB_HOST_EMU']! : dotenv.env['DB_HOST_IP'];
      final response = await http.post(
        Uri.parse('http://$serverIp/SihatSelaluAppDatabase/manageuser.php'),
        body: {'username': username},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic> && data['error'] == null) {
          setState(() {
            userData = data;
          });
        }
      }
    } catch (e) {
      // Handle error
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Replace the hardcoded IP with the dynamically loaded serverIp
    final String serverIp = dotenv.env['ENVIRONMENT'] == 'dev'
        ? dotenv.env['DB_HOST_EMU']!
        : dotenv.env['DB_HOST_IP']!;

    return Drawer(
      child: Container(
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
                  if (userData?['Icon'] == null)
                    CircleAvatar(
                      radius: screenHeight * 0.04,
                      backgroundImage: NetworkImage(
                        'http://$serverIp/SihatSelaluAppDatabase/images/defaultprofile.png',
                      ),
                    ),
                  if (userData?['Icon'] != null)
                    CircleAvatar(
                      radius: screenHeight * 0.04,
                      backgroundImage: NetworkImage(
                        'http://$serverIp/SihatSelaluAppDatabase/${userData?['Icon']}',
                      ),
                    ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Welcome, $username!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenHeight * 0.025,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Email: $email',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: screenHeight * 0.012,
                    ),
                  ),
                ],
              ),
            ),
            // Sidebar Items
            _buildSidebarItem(
              icon: FontAwesomeIcons.home,
              title: 'Home',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            _buildSidebarItem(
              icon: FontAwesomeIcons.user,
              title: 'Account',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage()));
              },
            ),
            _buildSidebarItem(
              icon: FontAwesomeIcons.cog,
              title: 'Settings',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
                // Navigate to Settings
              },
            ),
            const Spacer(), // Pushes the logout button to the bottom
            const Divider(color: Colors.white70),
            _buildSidebarItem(
              icon: FontAwesomeIcons.signOutAlt,
              title: 'Logout',
              onTap: () async{
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('Email');
                prefs.remove('ID');
                prefs.remove('Username');
                SessionManager.clearSession();
                showPopup(context, "Logout", "You have been logged out", loginSession: false);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => StartedPage()),
                      (route) => false,
                );
              },
            ),
          ],
        ),
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
}

void showPopup(BuildContext context, String textMessage, String message, {bool loginSession = false}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      Future.delayed(Duration(seconds: 2), () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.grey.withOpacity(0.8),
        title: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                textMessage,
                style: TextStyle(
                  color: loginSession ? Colors.green : Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                message,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      );
    },
  );
}

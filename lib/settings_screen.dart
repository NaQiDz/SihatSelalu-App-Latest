import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:SihatSelaluApp/header.dart';
import 'package:SihatSelaluApp/sidebar.dart';
import 'package:SihatSelaluApp/bottombar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                      icon: const Icon(
                        FontAwesomeIcons.arrowLeft,
                        color: Colors.white,
                        size: 14,
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Navigate back to the previous screen
                      },
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                const Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person, color: Colors.white),
                      title: const Text("Profile", style: TextStyle(color: Colors.white)),
                      subtitle: const Text("Edit your profile details", style: TextStyle(color: Colors.white70)),
                      onTap: () {
                        // Add navigation or functionality for profile settings
                      },
                    ),
                    const Divider(color: Colors.white38),
                    ListTile(
                      leading: const Icon(Icons.notifications, color: Colors.white),
                      title: const Text("Notifications", style: TextStyle(color: Colors.white)),
                      subtitle: const Text("Manage notification settings", style: TextStyle(color: Colors.white70)),
                      onTap: () {
                        // Add navigation or functionality for notifications
                      },
                    ),
                    const Divider(color: Colors.white38),
                    ListTile(
                      leading: const Icon(Icons.lock, color: Colors.white),
                      title: const Text("Privacy", style: TextStyle(color: Colors.white)),
                      subtitle: const Text("Adjust privacy preferences", style: TextStyle(color: Colors.white70)),
                      onTap: () {
                        // Add navigation or functionality for privacy settings
                      },
                    ),
                    const Divider(color: Colors.white38),
                    ListTile(
                      leading: const Icon(Icons.language, color: Colors.white),
                      title: const Text("Language", style: TextStyle(color: Colors.white)),
                      subtitle: const Text("Select your preferred language", style: TextStyle(color: Colors.white70)),
                      onTap: () {
                        // Add navigation or functionality for language selection
                      },
                    ),
                    const Divider(color: Colors.white38),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.white),
                      title: const Text("Log Out", style: TextStyle(color: Colors.white)),
                      onTap: () {
                        // Add logout functionality
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
